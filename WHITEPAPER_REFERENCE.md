# NetZero Yield - Whitepaper Reference

## 📄 Main Document

**`ESG_VAULT_WHITEPAPER_V2.md`** - Complete technical whitepaper

This is the authoritative reference for the project concept, architecture, and implementation details.

---

## 🎯 What We're Actually Building

**NetZero Yield** - ERC-4626 Yield Vault with ESG Compliance

### Core Concept

Standard ERC-4626 vault that:
1. Accepts USDC deposits
2. Deploys to yield strategies (lending, LP, etc.)
3. Automatically purchases carbon offsets on yield harvest
4. Maintains net-zero carbon profile
5. Provides on-chain ESG metrics

### Why This Works

- ✅ **Clear value prop**: DeFi yields + automatic ESG compliance
- ✅ **Standard interface**: ERC-4626 composable with all DeFi
- ✅ **Actually generates yield**: From real DeFi strategies
- ✅ **Simple to demo**: Deposit → See yield → See offsets
- ✅ **Rayls advantage**: Sub-second finality for real-time offsets

---

## 🏗️ Architecture

### Contracts

- **NetZeroYieldVault.sol** - ERC-4626 vault with ESG
- **MockYieldStrategy.sol** - Demo yield generator
- **MockRaylsIdentityRegistry.sol** - Accreditation checks
- **MockCarbonOffsetTreasury.sol** - Carbon offset purchases

### Flow

```
User → Deposit USDC → Vault → Yield Strategy → Generate Yield
                                              ↓
                                    Harvest Yield → Calculate Footprint
                                              ↓
                                    Purchase Offsets → Net-Zero Status
                                              ↓
                                    User Receives Yield + ESG Compliance
```

---

## 📊 ESG Model

**Tier 1: NetZero (Current MVP)**
- Any assets accepted
- Automatic carbon offsetting
- 100% offset of footprint
- Article 8 compliance

**Future Tiers (Architecture Ready):**
- Tier 2: NetZero+ (120%+ offsets)
- Tier 3: Impact (inherently green assets only)

---

## 🎤 Key Points

**Problem:** Institutions want DeFi yields but need ESG compliance.

**Solution:** Automatic carbon offsetting on every yield harvest.

**Why Rayls:** Sub-second finality + identity layer = perfect for institutional DeFi.

**Market:** $30T+ in ESG-mandated assets globally.

---

For full technical details, see `ESG_VAULT_WHITEPAPER_V2.md`.

