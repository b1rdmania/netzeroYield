# NetZero Receivables Vault: Whitepaper v2.0
## Three-Tier ESG Architecture for DeFi Yield

**Bridging TradFi ESG Requirements with DeFi Yield Opportunities**

> **"ESG isn't just about offsets. There are three tiers:**
> 
> 1. **Measured + Mitigated** (NetZero)
> 2. **Overcompensated** (NetZero+)  
> 3. **Inherently Sustainable Assets** (Impact)"

---

## Executive Summary

**NetZero Receivables Vault** is an ERC-4626 compatible vault that tokenizes receivables with automated ESG compliance. The protocol supports three tiers of ESG implementation, from automatic carbon offsetting (Tier 1) to inherently sustainable asset classes (Tier 3).

**Current MVP**: Tier 1 (NetZero) - Automated carbon offsetting for any receivables  
**Future Roadmap**: Tier 2 (NetZero+) and Tier 3 (Impact) - Climate-positive and inherently sustainable vaults

### Key Innovation
- **Three-Tier ESG Model**: Supports entire ESG spectrum (Article 8 to Article 9)
- **Automated Compliance**: Yield automatically converted to carbon offsets
- **Green Receivables Foundation**: Architecture supports inherently sustainable assets
- **Unified Codebase**: One vault, three modes, future-proof design

---

## 1. The Problem

### 1.1 The ESG Compliance Gap

Institutional investors face a critical challenge: **DeFi yields are attractive, but ESG compliance is mandatory**.

- **TradFi Requirements**: Institutional investors must meet ESG mandates (EU SFDR, MiCA, corporate sustainability policies)
- **DeFi Opportunity**: DeFi protocols offer superior yields compared to traditional finance
- **The Gap**: No existing solution automatically ensures DeFi yields maintain ESG compliance

### 1.2 The Offset vs. Intrinsic Sustainability Distinction

**TradFi ESG distinguishes:**
- **Compensation** (offsetting after the fact) - Article 8 funds
- **Intrinsic Sustainability** (assets that are green by nature) - Article 9 funds

**Current Solutions:**
- ❌ Manual carbon offset purchases (time-consuming, expensive)
- ❌ No support for inherently sustainable assets
- ❌ Limited DeFi integration
- ❌ Lack of on-chain verification

**Result**: Institutional capital remains locked in low-yield, ESG-compliant traditional assets, missing DeFi opportunities.

---

## 2. The Solution: Three-Tier ESG Model

### 2.1 Tier 1: NetZero Vault
**"Measured + Mitigated"**

**Concept**: Any receivables → Measure footprint → Purchase offsets → Net-zero

**Target Market**: Article 8 funds, corporate treasuries, broad ESG mandates

**Technical Approach:**
- Accept any receivables (no filtering)
- Calculate carbon footprint (yield + gas)
- Automatically purchase offsets to neutralize
- Maintain 1:1 offset-to-footprint ratio

**Value Prop:**
- ✅ Broad applicability (any receivables)
- ✅ Automated compliance
- ✅ Large TAM (all ESG-mandated capital)

**Regulatory Fit**: Article 8 (ESG-promoting)

---

### 2.2 Tier 2: NetZero+ Vault
**"Overcompensated"**

**Concept**: Same as NetZero, but vault offsets MORE than it emits (e.g., 120-150%)

**Target Market**: Sustainability-linked bonds, climate-positive mandates

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

---

### 2.3 Tier 3: Impact Vault
**"Inherently Sustainable Assets"**

**Concept**: Only accept receivables that are climate-positive by nature (no offsets needed)

**Target Market**: Article 9 funds, impact investors, highest ESG credibility

**Technical Approach:**
- **Asset filtering**: Only accept pre-verified climate-positive receivables
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
1. **Carbon-Removal Assets**: Biochar credits, carbon capture notes, reforestation bonds
2. **Green Receivables**: Renewable energy, EV fleet financing, solar installations
3. **Environmental Yield**: Solar/wind revenue, regenerative agriculture, circular economy

---

## 3. Technical Architecture

### 3.1 Unified Vault Design

**Single Codebase, Three Modes:**

```solidity
enum VaultMode {
    NETZERO,      // Tier 1: Measure + offset
    NETZERO_PLUS, // Tier 2: Overcompensate
    IMPACT        // Tier 3: Inherently sustainable only
}
```

### 3.2 Core Components

