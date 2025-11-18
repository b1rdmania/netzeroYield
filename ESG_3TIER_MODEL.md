# Three-Tier ESG Vault Model
## NetZero / NetZero+ / Impact Architecture

---

## 🎯 Conceptual Framework

> **"ESG isn't just about offsets. There are three tiers:**
> 
> 1. **Measured + Mitigated** (NetZero)
> 2. **Overcompensated** (NetZero+)
> 3. **Inherently Sustainable Assets** (Impact)"

---

## Tier 1: NetZero Vault
### "Measured + Mitigated"

**Concept**: Any asset → Measure footprint → Purchase offsets → Net-zero

**Target Market**: Article 8 funds, corporate treasuries, broad ESG mandates

**Technical Approach:**
- Accept any ERC-4626 vault or yield-bearing asset
- Calculate carbon footprint (yield + gas)
- Automatically purchase offsets to neutralize
- Maintain 1:1 offset-to-footprint ratio

**Value Prop:**
- ✅ Broad applicability (any asset)
- ✅ Automated compliance
- ✅ Large TAM (all ESG-mandated capital)

**Regulatory Fit**: Article 8 (ESG-promoting)

---

## Tier 2: NetZero+ Vault
### "Overcompensated"

**Concept**: Same as NetZero, but vault offsets MORE than it emits (e.g., 120-150%)

**Target Market**: Sustainability-linked bonds, climate-positive mandates, marketing-driven ESG

**Technical Approach:**
- Same as NetZero
- **PLUS**: Configure offset multiplier (e.g., 1.2x = 120% offset)
- Automatically purchase excess offsets
- Track net-positive carbon balance

**Value Prop:**
- ✅ Climate-positive (not just neutral)
- ✅ Strong marketing angle
- ✅ Fits sustainability-linked products

**Regulatory Fit**: Article 8+ (enhanced ESG)

**Example:**
```
Yield: $100
Footprint: 5 kg CO2
Offset Purchase: 6 kg CO2 (120%)
Net Status: +1 kg CO2 (climate-positive)
```

---

## Tier 3: Impact Vault
### "Inherently Sustainable Assets"

**Concept**: Only accept assets that are climate-positive by nature (no offsets needed)

**Target Market**: Article 9 funds, impact investors, highest ESG credibility

**Technical Approach:**
- **Asset filtering**: Only accept pre-verified climate-positive assets
- Categories:
  - Carbon removal credits (biochar, DAC, reforestation)
  - Green receivables (renewable energy, EV financing)
  - Environmental yield (solar/wind revenue, regenerative ag)
- No offset purchases needed (assets are inherently net-zero/positive)

**Value Prop:**
- ✅ Highest ESG credibility
- ✅ No offset costs
- ✅ True impact finance

**Regulatory Fit**: Article 9 (sustainable investment)

**Asset Categories:**
1. **Carbon-Removal Assets**
   - Biochar credits
   - Carbon capture financing notes
   - Reforestation-backed bonds
   - Verified removal credits (not avoidance)
   - DAC pre-purchase agreements

2. **Green Receivables**
   - Renewable energy company receivables
   - EV fleet financing
   - Solar installation receivables
   - Energy-efficient building retrofits
   - Net-zero certified SaaS companies

3. **Environmental Yield Strategies**
   - Renewable energy tokenized yield (solar/wind revenue)
   - Regenerative agriculture financing
   - Nature-based solution income contracts
   - Circular economy receivables

---

## 🏗️ Unified Architecture

### Single Codebase, Three Modes

**Design Pattern**: One vault contract that can operate in three modes based on configuration.

```solidity
enum VaultMode {
    NETZERO,      // Tier 1: Measure + offset
    NETZERO_PLUS, // Tier 2: Overcompensate
    IMPACT        // Tier 3: Inherently sustainable only
}
```

### Configuration Parameters

```solidity
struct VaultConfig {
    VaultMode mode;
    uint256 offsetMultiplier; // 100 = 1:1, 120 = 1.2:1 (20% overcompensation)
    bool requiresGreenAssets; // Tier 3: only green assets allowed
    address[] allowedAssetTypes; // Tier 3: whitelist of asset categories
    address carbonOffsetRegistry;
    address assetVerificationRegistry; // Tier 3: verify asset eligibility
}
```

