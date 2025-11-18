# NetZero Yield - Implementation Timeline

## 🎯 Current Status

**What's Built:**
- ✅ Landing page (Firestar-inspired design)
- ✅ NetZeroYieldVault.sol (ERC-4626 with ESG)
- ✅ MockYieldStrategy.sol
- ✅ Mock contracts (Identity, CarbonOffset)
- ✅ Rayls Devnet configuration

**What Needs Work:**
- ⚠️ App pages (Deposit, Withdraw, Dashboard)
- ⚠️ Contract integration (connect frontend to contracts)
- ⚠️ Whitepaper page (update content)
- ⚠️ README cleanup
- ⚠️ Full workflow implementation

---

## 📋 Implementation Plan

### Phase 1: Documentation & Cleanup (1-2 hours)
**Priority: HIGH**

1. **Clean up README.md**
   - Remove old receivables/fund share references
   - Focus on ERC-4626 yield vault with ESG
   - Keep one reference doc (whitepaper summary)
   - Add quick start guide

2. **Consolidate documentation**
   - Keep: `ESG_VAULT_WHITEPAPER_V2.md` (main reference)
   - Archive/remove: Old brainstorming docs, adaptation guides
   - Create: `QUICK_START.md` for developers

**Deliverables:**
- Clean README.md
- One consolidated whitepaper reference
- Quick start guide

---

### Phase 2: App Pages - Design & Structure (2-3 hours)
**Priority: HIGH**

**Pages to Update:**

1. **Dashboard/Home (`/app/deposit` → `/app/dashboard`)**
   - Overview of vault metrics
   - Total assets, yield generated, carbon offsets
   - Net-zero status indicator
   - Recent activity

2. **Deposit Page (`/app/deposit`)**
   - Connect wallet
   - Check accreditation (Rayls identity)
   - Deposit USDC → Get vault shares
   - Show preview: amount, shares, fees

3. **Withdraw Page (`/app/withdraw`)**
   - View current vault shares
   - Withdraw assets (burn shares → get USDC)
   - Show yield earned, offsets purchased

4. **ESG Metrics Page (`/app/esg`)**
   - Carbon footprint tracking
   - Offsets purchased
   - Net-zero status
   - Historical charts

**Design Requirements:**
- Match Firestar minimal style (dark green, gold accents)
- Small text (14px body)
- Clean, professional layout
- Consistent with landing page

**Deliverables:**
- All app pages redesigned
- Consistent styling
- Updated content for yield vault

---

### Phase 3: Contract Integration (3-4 hours)
**Priority: HIGH**

**What to Connect:**

1. **NetZeroYieldVault Contract**
   - Read: `totalAssets()`, `totalSupply()`, `convertToShares()`
   - Write: `deposit()`, `withdraw()`, `redeem()`
   - Events: `Deposit`, `Withdraw`, `YieldHarvested`

2. **ESG Metrics**
   - Read: `getESGMetrics()`, `isNetZero()`, `getTotalFootprint()`
   - Display: Carbon footprint, offsets, net-zero status

3. **Accreditation Check**
   - Read: `IDENTITY_REGISTRY.isAccredited(address)`
   - Show: Accreditation status before deposit

4. **Yield Strategy**
   - Read: `yieldStrategy.totalAssets()`, `yieldStrategy.balanceOf()`
   - Display: Current yield, APY estimate

**Hooks to Create:**
- `useNetZeroVault.ts` - Main vault interactions
- `useESGMetrics.ts` - ESG data fetching
- `useAccreditation.ts` - Rayls identity checks
- `useYieldStrategy.ts` - Yield calculations

**Deliverables:**
- Working contract hooks
- Deposit/withdraw functionality
- ESG metrics display
- Accreditation gating

---

### Phase 4: Whitepaper Page (1 hour)
**Priority: MEDIUM**

**Content to Update:**
- Remove all Sonic/fNFT references
- Update to ERC-4626 yield vault model
- Focus on ESG compliance
- Rayls integration details
- Match Firestar design style

**Deliverables:**
- Updated whitepaper page
- Consistent design
- Accurate content

---

### Phase 5: Testing & Polish (2-3 hours)
**Priority: MEDIUM**

1. **End-to-End Testing**
   - Deposit flow
   - Withdraw flow
   - ESG metrics updates
   - Accreditation checks

2. **Error Handling**
   - Network errors
   - Contract errors
   - User feedback

3. **Mobile Responsiveness**
   - Test all pages on mobile
   - Fix layout issues

4. **Performance**
   - Optimize contract reads
   - Loading states
   - Caching

**Deliverables:**
- Fully working app
- Error handling
- Mobile responsive
- Polished UX

---

## 🎯 Questions for You

1. **Contract Addresses**: Do you have deployed contracts on Rayls Devnet, or should we use mock addresses for now?

2. **Yield Strategy**: Should we use the MockYieldStrategy for demo, or integrate with a real DeFi protocol?

3. **Accreditation**: Should accreditation be required by default, or optional (toggle in vault)?

4. **ESG Metrics**: Do you want real-time updates, or periodic refresh?

5. **Pages Priority**: Which pages are most important for the demo? (I'd suggest: Dashboard + Deposit)

6. **Deployment**: Should we deploy contracts first, or build frontend with mocks?

---

## 📊 Estimated Timeline

**Total: 9-13 hours**

- Phase 1 (Docs): 1-2 hours
- Phase 2 (Pages): 2-3 hours  
- Phase 3 (Integration): 3-4 hours
- Phase 4 (Whitepaper): 1 hour
- Phase 5 (Polish): 2-3 hours

**For Hackathon Demo:**
- Minimum viable: Phase 1 + Phase 2 (design) + Phase 3 (basic deposit) = 6-9 hours
- Full working: All phases = 9-13 hours

---

## 🚀 Recommended Order

1. **Start with Phase 1** - Clean up docs (quick win)
2. **Then Phase 2** - Get pages looking right (visual progress)
3. **Then Phase 3** - Connect contracts (functional progress)
4. **Then Phase 4** - Update whitepaper (content)
5. **Finally Phase 5** - Polish everything (demo ready)

---

## 📝 Next Steps

1. Answer questions above
2. Start with Phase 1 (README cleanup)
3. Move to Phase 2 (page designs)
4. Integrate contracts (Phase 3)
5. Polish for demo (Phase 5)

