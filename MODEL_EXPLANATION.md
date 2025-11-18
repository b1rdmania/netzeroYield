# The Model - Clear Explanation

## Current Problem (Confusing)

**What we built:**
- Fund share NFTs (ERC-721) → Fund tokens (ERC-20)
- But fund shares don't generate yield on-chain
- They're just NFTs representing positions
- Yield comes from off-chain fund performance (not on-chain)

**This doesn't work because:**
- No on-chain yield source
- Fund shares are just NFTs, not yield-bearing assets
- Can't automatically harvest yield from NFTs

---

## Simple ESG Yield Vault (Better Model)

### The Model:

1. **Users deposit USDC/stablecoins** → Vault
2. **Vault deploys to yield strategies** → Lending, LP, other DeFi
3. **Yield is generated** → From DeFi strategies
4. **When yield is harvested** → Automatically purchase carbon offsets
5. **Users get** → Yield + ESG compliance

### Why This Works:

✅ **Clear value prop**: Deposit → Get yield → Auto offset → Net-zero  
✅ **Actually generates yield**: From real DeFi strategies  
✅ **Simple to understand**: Standard ERC-4626 vault + ESG layer  
✅ **Works on-chain**: All yield is on-chain, all offsets are on-chain  

### Example Flow:

```
User deposits 10,000 USDC
  ↓
Vault deploys to lending protocol (8% APY)
  ↓
After 1 year: 10,800 USDC total
  ↓
800 USDC yield generated
  ↓
Calculate carbon footprint: ~40 kg CO2
  ↓
Purchase offsets: ~$2 (0.25% of yield)
  ↓
User gets: 10,798 USDC (99.75% of yield, net-zero)
```

### What We Need:

1. **Simple ERC-4626 vault** that accepts USDC
2. **Yield strategy** (lending, LP, etc.)
3. **Carbon offset integration** on harvest
4. **Accredited investor gating** (optional, via Rayls)

---

## Recommendation

**Simplify to: "NetZero Yield Vault"**

- Accept USDC deposits
- Deploy to yield strategies
- Auto-offset on harvest
- Accredited investor gating (Rayls)
- Standard ERC-4626 interface

This is:
- ✅ Clear
- ✅ Works
- ✅ Easy to demo
- ✅ Actually generates yield
- ✅ ESG-compliant

