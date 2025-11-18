import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { motion } from 'framer-motion';
import { StepIndicator } from '../components/StepIndicator';
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
    { id: 1, label: "Send the NFT", tooltip: "Drop your locked Sonic NFT into the vault." },
    { id: 2, label: "Get vS tokens", tooltip: "Vault mints 99% of the face value as vS (1% mint fee)." },
    { id: 3, label: "Put vS to work", tooltip: "Swap vS for S or USDC, LP it for trading fees, or lend / farm it for yield—the whole Sonic DeFi stack now opens up to you. The market sets the discount." },
    { id: 4, label: "Nine-month timer ends", tooltip: "Vault auto-claims every NFT once the burn penalty is 0%." },
    { id: 5, label: "Swap vS back to S", tooltip: "Burn vS, pay a 2% exit fee, and receive the matching S one-for-one." }
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
      {/* Sticky Economics Bar */}
      {showStickyBar && (
        <motion.div
          initial={{ y: -100 }}
          animate={{ y: 0 }}
          style={{
            position: 'sticky',
            top: 0,
            zIndex: 30,
            backgroundColor: '#0f172a',
            color: 'white',
            padding: '0.5rem 0',
            textAlign: 'center',
            fontSize: '0.875rem'
          }}
        >
          <span style={{ margin: '0 0.5rem' }}>Fees: 1% mint • 2% redeem</span>
          <span style={{ margin: '0 0.5rem' }}>|</span>
          <span style={{ margin: '0 0.5rem' }}>Total cost ≈3% to skip 9-month wait</span>
          <span style={{ margin: '0 0.5rem' }}>|</span>
          <span style={{ margin: '0 0.5rem' }}>Net to you ≈97%</span>
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
        {/* Hero Section - Full Bleed Gradient */}
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
                  Net-Zero Institutional Fund Vault
                </h1>
                <p className="hero-subtitle-modern">
                  Accredited-investor gated • Automated carbon offsetting • ESG-compliant from day one
                </p>
                <div className="hero-buttons-modern">
                  <Link to="/app" className="button-primary-modern">
                    Launch App
                  </Link>
                  <a href="https://github.com/b1rdmania/vs-token-mvp" target="_blank" rel="noopener noreferrer" className="button-secondary-modern">
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
                  <div className="flow-text">fNFT → Vault → vS → DeFi</div>
                </div>
              </motion.div>
            </div>
          </div>
        </section>

        {/* Interactive Stepper */}
        <section className="stepper-section" style={{ color: '#1a1a1a', backgroundColor: 'white' }}>
          <div className="container">
            <StepIndicator title="⚡ 60-Second Flow — ELI-15" steps={stepData} />
            <motion.div 
              style={{ 
                marginTop: '48px', 
                textAlign: 'center',
                background: '#f8fafc',
                padding: '24px 32px',
                borderRadius: '12px',
                border: '1px solid #e2e8f0'
              }}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
            >
              <p style={{ 
                fontSize: '1.1rem', 
                fontWeight: 600, 
                color: '#1e293b',
                margin: 0,
                lineHeight: 1.6
              }}>
                <strong>Bottom line:</strong> skip the nine-month wait for roughly 3% total cost and let your value earn the whole time.
              </p>
            </motion.div>
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
              ESG-First Institutional Vault
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

        {/* Key Benefits - Animated Cards */}
        <section className="benefits-section-modern" style={{ color: '#1a1a1a', backgroundColor: '#f8fafc' }}>
          <div className="container">
            <motion.h2 
              className="section-title"
              style={{ color: '#065f46' }}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
            >
              Key Benefits
            </motion.h2>
            <motion.div 
              className="benefits-grid-modern"
              variants={containerVariants}
              initial="hidden"
              whileInView="visible"
              viewport={{ once: true }}
            >
              {[
                { emoji: "🌱", title: "Net-Zero Carbon", text: "Automatic carbon offsetting ensures ESG compliance from day one." },
                { emoji: "🔒", title: "Accredited Investors Only", text: "Rayls identity gating ensures institutional-grade access control." },
                { emoji: "💚", title: "ESG Compliant", text: "Real-time carbon footprint tracking and offset verification." },
                { emoji: "📊", title: "Transparent Metrics", text: "On-chain ESG metrics: footprint, offsets, and net-zero status." },
                { emoji: "🛡️", title: "Governance Protected", text: "Upgrades require multisig approval and a public timelock (12h delay)." },
                { emoji: "🎯", title: "Liquid Fund Shares", text: "Convert illiquid VC fund positions into tradeable ERC-20 tokens." }
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

        {/* Why Sonic - Icon Cards */}
        <section className="why-sonic-modern" style={{ color: '#1a1a1a' }}>
          <div className="container">
            <motion.h2 
              className="section-title"
              style={{ color: '#1e293b' }}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
            >
              Why this is good for Sonic
            </motion.h2>
            <div className="sonic-benefits-grid">
              {[
                {
                  icon: <span style={{ fontSize: '2rem' }}>📈</span>,
                  title: "Adds TVL",
                  text: "Locked value turns into LP depth & swap fees"
                },
                {
                  icon: <span style={{ fontSize: '2rem' }}>🌊</span>,
                  title: "Smoother Price",
                  text: "Sell pressure drips instead of nuking day-one"
                },
                {
                  icon: <span style={{ fontSize: '2rem' }}>🧩</span>,
                  title: "More DeFi Lego",
                  text: "Users stay to farm / lend → sticky ecosystem"
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

        {/* FAQ with Icons */}
        <section className="faq-section-modern" style={{ color: '#1a1a1a' }}>
          <div className="container">
            <motion.h2 
              className="section-title"
              style={{ color: '#1e293b' }}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
            >
              FAQ
            </motion.h2>
            <div className="faq-accordion-modern">
              <details open>
                <summary>
                  {/* Replace the question mark icons with emoji */}
                  {/* 🤔 */}
                  Can the fees change?
                </summary>
                <p>1% mint fee, 2% redeem fee — any change requires multisig approval and a public timelock (12h delay for upgrades).</p>
              </details>
              <details>
                <summary>
                  {/* Replace the question mark icons with emoji */}
                  {/* 🤔 */}
                  Is the 1:1 real?
                </summary>
                <p>Yes. Vault claims every S at 0% burn; redeem burns vS and releases S.</p>
              </details>
              <details>
                <summary>
                  {/* Replace the question mark icons with emoji */}
                  {/* 🤔 */}
                  What if a claim fails?
                </summary>
                <p>Vault harvests all ERC-1155 fNFTs in a single batch using the ERC-1155 standard's batch operations. The protocol triggers harvest automatically at maturity, ensuring all fNFTs are claimed efficiently.</p>
              </details>
              <details>
                <summary>
                  {/* Replace the question mark icons with emoji */}
                  {/* 🤔 */}
                  Where's the code?
                </summary>
                <p>Verified contracts & audits: view on SonicScan → <a href="https://sonicscan.org/address/0xE2BB365a107441C1734a7aC08930dbEbb421249d" target="_blank" rel="noopener noreferrer" style={{ color: '#6366f1', textDecoration: 'underline' }}>Vault</a>, <a href="https://sonicscan.org/address/0x2286bA4fcbb2eF06C4349fAF6B8970ece593f5DD" target="_blank" rel="noopener noreferrer" style={{ color: '#6366f1', textDecoration: 'underline' }}>vS</a>.</p>
              </details>
            </div>
          </div>
        </section>

        {/* Final CTA - Gradient Footer */}
        <section className="final-cta-gradient">
          <div className="container">
            <motion.div
              className="cta-content"
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
            >
              <h2 className="cta-title">Ready?</h2>
              <p className="cta-subtitle">Connect wallet → deposit fNFT → mint vS.</p>
              <p className="cta-tagline">
                <em>Turn waiting into doing.</em>
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
            <a href="https://github.com/b1rdmania/vs-token-mvp" target="_blank" rel="noopener noreferrer">
              GitHub
            </a>
            <span style={{ margin: '0 8px' }}>|</span>
            <Link to="/app">
              Launch App
            </Link>
          </div>
          <p>&copy; 2025 NetZero Yield. ESG-compliant institutional DeFi.</p>
          <p style={{ fontSize: '0.875rem', color: '#64748b', marginTop: '8px' }}>
            Open-source & community-run • MIT licence • Built for Rayls Hackathon
          </p>
        </div>
      </footer>
    </div>
  );
};
