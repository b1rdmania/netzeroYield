# NetZero Institutional Fund Vault - Complete Implementation

## 🎯 One-Liner

> **An ERC-4626 institutional fund vault with accredited-investor gating and automated carbon offsetting, ensuring all fund exposure is ESG-compliant and net-zero from day one.**

## ✅ What's Built

### Core Contracts

1. **NetZeroFundVault.sol** - Main vault with ESG + accreditation
   - ✅ Accredited investor gating (Rayls identity)
   - ✅ Fund share tokenization
   - ✅ Automatic carbon offsetting on yield harvest
   - ✅ Net-zero tracking and verification
   - ✅ Upgradeable with governance

2. **FundToken.sol** - Liquid ERC-20 tokens
   - ✅ Represents fund positions
   - ✅ Tradeable and composable

3. **MockFundShare.sol** - Demo fund shares (ERC-721)
   - ✅ Represents VC fund positions

4. **MockRaylsIdentityRegistry.sol** - Rayls identity mock
   - ✅ Accreditation checks
   - ✅ For demo/testing

5. **MockCarbonOffsetTreasury.sol** - Carbon offset mock
   - ✅ Offset purchase logic
   - ✅ For demo/testing

## 🏗️ Architecture

### Three Layers

1. **Institutional Fund Layer**
   - Accredited-only deposits
   - ERC-4626 share minting
   - Fund share tracking
   - Upgradeable governance

2. **ESG Layer**
   - Automatic carbon footprint calculation
   - Real-time offset purchases (sub-second finality)
   - Net-zero tracking
   - Configurable offset percentage (100%+ for net-positive)

3. **Rayls Identity & Compliance Layer**
   - Identity-gated deposits
   - On-chain accreditation checks
   - Compliance-ready

## 🔄 How It Works

### Deposit Flow
1. User checks accreditation via Rayls identity
2. User deposits fund share NFT
3. Vault mints liquid Fund tokens (minus 1% fee)
4. Share tracked in vault

### Yield Harvest Flow
1. Admin calls `harvestYieldAndOffset(yieldAmount)`
2. Vault calculates carbon footprint
3. Vault automatically purchases offsets (using sub-second finality)
4. ESG metrics updated
5. Net-zero status maintained

### Redeem Flow
1. User burns Fund tokens
2. Gets fund share NFT back (minus 2% fee)

## 📊 ESG Metrics

### Tracking
- `totalCarbonFootprint` - Total kg CO2 emitted
- `totalCarbonOffsets` - Total kg CO2 offset
- `isNetZero()` - Returns true if offsets >= footprint

### Configuration
- `offsetBps` - Offset percentage (default 10000 = 100%)
- Can be set to 12000 for 120% offset (net-positive)

## 🎤 Pitch Structure

### Problem (15 seconds)
Institutions want to use DeFi and tokenised RWAs, but need:
- Accreditation gating
- On-chain compliance
- ESG reporting
- Net-zero processes

No DeFi vault gives them this today.

### Solution (20 seconds)
A Rayls-native ERC-4626 vault that:
- Only accepts accredited investors via Rayls identity
- Routes capital into yield-bearing strategies or RWAs
- Automatically purchases carbon offsets using sub-second finality
- Keeps the entire vault net-zero by design

### Why Rayls (20 seconds)
- **Deterministic finality** → Real-time offset matching
- **Stable gas fees** → Consistent ESG calculations
- **Identity layer** → Accredited-investor gating
- **Private-node architecture** → Fits institutional flows

### Demo
Show: Deposit → Yield → Offset → NetZero = true

### Future Vision
This vault can wrap:
- VC funds
- RWA pools
- Tokenised receivables
- Private-node bank assets

Everything becomes ESG-ready and compliant from day one.

## 🚀 Deployment

### Step 1: Deploy Mocks
```bash
# Deploy MockFundShare
forge script script/DeployMockFundShare.s.sol --broadcast --rpc-url <RAYLS_RPC>

# Deploy MockRaylsIdentityRegistry
# Deploy MockCarbonOffsetTreasury
```

### Step 2: Deploy FundToken
```bash
forge script script/DeployFundToken.s.sol --broadcast --rpc-url <RAYLS_RPC>
```

### Step 3: Deploy NetZeroFundVault
```bash
forge script script/DeployNetZeroFundVault.s.sol --broadcast --rpc-url <RAYLS_RPC>
```

## 📝 Key Features

### Accredited Investor Gating
```solidity
require(IDENTITY_REGISTRY.isAccredited(msg.sender), "Not an accredited investor");
```

### Automatic Carbon Offsetting
```solidity
function harvestYieldAndOffset(uint256 yieldAmount) external {
    uint256 carbonFootprint = (yieldAmount * CARBON_INTENSITY_FACTOR) / 1e18;
    uint256 offsetAmount = (carbonFootprint * offsetBps) / 10_000;
    CARBON_OFFSET_TREASURY.purchaseOffsets(offsetAmount);
    // Update ESG metrics
}
```

### Net-Zero Verification
```solidity
function isNetZero() external view returns (bool) {
    return totalCarbonOffsets >= totalCarbonFootprint;
}
```

## 🎯 Why This Wins

1. **Combines Best of Both**: Fund tokenization + ESG compliance
2. **Rayls Native**: Leverages all Rayls features
3. **Institutional Ready**: Accreditation gating built-in
4. **ESG Compliant**: Net-zero from day one
5. **Future-Proof**: Can wrap any asset class

## 📚 Files

- `src/upgradeable/NetZeroFundVault.sol` - Main vault
- `src/upgradeable/FundToken.sol` - Liquid tokens
- `src/mocks/MockFundShare.sol` - Demo fund shares
- `src/mocks/MockRaylsIdentityRegistry.sol` - Identity mock
- `src/mocks/MockCarbonOffsetTreasury.sol` - Offset mock

## 🎉 Status

✅ **Contracts Complete** - Ready for Rayls deployment!
✅ **ESG Layer Integrated** - Automatic offsetting
✅ **Identity Gating** - Accredited investors only
✅ **Demo Ready** - All mocks in place

---

**This is the winning combination!** 🚀