#### **NetZeroReceivablesVault.sol** (Main Vault)
- **Interface**: ERC-4626 compliant
- **Functionality**:
  - Accept deposits of receivables
  - Track receivable maturity
  - Harvest yield when receivables pay out
  - Calculate carbon footprint
  - Purchase carbon offsets automatically (Tier 1 & 2)
  - Verify green receivables (Tier 3)
  - Maintain net-zero balance

#### **NetZeroToken.sol** (nZ Token)
- **Standard**: ERC-20
- **Functionality**:
  - Represents shares in NetZero Vault
  - Minted on deposit, burned on withdrawal
  - Fully composable with DeFi protocols

#### **GreenReceivablesRegistry.sol** (Asset Verification)
- **Functionality**:
  - Register originators (companies issuing receivables)
  - Verify receivables as "green"
  - Track carbon impact
  - Maintain certification records

#### **CarbonOffsetRegistry.sol** (Oracle/Registry)
- **Functionality**:
  - Tracks verified carbon offset projects
  - Provides offset pricing
  - Records offset purchases
  - Generates attestations

### 3.3 Key Mechanisms

#### **Receivable Deposit (All Tiers)**
```solidity
function depositReceivable(
    bytes32 receivableId,
    uint256 amount,
    uint256 maturityDate,
    address originator
) external {
    if (mode == VaultMode.IMPACT) {
        require(
            registry.isGreenReceivable(receivableId),
            "Only green receivables allowed in Impact mode"
        );
    }
    
    // Store receivable
    receivables[receivableId] = Receivable({
        originator: originator,
        amount: amount,
        maturityDate: maturityDate,
        receivableId: receivableId
    });
    
    // Mint tokens (minus fee)
    uint256 tokens = amount * (10000 - MINT_FEE_BPS) / 10000;
    nzToken.mint(msg.sender, tokens);
}
```

#### **Yield Harvesting & Offsetting (Tier 1 & 2)**
```solidity
function harvestYieldAndOffset() external {
    // 1. Collect yield from matured receivables
    uint256 yield = collectYieldFromReceivables();
    
    // 2. Calculate carbon footprint
    uint256 footprint = calculateCarbonFootprint(yield);
    
    // 3. Purchase offsets (with multiplier for Tier 2)
    uint256 offsetAmount = footprint * offsetMultiplier / 100;
    purchaseCarbonOffsets(offsetAmount);
    
    // 4. Reinvest remaining yield
    reinvestYield(yield - offsetCost);
}
```

#### **Green Receivable Verification (Tier 3)**
```solidity
function verifyReceivableAsGreen(
    bytes32 receivableId,
    GreenCategory category,
    uint256 carbonImpact
) external onlyVerifier {
    require(
        registry.isRegisteredOriginator(originator),
        "Originator not registered"
    );
    
    registry.markAsGreen(receivableId, category, carbonImpact);
}
```

### 3.4 Carbon Footprint Calculation

**Methodology:**
- **Receivable yield**: Carbon intensity per dollar of yield
- **On-chain activity**: Gas consumption → carbon equivalent
- **Oracle-based**: External data feeds for accurate calculations
- **Conservative estimates**: Over-estimate footprint to ensure compliance

**Formula:**
```
Carbon Footprint = (Yield Amount × Carbon Intensity Factor) + (Gas Costs × Gas Carbon Factor)
```

### 3.5 Carbon Offset Selection

**Verified Standards:**
- ✅ VCS (Verified Carbon Standard)
- ✅ Gold Standard
- ✅ CAR (Climate Action Reserve)
- ✅ ACR (American Carbon Registry)

**Selection Priority:**
1. **Verification Level**: Highest verification standards preferred
2. **Price Efficiency**: Best offset-to-cost ratio
3. **Vintage**: Recent offsets preferred (within 2 years)
4. **Project Type**: Nature-based solutions prioritized

---

## 4. Economic Model

### 4.1 Fee Structure

| Fee Type | Rate | Purpose |
|----------|------|---------|
| **Mint Fee** | 1% | Protocol operations |
| **Redeem Fee** | 2% | Harvest gas + incentives |
| **Carbon Offset Cost** | Variable | Direct cost of offsets (Tier 1 & 2) |
| **Total Cost (Tier 1)** | ~3% + offset costs | Competitive with TradFi |
| **Total Cost (Tier 3)** | ~3% | No offset costs |

### 4.2 Yield Distribution

