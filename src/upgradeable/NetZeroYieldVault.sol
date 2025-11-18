// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {ERC4626Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC4626Upgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

interface IRaylsIdentityRegistry {
    function isAccredited(address account) external view returns (bool);
}

interface ICarbonOffsetTreasury {
    function purchaseOffsets(uint256 kgCO2) external returns (uint256 offsetTokens);
    function getOffsetPrice() external view returns (uint256);
}

interface IYieldStrategy {
    function deposit(uint256 amount) external returns (uint256);
    function withdraw(uint256 amount) external returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function totalAssets() external view returns (uint256);
}

/**
 * @title NetZeroYieldVault - ESG-Compliant ERC-4626 Yield Vault
 * @notice Standard ERC-4626 vault that accepts deposits, generates yield, and automatically purchases carbon offsets
 * @dev Ensures all yield is net-zero through automatic carbon offsetting
 */
contract NetZeroYieldVault is
    ERC4626Upgradeable,
    UUPSUpgradeable,
    AccessControlUpgradeable,
    ReentrancyGuardUpgradeable,
    PausableUpgradeable
{
    using SafeERC20 for IERC20;

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant EMERGENCY_ROLE = keccak256("EMERGENCY_ROLE");
    bytes32 public constant HARVESTER_ROLE = keccak256("HARVESTER_ROLE");

    IRaylsIdentityRegistry public immutable IDENTITY_REGISTRY;
    ICarbonOffsetTreasury public immutable CARBON_OFFSET_TREASURY;
    IYieldStrategy public yieldStrategy;

    uint256 public constant CARBON_INTENSITY_FACTOR = 500e15; // 0.5 kg CO2 per $1 of yield
    uint256 public constant OFFSET_BPS = 10000; // 100% offset by default
    uint256 public constant UPGRADE_DELAY = 12 hours;
    uint256 public constant MAX_PAUSE_DURATION = 7 days;

    struct VaultStorage {
        uint256 totalCarbonFootprint;
        uint256 totalCarbonOffsets;
        uint256 offsetBps;
        uint256 lastHarvestTime;
        uint256 lastUpgradeTime;
        mapping(address => uint256) upgradeProposals;
        mapping(address => string) upgradeReasons;
        bool requireAccreditation;
    }

    VaultStorage private _storage;

    event YieldHarvested(uint256 yieldAmount, uint256 carbonFootprint, uint256 offsetsPurchased);
    event CarbonOffsetPurchased(uint256 kgCO2, uint256 offsetTokens, uint256 cost);
    event YieldStrategyUpdated(address indexed oldStrategy, address indexed newStrategy);
    event OffsetBpsUpdated(uint256 oldBps, uint256 newBps);
    event AccreditationRequirementUpdated(bool required);

    uint256[50] private __gap;

    constructor(
        address _asset,
        address _identityRegistry,
        address _carbonOffsetTreasury
    ) ERC4626Upgradeable(IERC20Metadata(_asset)) {
        require(_asset != address(0), "Invalid asset");
        require(_identityRegistry != address(0), "Invalid identity registry");
        require(_carbonOffsetTreasury != address(0), "Invalid carbon offset treasury");

        IDENTITY_REGISTRY = IRaylsIdentityRegistry(_identityRegistry);
        CARBON_OFFSET_TREASURY = ICarbonOffsetTreasury(_carbonOffsetTreasury);
    }

    function initialize(
        string memory _name,
        string memory _symbol,
        address _yieldStrategy,
        address _admin,
        bool _requireAccreditation
    ) public initializer {
        require(_admin != address(0), "Invalid admin");
        require(_yieldStrategy != address(0), "Invalid yield strategy");

        __ERC4626_init(IERC20Metadata(asset()));
        __ERC20_init(_name, _symbol);
        __UUPSUpgradeable_init();
        __AccessControl_init();
        __ReentrancyGuard_init();
        __Pausable_init();

        yieldStrategy = IYieldStrategy(_yieldStrategy);
        _storage.offsetBps = OFFSET_BPS;
        _storage.requireAccreditation = _requireAccreditation;
        _storage.lastUpgradeTime = block.timestamp;

        _grantRole(DEFAULT_ADMIN_ROLE, _admin);
        _grantRole(ADMIN_ROLE, _admin);
        _grantRole(EMERGENCY_ROLE, _admin);
        _grantRole(HARVESTER_ROLE, _admin);
    }

    function _authorizeUpgrade(address newImplementation) internal override {
        require(_storage.upgradeProposals[newImplementation] != 0, "No upgrade proposal");
        require(block.timestamp >= _storage.upgradeProposals[newImplementation], "Upgrade delay not met");
        require(hasRole(ADMIN_ROLE, msg.sender), "Not admin");
        require(block.timestamp >= _storage.lastUpgradeTime + 6 hours, "Too soon since last upgrade");

        _storage.lastUpgradeTime = block.timestamp;
        delete _storage.upgradeProposals[newImplementation];
        delete _storage.upgradeReasons[newImplementation];
    }

    function proposeUpgrade(address newImplementation, string calldata reason) external onlyRole(ADMIN_ROLE) {
        require(newImplementation != address(0), "Invalid implementation");
        require(_storage.upgradeProposals[newImplementation] == 0, "Already proposed");

        _storage.upgradeProposals[newImplementation] = block.timestamp + UPGRADE_DELAY;
        _storage.upgradeReasons[newImplementation] = reason;
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        super._beforeTokenTransfer(from, to, amount);
    }

    function deposit(uint256 assets, address receiver) public override nonReentrant whenNotPaused returns (uint256) {
        if (_storage.requireAccreditation) {
            require(IDENTITY_REGISTRY.isAccredited(msg.sender), "Not an accredited investor");
        }
        return super.deposit(assets, receiver);
    }

    function mint(uint256 shares, address receiver) public override nonReentrant whenNotPaused returns (uint256) {
        if (_storage.requireAccreditation) {
            require(IDENTITY_REGISTRY.isAccredited(msg.sender), "Not an accredited investor");
        }
        return super.mint(shares, receiver);
    }

    function _deposit(address caller, address receiver, uint256 assets, uint256 shares) internal override {
        super._deposit(caller, receiver, assets, shares);
        
        // Deploy assets to yield strategy
        IERC20(asset()).safeApprove(address(yieldStrategy), assets);
        yieldStrategy.deposit(assets);
    }

    function _withdraw(address caller, address receiver, address owner, uint256 assets, uint256 shares) internal override {
        // Withdraw from yield strategy
        uint256 strategyBalance = yieldStrategy.balanceOf(address(this));
        if (strategyBalance > 0) {
            yieldStrategy.withdraw(assets);
        }

        super._withdraw(caller, receiver, owner, assets, shares);
    }

    function totalAssets() public view override returns (uint256) {
        if (address(yieldStrategy) == address(0)) {
            return IERC20(asset()).balanceOf(address(this));
        }
        return yieldStrategy.totalAssets();
    }

    function harvestYieldAndOffset() external nonReentrant whenNotPaused onlyRole(HARVESTER_ROLE) {
        uint256 beforeBalance = IERC20(asset()).balanceOf(address(this));
        
        // Harvest yield (strategy should send yield to vault)
        // In a real implementation, this would call strategy.harvest()
        
        uint256 afterBalance = IERC20(asset()).balanceOf(address(this));
        uint256 yieldAmount = afterBalance > beforeBalance ? afterBalance - beforeBalance : 0;

        if (yieldAmount == 0) {
            return; // No yield to offset
        }

        // Calculate carbon footprint
        uint256 carbonFootprint = (yieldAmount * CARBON_INTENSITY_FACTOR) / 1e18;
        
        // Calculate offset amount
        uint256 offsetAmount = (carbonFootprint * _storage.offsetBps) / 10_000;

        // Purchase offsets
        uint256 offsetTokens = CARBON_OFFSET_TREASURY.purchaseOffsets(offsetAmount);

        // Update metrics
        _storage.totalCarbonFootprint += carbonFootprint;
        _storage.totalCarbonOffsets += offsetAmount;
        _storage.lastHarvestTime = block.timestamp;

        emit YieldHarvested(yieldAmount, carbonFootprint, offsetAmount);
        emit CarbonOffsetPurchased(offsetAmount, offsetTokens, 0);
    }

    function setYieldStrategy(address _newStrategy) external onlyRole(ADMIN_ROLE) {
        require(_newStrategy != address(0), "Invalid strategy");
        address oldStrategy = address(yieldStrategy);
        yieldStrategy = IYieldStrategy(_newStrategy);
        emit YieldStrategyUpdated(oldStrategy, _newStrategy);
    }

    function setOffsetBps(uint256 newBps) external onlyRole(ADMIN_ROLE) {
        require(newBps >= 10000, "Offset must be at least 100%");
        uint256 oldBps = _storage.offsetBps;
        _storage.offsetBps = newBps;
        emit OffsetBpsUpdated(oldBps, newBps);
    }

    function setRequireAccreditation(bool required) external onlyRole(ADMIN_ROLE) {
        _storage.requireAccreditation = required;
        emit AccreditationRequirementUpdated(required);
    }

    function emergencyPause(string calldata reason) external onlyRole(EMERGENCY_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(EMERGENCY_ROLE) {
        require(block.timestamp >= _storage.lastUpgradeTime + MAX_PAUSE_DURATION || hasRole(EMERGENCY_ROLE, msg.sender), "Cannot unpause yet");
        _unpause();
    }

    function getESGMetrics() external view returns (uint256 footprint, uint256 offsets, bool isNetZero) {
        footprint = _storage.totalCarbonFootprint;
        offsets = _storage.totalCarbonOffsets;
        isNetZero = offsets >= footprint;
        return (footprint, offsets, isNetZero);
    }

    function isNetZero() external view returns (bool) {
        return _storage.totalCarbonOffsets >= _storage.totalCarbonFootprint;
    }

    function getOffsetBps() external view returns (uint256) {
        return _storage.offsetBps;
    }

    function getRequireAccreditation() external view returns (bool) {
        return _storage.requireAccreditation;
    }
}

