# Green Receivables Metadata Schema
## Asset Verification System for Tier 3 (Impact Vault)

---

## 🎯 Purpose

Define a schema for identifying and verifying "green receivables" - receivables from businesses with climate-positive or net-zero operations. This enables Tier 3 (Impact Vault) to only accept inherently sustainable assets.

---

## 📋 Receivable Metadata Structure

### Core Receivable Data

```solidity
struct Receivable {
    // Basic Info
    address originator;        // Company issuing receivable
    uint256 amount;            // Face value
    uint256 maturityDate;      // When receivable matures
    bytes32 receivableId;      // Unique identifier
    
    // ESG Classification
    GreenCategory category;    // Type of green asset
    uint256 carbonImpact;      // Negative carbon impact (kg CO2 removed/avoided)
    bool isVerified;           // Third-party verification status
    address verifier;           // Who verified this
    uint256 verificationDate; // When verified
    
    // Supporting Data
    string projectDescription; // What this receivable funds
    bytes32 certificationHash; // Hash of certification document
    string[] certifications;   // List of certifications (VCS, Gold Standard, etc.)
}
```

### Green Categories

```solidity
enum GreenCategory {
    NONE,                    // Not green (Tier 1/2 only)
    RENEWABLE_ENERGY,        // Solar, wind, hydro projects
    CARBON_REMOVAL,          // Biochar, DAC, reforestation
    ENERGY_EFFICIENCY,       // Building retrofits, efficiency upgrades
    EV_FLEET,                // Electric vehicle financing
    REGENERATIVE_AGRICULTURE, // Sustainable farming
    CIRCULAR_ECONOMY,        // Waste reduction, recycling
    GREEN_SAAS,              // Net-zero certified software companies
    OTHER                    // Other verified green activities
}
```

---

## 🔍 Verification Process

### Step 1: Originator Registration

```solidity
struct OriginatorProfile {
    address originator;
    string companyName;
    bool isNetZeroCertified;  // Company-level certification
    uint256 certificationExpiry;
    GreenCategory[] eligibleCategories; // What they can issue
    address certifier;         // Who certified them
}
```

**Requirements:**
- Company must have net-zero certification (or equivalent)
- Must specify eligible receivable categories
- Certification must be current (not expired)

### Step 2: Receivable Submission

When a receivable is submitted to the vault:

```solidity
function submitReceivable(
    Receivable memory receivable,
    bytes memory verificationProof
) external {
    // 1. Verify originator is registered
    require(isRegisteredOriginator(receivable.originator), "Originator not registered");
    
    // 2. Verify category eligibility
    require(
        isCategoryEligible(receivable.originator, receivable.category),
        "Category not eligible for this originator"
    );
    
    // 3. Verify carbon impact claim
    require(
        verifyCarbonImpact(receivable, verificationProof),
        "Carbon impact verification failed"
    );
    
    // 4. Record receivable
    receivables[receivable.receivableId] = receivable;
    emit ReceivableSubmitted(receivable.receivableId, receivable.originator);
}
```

### Step 3: Carbon Impact Verification

```solidity
function verifyCarbonImpact(
    Receivable memory receivable,
    bytes memory proof
) internal view returns (bool) {
    // Verification methods:
    // 1. Third-party certification (VCS, Gold Standard)
    // 2. On-chain attestation from trusted verifier
    // 3. Standardized calculation (e.g., renewable energy = X kg CO2/MWh)
    
    if (receivable.category == GreenCategory.RENEWABLE_ENERGY) {
        // Use standard calculation: 1 MWh renewable = ~500 kg CO2 avoided
        return verifyRenewableEnergyImpact(receivable, proof);
    }
    
    if (receivable.category == GreenCategory.CARBON_REMOVAL) {
        // Must have removal credit certificate
        return verifyRemovalCredit(receivable, proof);
    }
    
    // ... other categories
}
```

---

## 📊 Standard Carbon Impact Calculations

### Renewable Energy Receivables

**Formula:**
```
Carbon Impact (kg CO2) = Energy Generated (MWh) × Emission Factor (kg CO2/MWh avoided)
```

**Emission Factors:**
- Solar: ~500 kg CO2/MWh avoided
- Wind: ~500 kg CO2/MWh avoided
- Hydro: ~400 kg CO2/MWh avoided

**Example:**
- $100,000 receivable for solar installation
- Expected generation: 200 MWh/year
- Carbon impact: 200 × 500 = 100,000 kg CO2 avoided

### EV Fleet Financing

**Formula:**
```
Carbon Impact = Vehicles × Annual Miles × (ICE Emissions - EV Emissions) / Vehicle
```

**Example:**
- $500,000 receivable for 10 EV fleet vehicles
- Each vehicle: 15,000 miles/year
- ICE emissions: 0.4 kg CO2/mile
- EV emissions: 0.1 kg CO2/mile (grid average)
- Impact: 10 × 15,000 × 0.3 = 45,000 kg CO2/year avoided

### Energy Efficiency Retrofits

**Formula:**
```
Carbon Impact = Energy Saved (MWh) × Grid Emission Factor (kg CO2/MWh)
```

**Example:**
- $200,000 receivable for building retrofit
- Energy savings: 100 MWh/year
- Grid factor: 400 kg CO2/MWh
- Impact: 100 × 400 = 40,000 kg CO2/year avoided

---

## 🏛️ Verification Registry Contract

