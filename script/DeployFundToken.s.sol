// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script, console} from "forge-std/Script.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {FundToken} from "../src/upgradeable/FundToken.sol";

contract DeployFundToken is Script {
    function run() external {
        address admin = vm.envAddress("ADMIN_ADDRESS");
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerKey);

        address vaultAddress = vm.envOr("VAULT_ADDRESS", address(0));
        
        if (vaultAddress == address(0)) {
            console.log("NOTE: Deploying token before vault. Update VAULT_ADDRESS after vault deployment.");
            vaultAddress = address(0x1111111111111111111111111111111111111111);
        }

        console.log("=== FUND TOKEN DEPLOYMENT ===");
        console.log("Deployer:", deployer);
        console.log("Admin:", admin);
        console.log("Vault Address (minter):", vaultAddress);
        console.log("");

        vm.startBroadcast(deployerKey);

        console.log("1. Deploying FundToken implementation...");
        FundToken tokenImplementation = new FundToken(vaultAddress);
        console.log("Token implementation deployed at:", address(tokenImplementation));

        bytes memory tokenInitData = abi.encodeWithSelector(
            FundToken.initialize.selector,
            "LiquidVC Token",
            "LVC",
            admin
        );

        console.log("2. Deploying FundToken ERC1967Proxy...");
        ERC1967Proxy tokenProxy = new ERC1967Proxy(address(tokenImplementation), tokenInitData);
        console.log("Token proxy deployed at:", address(tokenProxy));

        vm.stopBroadcast();

        FundToken token = FundToken(address(tokenProxy));
        console.log("3. Verifying token deployment...");
        require(token.hasRole(token.DEFAULT_ADMIN_ROLE(), admin), "Admin role not set");
        
        (string memory name, string memory symbol, uint8 decimals) = token.getTokenInfo();
        require(keccak256(bytes(name)) == keccak256(bytes("LiquidVC Token")), "Name mismatch");
        require(keccak256(bytes(symbol)) == keccak256(bytes("LVC")), "Symbol mismatch");

        console.log("");
        console.log("=== DEPLOYMENT COMPLETE ===");
        console.log("Token Implementation:", address(tokenImplementation));
        console.log("Token Proxy:", address(tokenProxy));
        console.log("Token Name:", name);
        console.log("Token Symbol:", symbol);
        console.log("");
        console.log("TOKEN_ADDRESS=%s", address(tokenProxy));
    }
}