**Tier 1 & 2 Flow:**
1. **Harvest yield** from receivables
2. **Calculate carbon footprint**
3. **Purchase offsets** (deducted from yield)
4. **Apply fees** (mint + redeem)
5. **Reinvest or distribute** remaining yield

**Tier 3 Flow:**
1. **Harvest yield** from receivables
2. **No offset purchase** (assets are inherently green)
3. **Apply fees**
4. **Reinvest or distribute** yield

**Example (Tier 1):**
- $100 yield generated
- $5 carbon offset purchase (5%)
- $1 mint fee (1%)
- $2 redeem fee (2%)
- **$92 reinvested/distributed** (92% net yield)

**Example (Tier 3):**
- $100 yield generated
- $0 carbon offset (inherently green)
- $1 mint fee (1%)
- $2 redeem fee (2%)
- **$97 reinvested/distributed** (97% net yield)

---

## 5. Integration with Rayls

### 5.1 Why Rayls?

**Sub-second Finality:**
- Enables real-time carbon offset purchases
- Reduces settlement risk
- Improves user experience

**TradFi Bridge:**
- Institutional-grade infrastructure
- Regulatory compliance features
- Trust anchors to Ethereum mainnet
- **Private issuance → public distribution** (perfect for receivables)

**DeFi Ecosystem:**
- Growing DeFi protocol ecosystem
- Yield opportunities
- Composability with existing protocols

### 5.2 Rayls-Specific Features

**Fast Settlement:**
- Carbon offsets purchased and verified within seconds
- Real-time net-zero status updates
- Instant attestation generation

**Ethereum Trust Anchors:**
- Carbon offset attestations anchored to Ethereum
- Cross-chain verification
- Regulatory compliance

**Privacy Nodes:**
- Banks can issue receivables privately
- Public distribution via vault
- Perfect for green receivables from institutions

---

## 6. Use Cases

### 6.1 Corporate Treasury Management (Tier 1)

**Scenario**: Corporate treasury wants to earn DeFi yields while maintaining ESG compliance.

**Solution**: Deposit receivables into NetZero Vault → Receive nZ tokens → Earn yield with automatic carbon neutrality.

**Benefits:**
- ✅ Meets corporate sustainability mandates
- ✅ Generates superior returns vs. traditional assets
- ✅ Automated compliance (no manual tracking)
- ✅ Audit-ready reporting

### 6.2 Green Receivables Financing (Tier 3)

**Scenario**: Renewable energy company wants to tokenize future revenue from solar installations.

**Solution**: Issue green receivables → Verified in registry → Deposited to Impact Vault → No offsets needed (inherently green).

**Benefits:**
- ✅ Article 9 compliance
- ✅ No offset costs
- ✅ True impact finance
- ✅ Access to DeFi liquidity

### 6.3 ESG Fund Wrapper (All Tiers)

**Scenario**: ESG-focused fund wants to offer DeFi exposure to investors.

**Solution**: Fund deposits receivables into NetZero Vault → Issues fund shares backed by nZ tokens → Investors get DeFi yields with ESG compliance.

**Benefits:**
- ✅ Fund-level ESG compliance
- ✅ Access to DeFi yields
- ✅ Liquid fund shares (nZ tokens tradeable)
- ✅ Transparent carbon offset tracking

---

## 7. Regulatory Compliance

### 7.1 ESG Frameworks

**EU Sustainable Finance Disclosure Regulation (SFDR):**
- ✅ Article 8/9 fund compliance
- ✅ Principal Adverse Impact (PAI) reporting
- ✅ Sustainability risk disclosure

**MiCA (Markets in Crypto-Assets):**
- ✅ ESG disclosure requirements
- ✅ Sustainability risk assessment
- ✅ On-chain attestation support

**Corporate Sustainability Reporting:**
- ✅ Carbon footprint tracking
- ✅ Offset purchase records
- ✅ Net-zero status verification

### 7.2 Three-Tier Regulatory Mapping

| Tier | Regulatory Fit | Compliance Level |
|------|----------------|------------------|
| **Tier 1 (NetZero)** | Article 8 | ESG-promoting |
| **Tier 2 (NetZero+)** | Article 8+ | Enhanced ESG |
| **Tier 3 (Impact)** | Article 9 | Sustainable investment |

---

## 8. Roadmap

### Phase 1: MVP (Hackathon) - Tier 1
- ✅ Core receivables vault
- ✅ Basic carbon offset integration (mock/oracle)
- ✅ Net-zero verification logic
- ✅ Green receivables metadata schema (Tier 3 foundation)
- ✅ Frontend dashboard
- ✅ Deploy to Rayls testnet

