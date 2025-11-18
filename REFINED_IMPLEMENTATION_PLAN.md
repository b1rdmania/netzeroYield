# Refined Implementation Plan
## NetZero Receivables Vault with 3-Tier ESG Model

Based on strategic feedback: Building a receivables vault that supports NetZero (Tier 1) with green receivables foundation (Tier 3 preview).

---

## 🎯 Project Vision

**NetZero Receivables Vault** - Tokenize receivables with automated ESG compliance. Today: automatic carbon offsetting (Tier 1). Tomorrow: inherently sustainable asset classes (Tier 3).

**Positioning:**
> "Designed to support net-zero positive and impact vaults in the future. Today: automated offsetting. Tomorrow: inherently sustainable asset classes."

---

## 🏗️ Architecture Overview

### Unified Vault Design

```
NetZeroReceivablesVault
├── Receivables Management
│   ├── Deposit receivables
│   ├── Track maturity
│   └── Distribute payments
├── ESG Layer
│   ├── Carbon footprint calculation
│   ├── Offset purchase automation (Tier 1)
│   └── Green receivables verification (Tier 3 foundation)
└── Token System
    ├── Mint tokens on deposit
    ├── Burn tokens on redemption
    └── ERC-20 composability
```

### Three Modes (Future-Proof)

1. **NETZERO Mode** (Tier 1): Any receivables + automatic offsets
2. **NETZERO_PLUS Mode** (Tier 2): Overcompensation (120-150% offsets)
3. **IMPACT Mode** (Tier 3): Only green receivables (no offsets needed)

---

## 📋 Implementation Phases

### Phase 1: Core Receivables Vault (3-4 hours)

**Goal**: Basic receivables tokenization (like vS Vault but for receivables)

**Tasks:**
- [ ] Create `NetZeroReceivablesVault.sol`
  - Adapt `Vault.sol` from vS codebase
  - Change from NFT deposits to receivable deposits
  - Add receivable tracking (amount, maturity, originator)
- [ ] Create `ReceivableToken.sol` (nZ token)
  - Adapt `UpgradeableVSToken.sol`
  - Rename to NetZero Token
- [ ] Add receivable data structure
  ```solidity
  struct Receivable {
      address originator;
      uint256 amount;
      uint256 maturityDate;
      bytes32 receivableId;
      bool isDeposited;
  }
  ```
- [ ] Implement deposit/redeem flow
  - `depositReceivable()` - Accept receivable, mint tokens
  - `redeem()` - Burn tokens, claim receivable value
  - `distributePayment()` - When receivable matures, distribute to token holders

**Deliverable**: Working receivables vault (no ESG yet)

---

### Phase 2: ESG Layer - NetZero (Tier 1) (2-3 hours)

**Goal**: Add automatic carbon offsetting

**Tasks:**
- [ ] Add carbon footprint calculation
  ```solidity
  function calculateCarbonFootprint(uint256 yieldAmount) internal view returns (uint256) {
      // Simple calculation for MVP:
      // Footprint = yield × carbon intensity factor
      return yieldAmount * CARBON_INTENSITY_FACTOR / 1e18;
  }
  ```
- [ ] Add carbon offset registry interface (mock for MVP)
  ```solidity
  interface ICarbonOffsetRegistry {
      function getOffsetPrice() external view returns (uint256);
      function purchaseOffsets(uint256 amount) external returns (bool);
  }
  ```
- [ ] Implement `harvestYieldAndOffset()` function
  - Harvest yield from receivables (when they pay out)
  - Calculate footprint
  - Purchase offsets automatically
  - Reinvest remaining yield
- [ ] Add net-zero status tracking
  ```solidity
  struct CarbonBalance {
      uint256 totalFootprint;
      uint256 totalOffsets;
      bool isNetZero;
  }
  ```

**Deliverable**: NetZero vault with automatic offsetting

---

### Phase 3: Green Receivables Foundation (Tier 3 Preview) (2-3 hours)

**Goal**: Add metadata schema and verification foundation

