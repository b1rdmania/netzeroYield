import React from 'react';

interface ESGIconProps {
  iconUrl: string;
  alt: string;
  size?: number;
  className?: string;
}

export const ESGIcon: React.FC<ESGIconProps> = ({ iconUrl, alt, size = 64, className = '' }) => {
  return (
    <img 
      src={iconUrl} 
      alt={alt} 
      width={size} 
      height={size} 
      className={className}
      style={{ 
        filter: 'brightness(0) invert(1) opacity(0.8)',
        transition: 'opacity 200ms ease'
      }}
      onMouseEnter={(e) => {
        e.currentTarget.style.opacity = '1';
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.opacity = '0.8';
      }}
    />
  );
};

export const ESGIconSet: React.FC = () => {
  const icons = [
    {
      url: 'https://img.icons8.com/?id=794&format=png&size=64',
      alt: 'Leaf - Environment',
      label: 'Net-Zero'
    },
    {
      url: 'https://img.icons8.com/?id=39764&format=png&size=64',
      alt: 'Sustainability',
      label: 'Sustainable'
    },
    {
      url: 'https://img.icons8.com/?id=awgUm55LKj7O&format=png&size=64',
      alt: 'Climate Change',
      label: 'Climate Action'
    },
    {
      url: 'https://img.icons8.com/?id=1769&format=png&size=64',
      alt: 'Solar Panel',
      label: 'Renewable Energy'
    }
  ];

  return (
    <div style={{ display: 'flex', gap: '32px', justifyContent: 'center', flexWrap: 'wrap', alignItems: 'center' }}>
      {icons.map((icon, index) => (
        <div key={index} style={{ 
          textAlign: 'center', 
          display: 'flex', 
          flexDirection: 'column', 
          alignItems: 'center', 
          gap: '8px',
          padding: '20px',
          background: 'rgba(15, 26, 19, 0.3)',
          borderRadius: '4px',
          border: '1px solid rgba(245, 158, 11, 0.1)',
          transition: 'all 200ms ease'
        }}
        onMouseEnter={(e) => {
          e.currentTarget.style.borderColor = 'rgba(245, 158, 11, 0.3)';
          e.currentTarget.style.background = 'rgba(15, 26, 19, 0.5)';
        }}
        onMouseLeave={(e) => {
          e.currentTarget.style.borderColor = 'rgba(245, 158, 11, 0.1)';
          e.currentTarget.style.background = 'rgba(15, 26, 19, 0.3)';
        }}
        >
          <ESGIcon iconUrl={icon.url} alt={icon.alt} size={48} />
          <span style={{ fontSize: '12px', color: 'rgba(255, 255, 255, 0.8)', fontWeight: 400, letterSpacing: '0.5px' }}>{icon.label}</span>
        </div>
      ))}
    </div>
  );
};

