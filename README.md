# NetZero Yield

**ESG-Compliant ERC-4626 Yield Vault for Institutional DeFi**

> Standard ERC-4626 vault that generates yield and automatically purchases carbon offsets. Net-zero from day one. Built on Rayls.

---

## 🎯 What This Is

**NetZero Yield** is an ERC-4626 compliant yield vault that:
- Accepts USDC deposits from accredited investors
- Deploys assets to yield-generating strategies
- Automatically purchases carbon offsets on yield harvest
- Maintains net-zero carbon profile
- Provides transparent ESG metrics on-chain

**Built for:** Institutional investors who need ESG-compliant DeFi yields

---

## 🏗️ Architecture

### Core Contracts

1. **NetZeroYieldVault.sol** - Main ERC-4626 vault
   - Standard ERC-4626 interface
   - Accredited investor gating (Rayls identity)
   - Automatic carbon offsetting
   - ESG metrics tracking

2. **MockYieldStrategy.sol** - Demo yield strategy
   - Simulates 8% APY
   - For testing/demo purposes

3. **Mock Contracts**
   - `MockRaylsIdentityRegistry.sol` - Accreditation checks
   - `MockCarbonOffsetTreasury.sol` - Carbon offset purchases

### How It Works

```
1. User deposits USDC → Vault
2. Vault deploys to yield strategy → Generates yield
3. Admin harvests yield → Vault auto-purchases carbon offsets
4. User receives yield + ESG compliance
5. User can withdraw anytime (burn shares → get USDC)
```

---

## 🚀 Quick Start

### Prerequisites

- Node.js 18+
- Foundry
- Rayls Devnet access

### Setup

```bash
# Install dependencies
cd frontend && npm install

# Start dev server
npm run dev

# In another terminal - compile contracts
cd .. && forge build
```

### Environment Variables

Create `frontend/.env`:
```
VITE_PROJECT_ID=your_walletconnect_project_id
```

---

## 📚 Documentation

**Main Reference:**
- `ESG_VAULT_WHITEPAPER_V2.md` - Complete technical whitepaper

**Implementation:**
- `IMPLEMENTATION_TIMELINE.md` - Current build plan and timeline

---

## 🔧 Development

### Contracts

```bash
# Compile
forge build

# Test
forge test

# Deploy (update script with your addresses)
forge script script/DeployNetZeroYieldVault.s.sol --broadcast --rpc-url rayls_devnet
```

### Frontend

```bash
cd frontend
npm run dev    # Development server
npm run build  # Production build
```

---

## 📊 Current Status

**✅ Complete:**
- ERC-4626 vault contract
- Mock yield strategy
- Landing page (Firestar-inspired design)
- Rayls Devnet configuration

**🚧 In Progress:**
- App pages (Deposit, Withdraw, Dashboard)
- Contract integration
- Whitepaper page update

**📋 Planned:**
- Full end-to-end workflow
- ESG metrics dashboard
- Mobile optimization

---

## 🎤 Hackathon Pitch

**Problem:** Institutions want DeFi yields but need ESG compliance.

**Solution:** ERC-4626 vault that automatically offsets carbon emissions.

**Why Rayls:** Sub-second finality enables real-time offset purchases. Identity layer provides accredited investor gating.

**Demo:** Deposit USDC → See yield → See offsets → Net-zero status.

---

## 📝 License

MIT

---

**Built for Rayls Hackathon 2025**
