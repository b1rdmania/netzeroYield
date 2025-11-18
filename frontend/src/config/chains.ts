import { type Chain } from 'viem';

export const raylsDevnet = {
  id: 123123,
  name: 'Rayls Devnet',
  nativeCurrency: { name: 'Rayls', symbol: 'RAYLS', decimals: 18 },
  rpcUrls: {
    default: { http: ['https://devnet-rpc.rayls.com'] },
    public: { http: ['https://devnet-rpc.rayls.com'] },
  },
  blockExplorers: {
    default: { name: 'Rayls Explorer', url: 'https://devnet-explorer.rayls.com' },
  },
  testnet: true,
} as const satisfies Chain; 