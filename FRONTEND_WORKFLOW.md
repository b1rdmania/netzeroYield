# Frontend Workflow & Page Structure

## 📱 App Pages Overview

### Current Pages (Need Updates)

1. **Landing Page** (`/`) ✅ DONE
   - Firestar-inspired design
   - Dark green & gold
   - Minimal, professional

2. **Whitepaper Page** (`/whitepaper`) ⚠️ NEEDS UPDATE
   - Update content for ERC-4626 yield vault
   - Match Firestar design

3. **App Shell** (`/app/*`) ⚠️ NEEDS REDESIGN
   - Currently: Deposit, Trade, Redeem (old vS vault model)
   - Need: Dashboard, Deposit, Withdraw, ESG Metrics

---

## 🔄 Proposed Page Structure

### `/app/dashboard` (Home/Overview)
**Purpose:** Main vault overview

**Content:**
- Vault metrics (total assets, total shares, APY)
- ESG metrics (carbon footprint, offsets, net-zero status)
- User's position (shares owned, assets deposited, yield earned)
- Recent activity feed
- Quick actions (Deposit, Withdraw buttons)

**Data Needed:**
- `vault.totalAssets()` - Total USDC in vault
- `vault.totalSupply()` - Total shares minted
- `vault.balanceOf(user)` - User's shares
- `vault.getESGMetrics()` - ESG data
- `vault.isNetZero()` - Net-zero status
- `yieldStrategy.totalAssets()` - Yield generated

---

### `/app/deposit`
**Purpose:** Deposit USDC into vault

**Flow:**
1. Check wallet connection
2. Check accreditation (if required)
3. Enter deposit amount
4. Preview: shares to receive, fees
5. Approve USDC (if needed)
6. Deposit → Get shares
7. Show success + updated balance

**Contract Calls:**
- `vault.previewDeposit(amount)` - Shares preview
- `usdc.approve(vault, amount)` - Approve spending
- `vault.deposit(amount, user)` - Deposit

**UI:**
- Input field for USDC amount
- Max button (use wallet balance)
- Preview card (shares, fees)
- Deposit button
- Accreditation status indicator

---

### `/app/withdraw`
**Purpose:** Withdraw assets from vault

**Flow:**
1. Show current shares balance
2. Enter withdraw amount (USDC or shares)
3. Preview: shares to burn, USDC to receive
4. Withdraw → Burn shares → Get USDC
5. Show success + updated balance

**Contract Calls:**
- `vault.previewRedeem(shares)` - Assets preview
- `vault.redeem(shares, user, user)` - Withdraw

**UI:**
- Current shares display
- Input field (USDC or shares)
- Max button
- Preview card
- Withdraw button

---

### `/app/esg`
**Purpose:** ESG metrics dashboard

**Content:**
- Carbon footprint (total, per user)
- Carbon offsets purchased (total, per user)
- Net-zero status (visual indicator)
- Historical chart (footprint vs offsets over time)
- Offset percentage (currently 100%, configurable)

**Data Needed:**
- `vault.getESGMetrics()` - Returns (footprint, offsets, isNetZero)
- `vault.getTotalFootprint()` - Total footprint
- `vault.getTotalOffsets()` - Total offsets
- `vault.isNetZero()` - Boolean status
- `vault.getOffsetBps()` - Offset percentage

**UI:**
- Large net-zero status indicator (green if net-zero)
- Metrics cards (footprint, offsets, ratio)
- Simple chart (if time permits)
- Historical events (harvests, offsets)

---

## 🔗 Contract Integration

### Hooks Needed

**`useNetZeroVault.ts`**
```typescript
- deposit(amount)
- withdraw(amount)
- redeem(shares)
- totalAssets()
- totalSupply()
- balanceOf(address)
- previewDeposit(amount)
- previewRedeem(shares)
```

**`useESGMetrics.ts`**
```typescript
- getESGMetrics() → {footprint, offsets, isNetZero}
- getTotalFootprint()
- getTotalOffsets()
- isNetZero()
```

**`useAccreditation.ts`**
```typescript
- isAccredited(address) → boolean
- checkAccreditation() → check current user
```

**`useYieldStrategy.ts`**
```typescript
- getAPY() → estimated APY
- totalAssets() → total in strategy
- balanceOf(vault) → vault's position
```

---

## 🎨 Design Requirements

**All pages must:**
- Match Firestar minimal style
- Dark green background (`#0a0f0a`)
- Gold accents (`#f59e0b`)
- Small text (14px body)
- Clean borders, minimal shadows
- Professional institutional look

**Consistent Elements:**
- Header with logo + nav
- Connect wallet button (RainbowKit)
- Footer with links
- Loading states
- Error handling

---

## 📋 Implementation Order

1. **Update AppShell** - New nav structure
2. **Create Dashboard** - Overview page
3. **Update Deposit** - USDC deposit flow
4. **Update Withdraw** - Asset withdrawal
5. **Create ESG Page** - Metrics dashboard
6. **Update Whitepaper** - Content + design
7. **Connect Contracts** - Wire up hooks
8. **Test & Polish** - End-to-end testing

---

## ❓ Questions

1. **Navigation:** Should we keep Trade page, or remove it? (ERC-4626 shares are tradeable on any DEX)

2. **Dashboard Priority:** What's most important to show first?
   - Vault metrics?
   - User position?
   - ESG status?

3. **Accreditation:** Show accreditation check on deposit page, or separate page?

4. **Yield Display:** Show estimated APY, or actual yield earned?

5. **ESG Metrics:** Real-time updates, or refresh on page load?