### Phase 2: Production Ready (Q2 2025)
- Real carbon offset registry integration
- Multiple receivable types support
- Enhanced carbon footprint calculation
- Full audit and security review
- Mainnet deployment

### Phase 3: Tier 2 Support (Q3 2025)
- Offset multiplier configuration
- Net-positive tracking
- Enhanced reporting
- Sustainability-linked bond features

### Phase 4: Tier 3 Full Support (Q4 2025)
- Asset verification registry
- Green asset whitelist
- Impact reporting
- Article 9 compliance features
- Integration with carbon removal markets

---

## 9. Competitive Analysis

### 9.1 Traditional ESG Solutions

**Traditional ESG Funds:**
- ❌ Low yields (2-4% APY)
- ❌ Manual compliance
- ❌ Limited transparency
- ❌ High fees (1-2% management)

**NetZero Receivables Vault:**
- ✅ DeFi yields (5-15% APY)
- ✅ Automated compliance
- ✅ On-chain transparency
- ✅ Competitive fees (0.5-1% + performance)

### 9.2 DeFi Yield Vaults

**Standard ERC-4626 Vaults:**
- ❌ No ESG compliance
- ❌ Manual carbon offset tracking
- ❌ Regulatory concerns

**NetZero Receivables Vault:**
- ✅ Built-in ESG compliance
- ✅ Automated carbon offsets
- ✅ Regulatory-ready
- ✅ Three-tier model (future-proof)

---

## 10. Conclusion

NetZero Receivables Vault bridges the gap between **TradFi ESG requirements** and **DeFi yield opportunities** through a three-tier ESG model. By supporting automatic carbon offsetting (Tier 1), overcompensation (Tier 2), and inherently sustainable assets (Tier 3), the protocol enables institutional investors to participate in DeFi while meeting regulatory and corporate sustainability mandates.

**Key Advantages:**
- 🎯 **Three-Tier Model**: Covers entire ESG spectrum (Article 8 to Article 9)
- 💰 **Superior Yields**: Access to DeFi returns with ESG compliance
- 🔒 **Regulatory Ready**: On-chain attestation and audit trails
- 🌐 **Composable**: Standard ERC-4626 interface for DeFi integration
- 🚀 **Future-Proof**: Architecture supports all three tiers from day one

**The Future:**
As ESG requirements become more stringent and DeFi yields remain attractive, NetZero Receivables Vault positions itself as the **infrastructure layer** that enables institutional capital to flow into decentralized finance while maintaining sustainability compliance across the entire ESG spectrum.

---

## Appendix A: Technical Specifications

### A.1 Contract Interfaces

**ERC-4626 Compliance:**
```solidity
interface IERC4626 {
    function asset() external view returns (address);
    function totalAssets() external view returns (uint256);
    function convertToShares(uint256 assets) external view returns (uint256);
    function convertToAssets(uint256 shares) external view returns (uint256);
    function deposit(uint256 assets, address receiver) external returns (uint256);
    function mint(uint256 shares, address receiver) external returns (uint256);
    function withdraw(uint256 assets, address receiver, address owner) external returns (uint256);
    function redeem(uint256 shares, address receiver, address owner) external returns (uint256);
}
```

**Carbon Offset Registry:**
```solidity
interface ICarbonOffsetRegistry {
    function getOffsetPrice() external view returns (uint256);
    function purchaseOffsets(uint256 kgCO2) external returns (bool);
    function recordPurchase(address buyer, uint256 amount) external;
    function getTotalOffsets(address account) external view returns (uint256);
}
```

**Green Receivables Registry:**
```solidity
interface IGreenReceivablesRegistry {
    function isGreenReceivable(bytes32 id) external view returns (bool);
    function getCarbonImpact(bytes32 id) external view returns (uint256);
    function verifyReceivableAsGreen(bytes32 id, GreenCategory category, uint256 impact) external;
}
```

---

## Appendix B: References

- ERC-4626 Tokenized Vault Standard: https://eips.ethereum.org/EIPS/eip-4626
- EU SFDR Regulation: https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32019R2088
- MiCA Regulation: https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32023R1114
- Verified Carbon Standard: https://verra.org/
- Gold Standard: https://www.goldstandard.org/

---

**© 2025 NetZero Receivables Vault Protocol**  
*Three-tier ESG compliance for DeFi yields.*

