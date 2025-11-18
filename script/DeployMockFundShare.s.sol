// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script, console} from "forge-std/Script.sol";
import {MockFundShare} from "../src/mocks/MockFundShare.sol";

contract DeployMockFundShare is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerKey);

        console.log("=== MOCK FUND SHARE DEPLOYMENT ===");
        console.log("Deployer:", deployer);
        console.log("");

        vm.startBroadcast(deployerKey);

        console.log("Deploying MockFundShare...");
        MockFundShare fundShare = new MockFundShare(
            "VC Fund Share",
            "VCFUND",
            "LiquidVC Fund I"
        );
        console.log("MockFundShare deployed at:", address(fundShare));

        console.log("Minting demo fund shares...");
        fundShare.mint(deployer, 10000e18, 1, "LiquidVC Fund I");
        fundShare.mint(deployer, 50000e18, 1, "LiquidVC Fund I");
        fundShare.mint(deployer, 25000e18, 1, "LiquidVC Fund I");
        console.log("Demo shares minted to:", deployer);

        vm.stopBroadcast();

        console.log("");
        console.log("=== DEPLOYMENT COMPLETE ===");
        console.log("MockFundShare:", address(fundShare));
        console.log("");
        console.log("FUND_SHARE_CONTRACT=%s", address(fundShare));
    }
}

