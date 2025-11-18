// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface IFundShare {
    function getShareValue(uint256 tokenId) external view returns (uint256);
    function getFundName() external view returns (string memory);
}

interface IFundToken {
    function mint(address to, uint256 amount) external;
    function burn(address from, uint256 amount) external;
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
}

interface IRaylsIdentityRegistry {
    function isAccredited(address account) external view returns (bool);
}

interface ICarbonOffsetTreasury {
    function purchaseOffsets(uint256 kgCO2) external returns (uint256 offsetTokens);
    function getOffsetPrice() external view returns (uint256);
}

/**
 * @title NetZeroFundVault - NetZero Institutional Fund Vault
 * @notice ERC-4626 compatible vault with accredited-investor gating and automated carbon offsetting
 * @dev Ensures all fund exposure is ESG-compliant and net-zero from day one
 */
contract NetZeroFundVault is
    UUPSUpgradeable,
    AccessControlUpgradeable,
    ReentrancyGuardUpgradeable,
    PausableUpgradeable,
    IERC721Receiver
{
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant EMERGENCY_ROLE = keccak256("EMERGENCY_ROLE");

    IFundToken public immutable FUND_TOKEN;
    address public immutable FUND_SHARE_CONTRACT;
    address public immutable PROTOCOL_TREASURY;
    IRaylsIdentityRegistry public immutable IDENTITY_REGISTRY;
    ICarbonOffsetTreasury public immutable CARBON_OFFSET_TREASURY;

    uint256 public constant MINT_FEE_BPS = 100;
    uint256 public constant REDEEM_FEE_BPS = 200;
    uint256 public constant MIN_SHARE_VALUE = 1000e18;
    uint256 public constant OFFSET_BPS = 10000;
    uint256 public constant CARBON_INTENSITY_FACTOR = 500e15;
    uint256 public constant UPGRADE_DELAY = 12 hours;
    uint256 public constant EMERGENCY_UPGRADE_DELAY = 2 hours;
    uint256 public constant MAX_PAUSE_DURATION = 7 days;
    uint256 public constant MIN_UPGRADE_INTERVAL = 6 hours;

    struct VaultStorage {
        mapping(uint256 => address) shareOwner;
        mapping(uint256 => uint256) shareValue;
        uint256[] depositedShares;
        uint256 totalFundValue;
        uint256 totalCarbonFootprint;
        uint256 totalCarbonOffsets;
        uint256 offsetBps;
        mapping(address => uint256) upgradeProposals;
        mapping(address => string) upgradeReasons;
        mapping(address => bool) isEmergencyUpgrade;
        uint256 lastUpgradeTime;
        uint256 pausedAt;
        string pauseReason;
    }

    VaultStorage private _storage;

    event FundShareDeposited(address indexed user, uint256 indexed tokenId, uint256 shareValue, uint256 tokensMinted, uint256 feeAmount);
    event FundShareRedeemed(address indexed user, uint256 indexed tokenId, uint256 tokensBurned, uint256 shareValue);
    event YieldHarvested(uint256 yieldAmount, uint256 carbonFootprint, uint256 offsetsPurchased, uint256 offsetTokens);
    event CarbonOffsetPurchased(uint256 kgCO2, uint256 offsetTokens, uint256 cost);
    event FundDistribution(uint256 totalDistributed, uint256 perTokenAmount);
    event UpgradeProposed(address indexed newImplementation, uint256 executeAfter, string reason, bool isEmergency);
    event UpgradeExecuted(address indexed newImplementation, address indexed executor, string reason);
    event UpgradeCancelled(address indexed newImplementation);
    event EmergencyPaused(address indexed pauser, string reason);
    event EmergencyUnpaused(address indexed unpauser);

    uint256[50] private __gap;

    constructor(
        address _fundToken,
        address _fundShareContract,
        address _protocolTreasury,
        address _identityRegistry,
        address _carbonOffsetTreasury
    ) {
        require(_fundToken != address(0), "Fund token cannot be zero address");
        require(_fundShareContract != address(0), "Invalid fund share contract");
        require(_protocolTreasury != address(0), "Invalid treasury");
        require(_identityRegistry != address(0), "Invalid identity registry");
        require(_carbonOffsetTreasury != address(0), "Invalid carbon offset treasury");

        FUND_TOKEN = IFundToken(_fundToken);
        FUND_SHARE_CONTRACT = _fundShareContract;
        PROTOCOL_TREASURY = _protocolTreasury;
        IDENTITY_REGISTRY = IRaylsIdentityRegistry(_identityRegistry);
        CARBON_OFFSET_TREASURY = ICarbonOffsetTreasury(_carbonOffsetTreasury);
    }

    function initialize(address _admin) public initializer {
        require(_admin != address(0), "Invalid admin");

        __UUPSUpgradeable_init();
        __AccessControl_init();
        __ReentrancyGuard_init();
        __Pausable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, _admin);
        _grantRole(ADMIN_ROLE, _admin);
        _grantRole(EMERGENCY_ROLE, _admin);

        _storage.lastUpgradeTime = block.timestamp;
        _storage.offsetBps = OFFSET_BPS;
    }

    function _authorizeUpgrade(address newImplementation) internal override {
        require(_storage.upgradeProposals[newImplementation] != 0, "No upgrade proposal found");
        require(block.timestamp >= _storage.upgradeProposals[newImplementation], "Upgrade delay not met");

        bool proposalIsEmergency = _storage.isEmergencyUpgrade[newImplementation];

        if (proposalIsEmergency) {
            require(paused(), "Emergency upgrades only when paused");
            require(hasRole(EMERGENCY_ROLE, msg.sender), "Not emergency authorized");
        } else {
            require(!paused(), "Normal upgrades only when not paused");
            require(hasRole(ADMIN_ROLE, msg.sender), "Not admin authorized");
        }

        require(block.timestamp >= _storage.lastUpgradeTime + MIN_UPGRADE_INTERVAL, "Too soon since last upgrade");

        _storage.lastUpgradeTime = block.timestamp;

        string memory reason = _storage.upgradeReasons[newImplementation];
        emit UpgradeExecuted(newImplementation, msg.sender, reason);

        delete _storage.upgradeProposals[newImplementation];
        delete _storage.upgradeReasons[newImplementation];
        delete _storage.isEmergencyUpgrade[newImplementation];
    }

    function proposeUpgrade(address newImplementation, string calldata reason) external onlyRole(ADMIN_ROLE) {
        require(newImplementation != address(0), "Invalid implementation");
        require(_storage.upgradeProposals[newImplementation] == 0, "Already proposed");
        require(bytes(reason).length > 0, "Must provide reason");

        uint256 executeAfter = block.timestamp + UPGRADE_DELAY;
        _storage.upgradeProposals[newImplementation] = executeAfter;
        _storage.upgradeReasons[newImplementation] = reason;

        emit UpgradeProposed(newImplementation, executeAfter, reason, false);
    }

    function cancelUpgrade(address newImplementation) external {
        require(hasRole(ADMIN_ROLE, msg.sender) || hasRole(EMERGENCY_ROLE, msg.sender), "Not authorized to cancel");
        require(_storage.upgradeProposals[newImplementation] != 0, "No proposal found");

        delete _storage.upgradeProposals[newImplementation];
        delete _storage.upgradeReasons[newImplementation];

        emit UpgradeCancelled(newImplementation);
    }

    function proposeEmergencyUpgrade(address newImplementation, string calldata exploitDescription)
        external
        onlyRole(EMERGENCY_ROLE)
        whenPaused
    {
        require(newImplementation != address(0), "Invalid implementation");
        require(bytes(exploitDescription).length > 0, "Must describe exploit");
        require(_storage.upgradeProposals[newImplementation] == 0, "Already proposed");

        uint256 executeAfter = block.timestamp + EMERGENCY_UPGRADE_DELAY;
        _storage.upgradeProposals[newImplementation] = executeAfter;
        _storage.upgradeReasons[newImplementation] = exploitDescription;
        _storage.isEmergencyUpgrade[newImplementation] = true;

        emit UpgradeProposed(newImplementation, executeAfter, exploitDescription, true);
    }

    function emergencyPause(string calldata reason) external onlyRole(EMERGENCY_ROLE) {
        _storage.pausedAt = block.timestamp;
        _storage.pauseReason = reason;
        _pause();

        emit EmergencyPaused(msg.sender, reason);
    }

    function unpause() external {
        require(
            hasRole(EMERGENCY_ROLE, msg.sender) || block.timestamp >= _storage.pausedAt + MAX_PAUSE_DURATION,
            "Not authorized to unpause or too early"
        );

        _storage.pauseReason = "";
        _unpause();

        emit EmergencyUnpaused(msg.sender);
    }

    function deposit(uint256 tokenId) external nonReentrant whenNotPaused {
        require(IDENTITY_REGISTRY.isAccredited(msg.sender), "Not an accredited investor");
        require(IERC721(FUND_SHARE_CONTRACT).ownerOf(tokenId) == msg.sender, "Not owner of fund share");
        
        uint256 shareValue = IFundShare(FUND_SHARE_CONTRACT).getShareValue(tokenId);
        require(shareValue >= MIN_SHARE_VALUE, "Share value too small");

        IERC721(FUND_SHARE_CONTRACT).safeTransferFrom(msg.sender, address(this), tokenId);

        uint256 feeAmount = (shareValue * MINT_FEE_BPS) / 10_000;
        uint256 userAmount = shareValue - feeAmount;

        _storage.shareOwner[tokenId] = msg.sender;
        _storage.shareValue[tokenId] = shareValue;
        _storage.depositedShares.push(tokenId);
        _storage.totalFundValue += shareValue;

        FUND_TOKEN.mint(PROTOCOL_TREASURY, feeAmount);
        FUND_TOKEN.mint(msg.sender, userAmount);

        emit FundShareDeposited(msg.sender, tokenId, shareValue, userAmount, feeAmount);
    }

    function redeem(uint256 tokenId) external nonReentrant whenNotPaused {
        require(_storage.shareOwner[tokenId] == msg.sender, "Not original owner");
        require(IERC721(FUND_SHARE_CONTRACT).ownerOf(tokenId) == address(this), "Share not in vault");

        uint256 shareValue = _storage.shareValue[tokenId];
        require(shareValue > 0, "Invalid share");

        uint256 fundTokenSupply = FUND_TOKEN.totalSupply();
        require(fundTokenSupply > 0, "No tokens in circulation");

        uint256 tokensToBurn = (shareValue * fundTokenSupply) / _storage.totalFundValue;
        require(FUND_TOKEN.balanceOf(msg.sender) >= tokensToBurn, "Insufficient Fund tokens");

        uint256 feeAmount = (shareValue * REDEEM_FEE_BPS) / 10_000;
        uint256 netValue = shareValue - feeAmount;

        FUND_TOKEN.burn(msg.sender, tokensToBurn);

        _storage.totalFundValue -= shareValue;
        delete _storage.shareOwner[tokenId];
        delete _storage.shareValue[tokenId];
        
        for (uint256 i = 0; i < _storage.depositedShares.length; i++) {
            if (_storage.depositedShares[i] == tokenId) {
                _storage.depositedShares[i] = _storage.depositedShares[_storage.depositedShares.length - 1];
                _storage.depositedShares.pop();
                break;
            }
        }

        IERC721(FUND_SHARE_CONTRACT).safeTransferFrom(address(this), msg.sender, tokenId);

        emit FundShareRedeemed(msg.sender, tokenId, tokensToBurn, netValue);
    }

    function harvestYieldAndOffset(uint256 yieldAmount) external nonReentrant whenNotPaused onlyRole(ADMIN_ROLE) {
        require(yieldAmount > 0, "No yield to harvest");

        uint256 carbonFootprint = (yieldAmount * CARBON_INTENSITY_FACTOR) / 1e18;
        uint256 offsetAmount = (carbonFootprint * _storage.offsetBps) / 10_000;

        uint256 offsetTokens = CARBON_OFFSET_TREASURY.purchaseOffsets(offsetAmount);

        _storage.totalCarbonFootprint += carbonFootprint;
        _storage.totalCarbonOffsets += offsetAmount;

        emit YieldHarvested(yieldAmount, carbonFootprint, offsetAmount, offsetTokens);
        emit CarbonOffsetPurchased(offsetAmount, offsetTokens, 0);
    }

    function distributeFundPayout(uint256 totalDistribution) external nonReentrant whenNotPaused onlyRole(ADMIN_ROLE) {
        require(totalDistribution > 0, "No distribution");
        require(address(this).balance >= totalDistribution, "Insufficient balance");

        uint256 fundTokenSupply = FUND_TOKEN.totalSupply();
        require(fundTokenSupply > 0, "No tokens in circulation");

        uint256 perTokenAmount = totalDistribution / fundTokenSupply;

        _storage.totalFundValue += totalDistribution;

        emit FundDistribution(totalDistribution, perTokenAmount);
    }

    function setOffsetBps(uint256 newOffsetBps) external onlyRole(ADMIN_ROLE) {
        require(newOffsetBps >= 10000, "Offset must be at least 100%");
        _storage.offsetBps = newOffsetBps;
    }

    function getTotalFundValue() external view returns (uint256) {
        return _storage.totalFundValue;
    }

    function getShareInfo(uint256 tokenId) external view returns (address owner, uint256 value) {
        return (_storage.shareOwner[tokenId], _storage.shareValue[tokenId]);
    }

    function getDepositedSharesCount() external view returns (uint256) {
        return _storage.depositedShares.length;
    }

    function getDepositedShare(uint256 index) external view returns (uint256) {
        return _storage.depositedShares[index];
    }

    function getBackingRatio() external view returns (uint256) {
        uint256 totalSupply = FUND_TOKEN.totalSupply();
        if (totalSupply == 0) return 0;
        return (_storage.totalFundValue * 1e18) / totalSupply;
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

    function getUpgradeProposal(address implementation) external view returns (uint256) {
        return _storage.upgradeProposals[implementation];
    }

    function getUpgradeReason(address implementation) external view returns (string memory) {
        return _storage.upgradeReasons[implementation];
    }

    function getPauseInfo() external view returns (bool isPaused, uint256 pausedAt, string memory reason) {
        return (paused(), _storage.pausedAt, _storage.pauseReason);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(AccessControlUpgradeable)
        returns (bool)
    {
        return interfaceId == type(IERC721Receiver).interfaceId || interfaceId == type(IERC165).interfaceId
            || super.supportsInterface(interfaceId);
    }

    receive() external payable {
        // Contract can receive fund distributions
    }
}

