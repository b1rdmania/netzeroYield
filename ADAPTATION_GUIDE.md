# Hackathon Adaptation Guide: vS Vault Protocol

## 🎯 How This Codebase Fits Your Hackathon Ideas

The **vS Vault Protocol** codebase is a **perfect foundation** for both of your hackathon ideas because it already implements:

✅ **Vault pattern** (deposit illiquid assets → mint liquid tokens)  
✅ **ERC-20 token minting/burning** (liquid wrapper tokens)  
✅ **Upgradeable contracts** with governance  
✅ **Fee structures** (mint/redeem fees)  
✅ **Harvest/redemption mechanisms**  
✅ **Full frontend** (React/TypeScript)  

---

## 💡 Idea 1: ESG Carbon Credit Automation

### **Concept**
> "An ERC-4626 vault that holds yield-bearing assets while automatically purchasing verified carbon offsets to maintain a net-zero carbon profile."

### **How to Adapt This Codebase**

#### **Core Changes Needed:**

1. **Modify Vault.sol** → `ESGVault.sol`
   - Instead of accepting NFTs, accept **ERC-4626 vault shares** or **LP tokens**
   - Track yield earned from underlying assets
   - Add `purchaseCarbonOffsets()` function that:
     - Calculates yield since last purchase
     - Swaps yield tokens → carbon credit tokens (or calls carbon credit oracle/registry)
     - Maintains net-zero carbon balance

2. **Add Carbon Credit Integration**
   - Interface with carbon credit registry (e.g., Toucan Protocol, KlimaDAO, or custom oracle)
   - Track `carbonOffsetBalance` vs `carbonFootprint`
   - Ensure `carbonOffsetBalance >= carbonFootprint` (net-zero)

3. **Modify Token Contract** → `ESGToken.sol`
   - Rename from `vS Token` to `ESG Token` or `NetZero Token`
   - Same mint/burn logic, just rebranded

4. **Key Functions to Add:**
   ```solidity
   // In ESGVault.sol
   function depositYieldBearingAsset(address vault, uint256 amount) external;
   function harvestYield() external; // Collect yield from underlying
   function purchaseCarbonOffsets() external; // Auto-buy offsets with yield
   function getCarbonFootprint() external view returns (uint256);
   function getCarbonOffsetBalance() external view returns (uint256);
   function isNetZero() external view returns (bool);
   ```

5. **Frontend Changes:**
   - Show carbon footprint vs offset balance
   - Display net-zero status badge
   - Show yield → carbon offset conversion rate
   - Dashboard showing ESG metrics

### **Why This Works:**
- ✅ Vault already handles deposits → token minting
- ✅ Fee structure can fund carbon purchases
- ✅ Upgradeable design allows adding carbon logic
- ✅ Frontend can be adapted to show ESG metrics

---

## 💡 Idea 2: VC Feeder Fund Tokenization

### **Concept**
> "VC feeder fund tokenization and liquid wrappers" - Turn illiquid VC fund shares into tradeable tokens.

### **How to Adapt This Codebase**

#### **Core Changes Needed:**

1. **Modify Vault.sol** → `VCFundVault.sol`
   - Instead of accepting NFTs, accept **VC fund shares** (could be ERC-721 representing fund positions, or off-chain commitments)
   - Track fund distributions (when VC fund pays out)
   - Handle multiple fund positions (different VC funds)

2. **Add Fund Distribution Tracking**
   - When VC fund distributes returns, vault receives them
   - Distribute proportionally to token holders
   - Or allow redemption of tokens for underlying fund shares

3. **Modify Token Contract** → `VCFundToken.sol`
   - Same mint/burn logic
   - Could add distribution mechanism (like dividend tokens)

4. **Key Functions to Add:**
   ```solidity
   // In VCFundVault.sol
   function depositFundShare(address fundAddress, uint256 shareAmount) external;
   function recordDistribution(address fundAddress, uint256 amount) external; // Called when fund pays out
   function claimDistribution() external; // Token holders claim their share
   function redeemForFundShare(uint256 tokenAmount) external; // Burn tokens, get fund share back
   function getTotalFundValue() external view returns (uint256);
   function getFundPositions() external view returns (address[] memory, uint256[] memory);
   ```

5. **Frontend Changes:**
   - Show fund positions and valuations
   - Display distribution history
   - Show token price vs NAV (Net Asset Value)
   - Portfolio view of all VC funds

### **Why This Works:**
- ✅ **Perfect match**: This codebase is literally designed for "illiquid → liquid" conversion
- ✅ Same pattern: Deposit illiquid asset → Get liquid tokens
- ✅ Redemption mechanism already exists
- ✅ Fee structure works for fund management fees

---

## 🚀 Quick Start: Which One to Build?

### **Recommendation: ESG Carbon Credit Automation**

**Why:**
1. **More aligned with Rayls/TradFi bridge** - ESG is huge in TradFi
2. **Clearer value prop** - "Net-zero yield vault" is easy to explain
3. **More hackathon-friendly** - Can demo with mock carbon credits
4. **Fits ERC-4626 standard** - Mentioned in your hackathon ideas

### **Implementation Priority:**

#### **Phase 1: Core Adaptation (2-3 hours)**
1. Rename contracts: `Vault.sol` → `ESGVault.sol`
2. Change deposit to accept ERC-4626 vault shares instead of NFTs
3. Add basic carbon offset tracking (mock for demo)

#### **Phase 2: Carbon Integration (2-3 hours)**
4. Integrate with carbon credit registry (or mock oracle)
5. Add `purchaseCarbonOffsets()` function
6. Add net-zero verification logic

#### **Phase 3: Frontend (2-3 hours)**
7. Update UI to show ESG metrics
8. Add carbon dashboard
9. Show yield → offset conversion

#### **Phase 4: Polish (1-2 hours)**
10. Add tests
11. Deploy to Rayls testnet
12. Create demo video

**Total: ~8-11 hours** (perfect for hackathon!)

---

## 📝 Specific Code Changes Needed

### **For ESG Vault:**

**File: `src/upgradeable/Vault.sol`**
- Line 12: Change `ISonicAirdropNFT` → `IERC4626` (yield vault interface)
- Line 257: Change `deposit()` to accept ERC-4626 shares
- Add: `harvestYield()` function
- Add: `purchaseCarbonOffsets()` function
- Add: Carbon tracking storage variables

**File: `src/upgradeable/UpgradeableVSToken.sol`**
- Line 11: Change token name/symbol to ESG-related
- Keep mint/burn logic (no changes needed)

**File: `frontend/src/pages/app/DepositPage.tsx`**
- Change UI to show yield-bearing asset deposit
- Add carbon offset balance display
- Add net-zero status indicator

---

## 🎨 Hackathon Pitch Ideas

### **For ESG:**
> "**NetZero Vault**: The first ERC-4626 vault that automatically uses yield to purchase carbon offsets, maintaining a net-zero carbon profile. Institutional investors get DeFi yields while meeting ESG compliance requirements."

### **For VC Fund:**
> "**LiquidVC**: Tokenize illiquid VC fund positions into tradeable ERC-20 tokens. Get liquidity today, redeem when funds distribute. Bridge TradFi VC access to DeFi liquidity."

---

## 🔧 Next Steps

1. **Decide which idea** (I recommend ESG)
2. **I can help adapt the code** - Just tell me which one!
3. **We'll modify contracts** to match your chosen idea
4. **Update frontend** to reflect new functionality
5. **Deploy to Rayls** testnet/mainnet

**Which one do you want to build?** 🚀