**Tasks:**
- [ ] Create `GreenReceivablesRegistry.sol` (simplified for MVP)
  - Originator registration
  - Receivable verification (manual for MVP)
  - Green category tracking
- [ ] Add green category enum
  ```solidity
  enum GreenCategory {
      NONE,
      RENEWABLE_ENERGY,
      EV_FLEET,
      ENERGY_EFFICIENCY,
      CARBON_REMOVAL,
      // ... others
  }
  ```
- [ ] Extend receivable struct
  ```solidity
  struct Receivable {
      // ... existing fields
      GreenCategory category;
      uint256 carbonImpact; // kg CO2 avoided/removed
      bool isVerifiedGreen;
  }
  ```
- [ ] Add verification functions (manual for MVP)
  ```solidity
  function verifyReceivableAsGreen(bytes32 id, GreenCategory category, uint256 impact) external onlyAdmin {
      // Mark receivable as verified green
  }
  ```
- [ ] Update vault to support IMPACT mode (future)
  ```solidity
  enum VaultMode { NETZERO, NETZERO_PLUS, IMPACT }
  VaultMode public mode = VaultMode.NETZERO; // Default to Tier 1
  ```

**Deliverable**: Foundation for Tier 3, currently operates in Tier 1 mode

---

### Phase 4: Frontend - ESG Dashboard (2-3 hours)

**Goal**: Show ESG metrics and receivables management

**Tasks:**
- [ ] Update deposit page
  - Receivable submission form
  - Amount, maturity date, originator
  - Green category selector (for future Tier 3)
- [ ] Create ESG dashboard
  - Carbon footprint vs. offsets
  - Net-zero status indicator
  - Receivables breakdown by category
  - Yield → offset conversion display
- [ ] Add receivables management view
  - List of deposited receivables
  - Maturity dates
  - Payment status
- [ ] Update token display
  - Show nZ token balance
  - Display ESG compliance badge

**Deliverable**: Complete frontend with ESG metrics

---

### Phase 5: Polish & Deploy (1-2 hours)

**Goal**: Ready for demo

**Tasks:**
- [ ] Add basic tests
  - Receivable deposit
  - Token minting
  - Carbon offset purchase (mock)
- [ ] Deploy to Rayls testnet
- [ ] Create demo script
  - Sample receivables
  - Show ESG metrics
- [ ] Prepare pitch deck
  - Three-tier model explanation
  - Current MVP (Tier 1)
  - Future roadmap (Tier 2 & 3)

**Deliverable**: Demo-ready prototype

---

## 🔧 Technical Details

### Contract Structure

```
src/
├── upgradeable/
│   ├── NetZeroReceivablesVault.sol  # Main vault
│   └── NetZeroToken.sol              # nZ token
├── registry/
│   └── GreenReceivablesRegistry.sol  # Asset verification
├── interfaces/
│   ├── ICarbonOffsetRegistry.sol     # Offset purchase interface
│   └── IReceivable.sol                # Receivable interface
└── mocks/
    └── MockCarbonOffsetRegistry.sol  # Mock for demo
```

### Key Functions

**NetZeroReceivablesVault.sol:**
```solidity
// Core
function depositReceivable(bytes32 receivableId, uint256 amount, uint256 maturityDate) external;
function redeem(uint256 tokenAmount) external;
function distributePayment(bytes32 receivableId) external;

// ESG
function harvestYieldAndOffset() external;
function getCarbonBalance() external view returns (CarbonBalance memory);
function isNetZero() external view returns (bool);

// Future Tier 3
function setMode(VaultMode newMode) external onlyAdmin;
function isGreenReceivable(bytes32 id) external view returns (bool);
```

### Mock Carbon Offset Registry (For Demo)

```solidity
contract MockCarbonOffsetRegistry is ICarbonOffsetRegistry {
    uint256 public constant OFFSET_PRICE = 50e18; // $50 per ton CO2
    
    function getOffsetPrice() external pure override returns (uint256) {
        return OFFSET_PRICE;
    }
    
    function purchaseOffsets(uint256 kgCO2) external override returns (bool) {
        // Mock: Just emit event, no actual purchase
        emit OffsetsPurchased(msg.sender, kgCO2, kgCO2 * OFFSET_PRICE / 1e18);
        return true;
    }
}
```