### Core Functions (All Tiers)

```solidity
// Deposit (with asset verification for Tier 3)
function deposit(address asset, uint256 amount) external {
    if (config.mode == VaultMode.IMPACT) {
        require(isGreenAsset(asset), "Only green assets allowed");
    }
    // ... deposit logic
}

// Yield harvesting (with offset logic for Tier 1 & 2)
function harvestYield() external {
    uint256 yield = collectYield();
    
    if (config.mode != VaultMode.IMPACT) {
        uint256 footprint = calculateFootprint(yield);
        uint256 offsetAmount = footprint * config.offsetMultiplier / 100;
        purchaseCarbonOffsets(offsetAmount);
    }
    // ... reinvest logic
}

// Asset verification (Tier 3)
function isGreenAsset(address asset) public view returns (bool) {
    if (!config.requiresGreenAssets) return true;
    return assetVerificationRegistry.isVerifiedGreen(asset);
}
```

---

## 📊 Comparison Matrix

| Feature | NetZero (Tier 1) | NetZero+ (Tier 2) | Impact (Tier 3) |
|---------|------------------|-------------------|-----------------|
| **Asset Eligibility** | Any asset | Any asset | Green assets only |
| **Offset Required** | Yes (1:1) | Yes (1.2-1.5:1) | No (inherent) |
| **Carbon Status** | Neutral | Positive | Positive/Neutral |
| **Regulatory Fit** | Article 8 | Article 8+ | Article 9 |
| **TAM** | Largest | Medium | Smallest (niche) |
| **Credibility** | Good | Better | Best |
| **Cost** | Offset costs | Higher offset costs | No offset costs |
| **Complexity** | Medium | Medium | High (verification) |

---

## 🎯 Hackathon Recommendation

### Build: **NetZero Receivables Vault** (MVP)

**Why:**
- ✅ Combines Tier 1 (NetZero) + Tier 3 (Green Receivables) concepts
- ✅ Technical viability (receivables tokenization)
- ✅ Narrative strength (green-only option)
- ✅ Rayls alignment (private issuance → public distribution)
- ✅ Institutional reality (banks already do green ABS)

**Features:**
1. **Core**: Receivables vault (any receivables)
2. **ESG Layer**: Automatic carbon offset purchases (Tier 1)
3. **Green Filter**: Optional metadata for green-eligible receivables (Tier 3 preview)
4. **Future-Proof**: Architecture supports all three tiers

**Positioning:**
> "NetZero Receivables Vault - designed to support net-zero positive and impact vaults in the future. Today: automated offsetting. Tomorrow: inherently sustainable asset classes."

---

## 🚀 Implementation Roadmap

### Phase 1: MVP (Hackathon)
- ✅ Receivables vault (deposit receivables → mint tokens)
- ✅ Basic carbon offset integration (Tier 1)
- ✅ Green receivables metadata schema (Tier 3 foundation)
- ✅ Frontend showing ESG metrics

### Phase 2: Tier 2 Support
- ✅ Offset multiplier configuration
- ✅ Net-positive tracking
- ✅ Enhanced reporting

### Phase 3: Tier 3 Full Support
- ✅ Asset verification registry
- ✅ Green asset whitelist
- ✅ Impact reporting
- ✅ Article 9 compliance features

---

## 💡 Key Insights

### Why This Works

1. **Three-Tier Model**: Covers entire ESG spectrum
   - Tier 1: Broad market (Article 8)
   - Tier 2: Enhanced (sustainability-linked)
   - Tier 3: True impact (Article 9)

2. **Unified Architecture**: One codebase, three modes
   - Reduces development complexity
   - Enables migration between tiers
   - Future-proof design

3. **Rayls Advantage**: 
   - Private issuance → public distribution (perfect for receivables)
   - Identity/audit features (asset verification)
   - Sub-second finality (real-time offset purchases)

4. **Market Reality**:
   - Tier 1: Largest TAM (most ESG funds)
   - Tier 2: Marketing appeal (climate-positive)
   - Tier 3: Highest credibility (true impact)

---

## 📝 Next Steps

1. **Design green receivables metadata schema**
2. **Implement unified vault architecture**
3. **Build MVP with Tier 1 + Tier 3 preview**
4. **Create pitch emphasizing three-tier model**

**Ready to design the implementation?** 🚀

