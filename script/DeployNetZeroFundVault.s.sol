// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script, console} from "forge-std/Script.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {NetZeroFundVault} from "../src/upgradeable/NetZeroFundVault.sol";

contract DeployNetZeroFundVault is Script {
    function run() external {
        address tokenAddress = vm.envAddress("TOKEN_ADDRESS");
        address fundShareContract = vm.envAddress("FUND_SHARE_CONTRACT");
        address protocolTreasury = vm.envAddress("PROTOCOL_TREASURY");
        address identityRegistry = vm.envAddress("IDENTITY_REGISTRY");
        address carbonOffsetTreasury = vm.envAddress("CARBON_OFFSET_TREASURY");
        address admin = vm.envAddress("ADMIN_ADDRESS");
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerKey);

        console.log("=== NETZERO FUND VAULT DEPLOYMENT ===");
        console.log("Deployer:", deployer);
        console.log("Token Address:", tokenAddress);
        console.log("Fund Share Contract:", fundShareContract);
        console.log("Protocol Treasury:", protocolTreasury);
        console.log("Identity Registry:", identityRegistry);
        console.log("Carbon Offset Treasury:", carbonOffsetTreasury);
        console.log("Admin (Multisig):", admin);
        console.log("");

        vm.startBroadcast(deployerKey);

        console.log("1. Deploying NetZeroFundVault implementation...");
        NetZeroFundVault vaultImplementation = new NetZeroFundVault(
            tokenAddress,
            fundShareContract,
            protocolTreasury,
            identityRegistry,
            carbonOffsetTreasury
        );
        console.log("Vault implementation deployed at:", address(vaultImplementation));

        bytes memory vaultInitData = abi.encodeWithSelector(NetZeroFundVault.initialize.selector, admin);

        console.log("2. Deploying NetZeroFundVault ERC1967Proxy...");
        ERC1967Proxy vaultProxy = new ERC1967Proxy(address(vaultImplementation), vaultInitData);
        console.log("Vault proxy deployed at:", address(vaultProxy));

        vm.stopBroadcast();

        NetZeroFundVault vault = NetZeroFundVault(payable(address(vaultProxy)));
        console.log("3. Verifying vault deployment...");
        require(address(vault.FUND_TOKEN()) == tokenAddress, "Token address mismatch");
        require(vault.FUND_SHARE_CONTRACT() == fundShareContract, "Fund share contract mismatch");
        require(vault.PROTOCOL_TREASURY() == protocolTreasury, "Treasury mismatch");
        require(vault.hasRole(vault.DEFAULT_ADMIN_ROLE(), admin), "Admin role not set");

        console.log("");
        console.log("=== DEPLOYMENT COMPLETE ===");
        console.log("Vault Implementation:", address(vaultImplementation));
        console.log("Vault Proxy:", address(vaultProxy));
        console.log("");
        console.log("VAULT_ADDRESS=%s", address(vaultProxy));
        console.log("VAULT_IMPLEMENTATION=%s", address(vaultImplementation));
    }
}