---

## 📊 MVP Scope (Hackathon)

### What We're Building

✅ **Core Features:**
- Receivables vault (deposit → mint tokens)
- Automatic carbon offsetting (Tier 1)
- Green receivables metadata (Tier 3 foundation)
- ESG dashboard

✅ **Simplifications for MVP:**
- Mock carbon offset registry (no real purchases)
- Manual green verification (admin-controlled)
- Simple footprint calculation
- Single vault mode (Tier 1, but architecture supports all tiers)

### What We're NOT Building (Yet)

❌ Real carbon offset purchases (mock for demo)
❌ Automated green verification (manual for MVP)
❌ Tier 2 (NetZero+) mode (architecture ready, not implemented)
❌ Tier 3 (Impact) mode (foundation ready, not active)
❌ Complex footprint calculations (simplified for MVP)

---

## 🎤 Demo Script

### Scenario 1: Deposit Receivable

1. **User deposits receivable**
   - Amount: $10,000
   - Maturity: 90 days
   - Originator: "SolarCo Inc"
   - Category: Renewable Energy (green)

2. **Vault mints tokens**
   - User receives 9,900 nZ tokens (1% mint fee)
   - Receivable stored in vault

3. **Dashboard shows**
   - Receivable listed
   - Token balance
   - ESG status: "Pending offset purchase"

### Scenario 2: Yield Harvest & Offset

1. **Receivable matures, pays out**
   - $10,000 received
   - Yield: $500 (5% return)

2. **Vault automatically**
   - Calculates footprint: 25 kg CO2
   - Purchases offsets: 25 kg CO2 ($1.25)
   - Reinvests remaining: $498.75

3. **Dashboard updates**
   - Net-zero status: ✅ "Net Zero"
   - Carbon balance: 25 kg offset / 25 kg footprint
   - Yield distributed to token holders

### Scenario 3: Green Receivable (Tier 3 Preview)

1. **Admin verifies receivable as green**
   - Marks as "Renewable Energy"
   - Records carbon impact: 1,000 kg CO2 avoided

2. **Dashboard shows**
   - Green badge on receivable
   - Carbon impact: +1,000 kg CO2
   - Note: "In Impact mode, this would not require offsets"

---

## 🚀 Getting Started

### Step 1: Set Up Project

```bash
cd vs-token-mvp
# Keep existing structure, we'll adapt it
```

### Step 2: Create New Contracts

- Copy `Vault.sol` → `NetZeroReceivablesVault.sol`
- Copy `UpgradeableVSToken.sol` → `NetZeroToken.sol`
- Create `GreenReceivablesRegistry.sol`
- Create `MockCarbonOffsetRegistry.sol`

### Step 3: Adapt Existing Code

- Change deposit from NFTs to receivables
- Add ESG layer (carbon calculation + offset purchase)
- Add green receivables support

### Step 4: Update Frontend

- Change UI from NFT deposit to receivable deposit
- Add ESG dashboard
- Show carbon metrics

---

## 📈 Success Metrics

### Hackathon Demo

✅ **Working Prototype:**
- Can deposit receivables
- Tokens mint automatically
- Carbon offsets purchased (mock)
- ESG dashboard shows metrics

✅ **Clear Narrative:**
- Three-tier model explained
- Current: Tier 1 (NetZero)
- Future: Tier 2 & 3 support

✅ **Rayls Integration:**
- Deployed on Rayls testnet
- Leverages sub-second finality
- Shows TradFi/DeFi bridge

---

## 🎯 Next Actions

1. **Review this plan** - Does it align with your vision?
2. **Start Phase 1** - Begin adapting the vault contract
3. **Build incrementally** - Get core working first, then add ESG
4. **Demo preparation** - Plan what to show judges

**Ready to start coding?** 🚀

