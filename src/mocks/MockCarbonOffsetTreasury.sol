// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract MockCarbonOffsetTreasury {
    uint256 public constant OFFSET_PRICE = 50e18;
    uint256 public totalOffsetsPurchased;
    uint256 public totalOffsetTokensMinted;

    mapping(address => uint256) public offsetTokenBalance;

    event OffsetsPurchased(address indexed buyer, uint256 kgCO2, uint256 offsetTokens, uint256 cost);
    event OffsetTokensMinted(address indexed to, uint256 amount);

    function purchaseOffsets(uint256 kgCO2) external returns (uint256 offsetTokens) {
        require(kgCO2 > 0, "Must offset positive amount");

        uint256 cost = (kgCO2 * OFFSET_PRICE) / 1e18;
        offsetTokens = kgCO2;

        totalOffsetsPurchased += kgCO2;
        totalOffsetTokensMinted += offsetTokens;
        offsetTokenBalance[msg.sender] += offsetTokens;

        emit OffsetsPurchased(msg.sender, kgCO2, offsetTokens, cost);
        emit OffsetTokensMinted(msg.sender, offsetTokens);

        return offsetTokens;
    }

    function getOffsetPrice() external pure returns (uint256) {
        return OFFSET_PRICE;
    }

    function getTotalOffsets() external view returns (uint256) {
        return totalOffsetsPurchased;
    }

    function getOffsetTokenBalance(address account) external view returns (uint256) {
        return offsetTokenBalance[account];
    }
}