```solidity
contract GreenReceivablesRegistry {
    // Originator registry
    mapping(address => OriginatorProfile) public originators;
    
    // Receivable registry
    mapping(bytes32 => Receivable) public receivables;
    
    // Verifier registry (trusted verifiers)
    mapping(address => bool) public trustedVerifiers;
    
    // Events
    event OriginatorRegistered(address indexed originator, GreenCategory[] categories);
    event ReceivableVerified(bytes32 indexed receivableId, address indexed verifier);
    event ReceivableRejected(bytes32 indexed receivableId, string reason);
    
    // Registration
    function registerOriginator(
        address originator,
        string memory companyName,
        bool isNetZeroCertified,
        uint256 certificationExpiry,
        GreenCategory[] memory categories,
        address certifier
    ) external onlyAdmin {
        originators[originator] = OriginatorProfile({
            originator: originator,
            companyName: companyName,
            isNetZeroCertified: isNetZeroCertified,
            certificationExpiry: certificationExpiry,
            eligibleCategories: categories,
            certifier: certifier
        });
        
        emit OriginatorRegistered(originator, categories);
    }
    
    // Verification
    function verifyReceivable(
        bytes32 receivableId,
        Receivable memory receivable,
        bytes memory proof
    ) external onlyVerifier returns (bool) {
        // Verify originator
        require(
            originators[receivable.originator].isNetZeroCertified,
            "Originator not certified"
        );
        
        // Verify category
        require(
            isCategoryEligible(receivable.originator, receivable.category),
            "Category not eligible"
        );
        
        // Verify carbon impact
        require(
            verifyCarbonImpact(receivable, proof),
            "Carbon impact verification failed"
        );
        
        // Mark as verified
        receivable.isVerified = true;
        receivable.verifier = msg.sender;
        receivable.verificationDate = block.timestamp;
        receivables[receivableId] = receivable;
        
        emit ReceivableVerified(receivableId, msg.sender);
        return true;
    }
    
    // View functions
    function isGreenReceivable(bytes32 receivableId) external view returns (bool) {
        Receivable memory r = receivables[receivableId];
        return r.isVerified && r.category != GreenCategory.NONE;
    }
    
    function getCarbonImpact(bytes32 receivableId) external view returns (uint256) {
        return receivables[receivableId].carbonImpact;
    }
}
```

---

## 🎨 Frontend Integration

### Receivable Submission Form

```typescript
interface ReceivableSubmission {
  originator: string;
  amount: string;
  maturityDate: number;
  category: GreenCategory;
  carbonImpact: string;
  projectDescription: string;
  certifications: string[];
  verificationProof: File; // Upload certification document
}

// Form fields:
// - Originator (dropdown of registered companies)
// - Amount (USD)
// - Maturity date
// - Green category (dropdown)
// - Carbon impact calculation (auto-calculated based on category)
// - Project description
// - Certification upload
```

### Vault Dashboard

**Display:**
- Total receivables by category
- Total carbon impact (kg CO2 avoided)
- Verification status
- Green vs. non-green breakdown

**Example:**
```
Total Receivables: $5,000,000
├─ Renewable Energy: $2,000,000 (40%)
├─ EV Fleet: $1,500,000 (30%)
├─ Energy Efficiency: $1,000,000 (20%)
└─ Other Green: $500,000 (10%)

Total Carbon Impact: 2,500,000 kg CO2 avoided
Verification Status: 100% verified
```

---

## 🔐 Security Considerations

### Verification Trust Model

**Option 1: Centralized Verifiers (MVP)**
- Trusted list of verifiers (multisig-controlled)
- Fast, simple for hackathon
- Can decentralize later

**Option 2: Decentralized Verification (Future)**
- Staking-based verification
- Reputation system
- Slashing for false verifications

### Certification Storage

**Option 1: On-Chain Metadata**
- Store certification hash on-chain
- Full document stored off-chain (IPFS)
- Verifiable but gas-intensive

**Option 2: Off-Chain with Attestation**
- Certification stored off-chain
- On-chain attestation from verifier
- Lower gas, requires trust in verifier

---

## 📈 MVP Implementation (Hackathon)

### Simplified Schema

For hackathon, use simplified version:

```solidity
struct SimpleReceivable {
    address originator;
    uint256 amount;
    uint256 maturityDate;
    GreenCategory category;
    uint256 carbonImpact; // Pre-calculated, provided by originator
    bool isVerified;      // Manual verification for MVP
}
```

### MVP Verification Flow

1. **Originator submits receivable** with category and carbon impact
2. **Admin/verifier reviews** (manual for MVP)
3. **Mark as verified** if approved
4. **Vault accepts** only verified receivables (Tier 3 mode)

### Future: Automated Verification

- Integration with certification APIs (VCS, Gold Standard)
- Standardized calculation libraries
- AI-assisted verification
- Reputation-based decentralized verification

---

## 🎯 Integration with Vault

### Vault Contract Integration

```solidity
contract NetZeroReceivablesVault {
    GreenReceivablesRegistry public registry;
    VaultMode public mode;
    
    function depositReceivable(bytes32 receivableId) external {
        if (mode == VaultMode.IMPACT) {
            require(
                registry.isGreenReceivable(receivableId),
                "Only green receivables allowed in Impact mode"
            );
        }
        
        Receivable memory r = registry.receivables(receivableId);
        // ... deposit logic
    }
    
    function getTotalCarbonImpact() external view returns (uint256) {
        // Sum carbon impact of all deposited receivables
        // Only counts if in Impact mode or if receivable is verified green
    }
}
```

---

## 📝 Next Steps

1. **Implement registry contract** (simplified for MVP)
2. **Create verification UI** (admin panel for hackathon)
3. **Build receivable submission form** (frontend)
4. **Integrate with vault** (Tier 3 mode support)

**Ready to implement?** 🚀

