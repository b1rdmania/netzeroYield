// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

interface IYieldStrategy {
    function deposit(uint256 amount) external returns (uint256);
    function withdraw(uint256 amount) external returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function totalAssets() external view returns (uint256);
}

/**
 * @title MockYieldStrategy - Simple yield strategy for demo
 * @notice Simulates a yield-generating strategy (e.g., lending, LP)
 */
contract MockYieldStrategy is IYieldStrategy {
    using SafeERC20 for IERC20;

    IERC20 public immutable asset;
    uint256 public constant APY_BPS = 800; // 8% APY
    uint256 public constant SECONDS_PER_YEAR = 365 days;

    mapping(address => uint256) private _balances;
    uint256 private _totalDeposited;
    uint256 private _totalYieldGenerated;
    uint256 public lastUpdateTime;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event YieldGenerated(uint256 amount);

    constructor(address _asset) {
        asset = IERC20(_asset);
        lastUpdateTime = block.timestamp;
    }

    function deposit(uint256 amount) external returns (uint256) {
        asset.safeTransferFrom(msg.sender, address(this), amount);
        _balances[msg.sender] += amount;
        _totalDeposited += amount;
        lastUpdateTime = block.timestamp;
        emit Deposited(msg.sender, amount);
        return amount;
    }

    function withdraw(uint256 amount) external returns (uint256) {
        require(_balances[msg.sender] >= amount, "Insufficient balance");
        
        // Calculate yield earned
        uint256 yield = calculateYield(msg.sender);
        uint256 totalWithdraw = amount + yield;
        
        _balances[msg.sender] -= amount;
        _totalDeposited -= amount;
        _totalYieldGenerated += yield;
        
        asset.safeTransfer(msg.sender, totalWithdraw);
        emit Withdrawn(msg.sender, totalWithdraw);
        return totalWithdraw;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account] + calculateYield(account);
    }

    function totalAssets() external view returns (uint256) {
        uint256 totalYield = calculateTotalYield();
        return _totalDeposited + totalYield;
    }

    function calculateYield(address account) public view returns (uint256) {
        if (_balances[account] == 0) return 0;
        uint256 timeElapsed = block.timestamp - lastUpdateTime;
        return (_balances[account] * APY_BPS * timeElapsed) / (SECONDS_PER_YEAR * 10_000);
    }

    function calculateTotalYield() public view returns (uint256) {
        uint256 timeElapsed = block.timestamp - lastUpdateTime;
        return (_totalDeposited * APY_BPS * timeElapsed) / (SECONDS_PER_YEAR * 10_000);
    }

    function harvest() external {
        uint256 yield = calculateTotalYield();
        if (yield > 0) {
            _totalYieldGenerated += yield;
            lastUpdateTime = block.timestamp;
            emit YieldGenerated(yield);
        }
    }
}

