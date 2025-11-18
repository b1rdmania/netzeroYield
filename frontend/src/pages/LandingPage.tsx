import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { motion } from 'framer-motion';
import { ESGIconSet } from '../components/ESGIcons';
import './LandingPage.css';

export const LandingPage: React.FC = () => {
  const [showStickyBar, setShowStickyBar] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      const heroHeight = window.innerHeight;
      setShowStickyBar(window.scrollY > heroHeight);
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  const stepData = [
    { id: 1, label: "Deposit Assets", tooltip: "Deposit USDC or other stablecoins into the ERC-4626 vault. Accredited investors only (via Rayls identity)." },
    { id: 2, label: "Generate Yield", tooltip: "Vault automatically deploys assets to yield strategies (lending, LP, etc.) generating returns." },
    { id: 3, label: "Auto-Offset", tooltip: "When yield is harvested, vault automatically calculates carbon footprint and purchases verified offsets." },
    { id: 4, label: "Net-Zero Yield", tooltip: "You receive yield with ESG compliance. All carbon emissions are automatically offset to maintain net-zero status." },
    { id: 5, label: "Withdraw Anytime", tooltip: "Redeem your vault shares for underlying assets plus accrued yield, all while maintaining net-zero compliance." }
  ];

  const benefitVariants = {
    hidden: { opacity: 0, y: 20 },
    visible: { opacity: 1, y: 0 }
  };

  const containerVariants = {
    hidden: { opacity: 0 },
    visible: {
      opacity: 1,
      transition: {
        staggerChildren: 0.1
      }
    }
  };

  return (
    <div className="landing-page-modern">
      {/* Sticky ESG Bar */}
      {showStickyBar && (
        <motion.div
          initial={{ y: -100 }}
          animate={{ y: 0 }}
          style={{
            position: 'sticky',
            top: 0,
            zIndex: 30,
            backgroundColor: '#065f46',
            color: 'white',
            padding: '0.5rem 0',
            textAlign: 'center',
            fontSize: '0.875rem'
          }}
        >
          <span style={{ margin: '0 0.5rem' }}>🌱 Net-Zero Carbon</span>
          <span style={{ margin: '0 0.5rem' }}>|</span>
          <span style={{ margin: '0 0.5rem' }}>🔒 Accredited Investors</span>
          <span style={{ margin: '0 0.5rem' }}>|</span>
          <span style={{ margin: '0 0.5rem' }}>💚 ESG-Compliant Yield</span>
        </motion.div>
      )}

      <header className="landing-header">
        <div className="container header-content">
          <div className="logo" style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
            <img 
              src="https://img.icons8.com/?id=794&format=png&size=32" 
              alt="Leaf" 
              style={{ filter: 'brightness(0) saturate(100%) invert(48%) sepia(79%) saturate(2476%) hue-rotate(130deg) brightness(118%) contrast(119%)' }}
            />
            NetZero Yield
          </div>
          <Link to="/app" className="button-primary">
            Launch App
          </Link>
        </div>
      </header>

      <main>
        {/* Hero Section */}
        <section className="hero-section-gradient">
          <div className="container">
            <div className="hero-grid">
              <motion.div 
                className="hero-content"
                initial={{ opacity: 0, x: -50 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ duration: 0.8 }}
              >
                <h1 className="hero-title-modern">
                  DeFi Yield with Automatic ESG Compliance
                </h1>
                <p className="hero-subtitle-modern">
                  Standard ERC-4626 vault that generates yield and automatically purchases carbon offsets. Net-zero from day one. Built on Rayls.
                </p>
                <div className="hero-buttons-modern">
                  <Link to="/app" className="button-primary-modern">
                    Launch App
                  </Link>
                  <a href="https://github.com/b1rdmania/netzeroYield" target="_blank" rel="noopener noreferrer" className="button-secondary-modern">
                    GitHub
                  </a>
                  <Link to="/whitepaper" className="button-secondary-modern">
                    White Paper
                  </Link>
                </div>
              </motion.div>
              <motion.div 
                className="hero-visual"
                initial={{ opacity: 0, x: 50 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ duration: 0.8, delay: 0.2 }}
              >
                <div className="flow-diagram">
                  <div className="flow-text">Deposit → Yield → Auto-Offset → Net-Zero</div>
                </div>
              </motion.div>
            </div>
          </div>
        </section>

        {/* ESG Icons Section */}
        <section className="esg-icons-section" style={{ padding: '64px 0', background: 'linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%)' }}>
          <div className="container">
            <motion.h2 
              className="section-title"
              style={{ color: '#065f46', marginBottom: '32px' }}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
            >
              ESG-First Yield Vault
            </motion.h2>
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: 0.2 }}
            >
              <ESGIconSet />
            </motion.div>
          </div>
        </section>

        {/* How It Works */}
        <section className="stepper-section" style={{ color: '#1a1a1a', backgroundColor: 'white' }}>
          <div className="container">
            <motion.h2 
              className="section-title"
              style={{ color: '#065f46', marginBottom: '48px' }}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
            >
              How It Works
            </motion.h2>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '24px', maxWidth: '800px', margin: '0 auto' }}>
              {stepData.map((step, index) => (
                <motion.div
                  key={step.id}
                  initial={{ opacity: 0, x: -20 }}
                  whileInView={{ opacity: 1, x: 0 }}
                  viewport={{ once: true }}
                  transition={{ delay: index * 0.1 }}
                  style={{
                    display: 'flex',
                    gap: '20px',
                    padding: '24px',
                    background: '#f8fafc',
                    borderRadius: '12px',
                    border: '1px solid #e2e8f0',
                    alignItems: 'center'
                  }}
                >
                  <div style={{
                    width: '40px',
                    height: '40px',
                    borderRadius: '50%',
                    background: 'linear-gradient(135deg, #059669, #10b981)',
                    color: 'white',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    fontWeight: 700,
                    flexShrink: 0
                  }}>
                    {step.id}
                  </div>
                  <div style={{ flex: 1 }}>
                    <h3 style={{ fontSize: '1.125rem', fontWeight: 600, color: '#1e293b', marginBottom: '4px' }}>
                      {step.label}
                    </h3>
                    <p style={{ fontSize: '0.875rem', color: '#64748b', margin: 0 }}>
                      {step.tooltip}
                    </p>
                  </div>
                </motion.div>
              ))}
            </div>
          </div>
        </section>

        {/* Key Benefits */}
        <section className="benefits-section-modern" style={{ color: '#1a1a1a', backgroundColor: '#f8fafc' }}>
          <div className="container">
            <motion.h2 
              className="section-title"
              style={{ color: '#065f46' }}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
            >
              Why NetZero Yield?
            </motion.h2>
            <motion.div 
              className="benefits-grid-modern"
              variants={containerVariants}
              initial="hidden"
              whileInView="visible"
              viewport={{ once: true }}
            >
              {[
                { emoji: "🌱", title: "Automatic Net-Zero", text: "Every yield harvest automatically purchases carbon offsets. No manual compliance needed." },
                { emoji: "📈", title: "DeFi Yields", text: "Access superior DeFi returns (5-15% APY) while maintaining ESG compliance." },
                { emoji: "🔒", title: "Accredited Investor Gating", text: "Optional Rayls identity verification ensures institutional-grade access control." },
                { emoji: "📊", title: "Transparent Metrics", text: "On-chain ESG metrics: carbon footprint, offsets purchased, net-zero status. Fully auditable." },
                { emoji: "🧩", title: "ERC-4626 Standard", text: "Composable with all DeFi protocols. Standard interface for maximum interoperability." },
                { emoji: "⚡", title: "Sub-Second Offsets", text: "Rayls' deterministic finality enables real-time carbon offset purchases on every harvest." }
              ].map((benefit, index) => (
                <motion.div
                  key={index}
                  className="benefit-card-modern"
                  variants={benefitVariants}
                  whileHover={{ y: -5, scale: 1.02 }}
                  transition={{ type: "spring", stiffness: 300 }}
                >
                  <div className="benefit-emoji">{benefit.emoji}</div>
                  <h3 className="benefit-title">{benefit.title}</h3>
                  <p className="benefit-text">{benefit.text}</p>
                </motion.div>
              ))}
            </motion.div>
          </div>
        </section>

        {/* Why Rayls */}
        <section className="why-sonic-modern" style={{ color: '#1a1a1a' }}>
          <div className="container">
            <motion.h2 
              className="section-title"
              style={{ color: '#065f46' }}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
            >
              Built for Rayls
            </motion.h2>
            <div className="sonic-benefits-grid">
              {[
                {
                  icon: <span style={{ fontSize: '2rem' }}>⚡</span>,
                  title: "Sub-Second Finality",
                  text: "Real-time carbon offset purchases. No waiting for confirmations—offsets match yield instantly."
                },
                {
                  icon: <span style={{ fontSize: '2rem' }}>🆔</span>,
                  title: "Identity Layer",
                  text: "Built-in accredited investor verification. No external KYC providers needed."
                },
                {
                  icon: <span style={{ fontSize: '2rem' }}>💼</span>,
                  title: "Institutional Ready",
                  text: "Private nodes, USD-pegged gas, and compliance features built for institutions."
                }
              ].map((item, index) => (
                <motion.div
                  key={index}
                  className="sonic-benefit-card"
                  initial={{ opacity: 0, y: 20 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  viewport={{ once: true }}
                  transition={{ delay: index * 0.1 }}
                  whileHover={{ y: -3 }}
                >
                  <div className="sonic-icon">{item.icon}</div>
                  <h3 className="sonic-title">{item.title}</h3>
                  <p className="sonic-text">{item.text}</p>
                </motion.div>
              ))}
            </div>
          </div>
        </section>

        {/* FAQ */}
        <section className="faq-section-modern" style={{ color: '#1a1a1a' }}>
          <div className="container">
            <motion.h2 
              className="section-title"
              style={{ color: '#065f46' }}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
            >
              FAQ
            </motion.h2>
            <div className="faq-accordion-modern">
              <details open>
                <summary>
                  How does automatic carbon offsetting work?
                </summary>
                <p>When yield is harvested from the vault's strategies, the protocol automatically calculates the carbon footprint and purchases verified carbon offsets. This happens in real-time thanks to Rayls' sub-second finality.</p>
              </details>
              <details>
                <summary>
                  Who can use this vault?
                </summary>
                <p>By default, anyone can deposit. However, the vault can be configured to require accredited investor verification via Rayls' identity registry for institutional compliance.</p>
              </details>
              <details>
                <summary>
                  What yield strategies does the vault use?
                </summary>
                <p>The vault can deploy to any yield-generating strategy: lending protocols, liquidity pools, other ERC-4626 vaults, or RWA strategies. The strategy is upgradeable via governance.</p>
              </details>
              <details>
                <summary>
                  How much does carbon offsetting cost?
                </summary>
                <p>Carbon offset costs are typically 0.25-0.5% of yield generated. The vault automatically deducts this from yield before distribution, ensuring net-zero compliance without manual intervention.</p>
              </details>
              <details>
                <summary>
                  Is this ERC-4626 compliant?
                </summary>
                <p>Yes. The vault implements the full ERC-4626 standard, making it composable with all DeFi protocols. You can deposit, withdraw, and use vault shares in any ERC-4626 compatible application.</p>
              </details>
            </div>
          </div>
        </section>

        {/* Final CTA */}
        <section className="final-cta-gradient">
          <div className="container">
            <motion.div
              className="cta-content"
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
            >
              <h2 className="cta-title">Ready for Net-Zero Yield?</h2>
              <p className="cta-subtitle">Deposit assets → Generate yield → Automatic offsets → ESG compliance</p>
              <p className="cta-tagline">
                <em>DeFi yields with automatic ESG compliance. No compromises.</em>
              </p>
              <Link to="/app" className="button-primary-large">
                Launch App
              </Link>
            </motion.div>
          </div>
        </section>
      </main>

      <footer className="landing-footer-modern">
        <div className="container">
          <div className="footer-links">
            <a href="https://github.com/b1rdmania/netzeroYield" target="_blank" rel="noopener noreferrer">
              GitHub
            </a>
            <span style={{ margin: '0 8px' }}>|</span>
            <Link to="/app">
              Launch App
            </Link>
          </div>
          <p>&copy; 2025 NetZero Yield. ESG-compliant DeFi yields.</p>
          <p style={{ fontSize: '0.875rem', color: '#64748b', marginTop: '8px' }}>
            Open-source & community-run • MIT licence • Built for Rayls Hackathon
          </p>
        </div>
      </footer>
    </div>
  );
};
