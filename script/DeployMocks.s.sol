// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script, console} from "forge-std/Script.sol";
import {MockRaylsIdentityRegistry} from "../src/mocks/MockRaylsIdentityRegistry.sol";
import {MockCarbonOffsetTreasury} from "../src/mocks/MockCarbonOffsetTreasury.sol";

contract DeployMocks is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerKey);

        console.log("=== MOCK CONTRACTS DEPLOYMENT ===");
        console.log("Deployer:", deployer);
        console.log("");

        vm.startBroadcast(deployerKey);

        console.log("1. Deploying MockRaylsIdentityRegistry...");
        MockRaylsIdentityRegistry identityRegistry = new MockRaylsIdentityRegistry();
        console.log("Identity Registry deployed at:", address(identityRegistry));

        console.log("2. Deploying MockCarbonOffsetTreasury...");
        MockCarbonOffsetTreasury carbonTreasury = new MockCarbonOffsetTreasury();
        console.log("Carbon Offset Treasury deployed at:", address(carbonTreasury));

        console.log("3. Granting accreditation to deployer...");
        identityRegistry.grantAccreditation(deployer);
        console.log("Deployer accredited");

        vm.stopBroadcast();

        console.log("");
        console.log("=== DEPLOYMENT COMPLETE ===");
        console.log("Identity Registry:", address(identityRegistry));
        console.log("Carbon Offset Treasury:", address(carbonTreasury));
        console.log("");
        console.log("IDENTITY_REGISTRY=%s", address(identityRegistry));
        console.log("CARBON_OFFSET_TREASURY=%s", address(carbonTreasury));
    }
}

