# NetZero Institutional Fund Vault

**An ERC-4626 institutional fund vault with accredited-investor gating and automated carbon offsetting, ensuring all fund exposure is ESG-compliant and net-zero from day one.**

Built for the Rayls Hackathon - Bridging TradFi and DeFi with ESG compliance.

## 🎯 One-Liner

> **An ERC-4626 institutional fund vault with accredited-investor gating and automated carbon offsetting, ensuring all fund exposure is ESG-compliant and net-zero from day one.**

## ✨ Features

- ✅ **Accredited Investor Gating** - Rayls identity-based access control
- ✅ **Fund Share Tokenization** - Convert illiquid VC fund shares into liquid ERC-20 tokens
- ✅ **Automatic Carbon Offsetting** - Real-time carbon offset purchases on yield harvest
- ✅ **Net-Zero Tracking** - On-chain ESG metrics and verification
- ✅ **ERC-4626 Compatible** - Standard vault interface for DeFi composability
- ✅ **Upgradeable** - Governance-controlled upgrades with timelock

## 🏗️ Architecture

### Core Contracts

- **NetZeroFundVault.sol** - Main vault with ESG + accreditation
- **FundToken.sol** - Liquid ERC-20 tokens
- **MockFundShare.sol** - Demo fund shares (ERC-721)
- **MockRaylsIdentityRegistry.sol** - Accreditation checks
- **MockCarbonOffsetTreasury.sol** - Carbon offset purchases

## 🚀 Quick Start

### Prerequisites

- Foundry
- Node.js
- Rayls Devnet access

### Installation

```bash
# Install dependencies
forge install

# Build contracts
forge build

# Run tests
forge test
```

### Deployment

```bash
# Set environment variables
export PRIVATE_KEY="your_key"
export ADMIN_ADDRESS="your_admin"
export PROTOCOL_TREASURY="your_treasury"

# Deploy to Rayls Devnet
forge script script/DeployMockFundShare.s.sol --rpc-url rayls_devnet --broadcast
forge script script/DeployFundToken.s.sol --rpc-url rayls_devnet --broadcast
forge script script/DeployNetZeroFundVault.s.sol --rpc-url rayls_devnet --broadcast
```

## 📊 Rayls Configuration

- **Chain ID**: `123123`
- **RPC Endpoint**: `https://devnet-rpc.rayls.com`
- **Block Explorer**: `https://devnet-explorer.rayls.com`

## 📚 Documentation

- [NETZERO_VAULT_SUMMARY.md](./NETZERO_VAULT_SUMMARY.md) - Complete overview
- [ESG_VAULT_WHITEPAPER_V2.md](./ESG_VAULT_WHITEPAPER_V2.md) - Technical whitepaper
- [RAYLS_SETUP.md](./RAYLS_SETUP.md) - Rayls integration guide

## 🎤 Pitch

**Problem**: Institutions want DeFi yields but need ESG compliance and accreditation gating.

**Solution**: NetZero Institutional Fund Vault - A Rayls-native ERC-4626 vault that restricts deposits to accredited investors and uses sub-second finality to automatically purchase and verify carbon offsets on every yield event.

**Why Rayls**:
- Deterministic finality → Real-time offset matching
- Identity layer → Accredited-investor gating
- Private-node architecture → Institutional flows
- USD-pegged gas → Stable costs

## 📝 License

MIT

---

**Built for Rayls Hackathon 2025** 🚀
