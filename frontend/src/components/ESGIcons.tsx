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
        filter: 'drop-shadow(0 4px 8px rgba(245, 158, 11, 0.4)) brightness(1.1)',
        transition: 'transform 300ms ease'
      }}
      onMouseEnter={(e) => {
        e.currentTarget.style.transform = 'scale(1.1)';
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.transform = 'scale(1)';
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
    <div style={{ display: 'flex', gap: '24px', justifyContent: 'center', flexWrap: 'wrap', alignItems: 'center' }}>
      {icons.map((icon, index) => (
        <div key={index} style={{ 
          textAlign: 'center', 
          display: 'flex', 
          flexDirection: 'column', 
          alignItems: 'center', 
          gap: '8px',
          padding: '16px',
          background: 'rgba(15, 26, 19, 0.4)',
          borderRadius: '12px',
          border: '1px solid rgba(245, 158, 11, 0.2)',
          backdropFilter: 'blur(10px)',
          transition: 'all 300ms ease'
        }}
        onMouseEnter={(e) => {
          e.currentTarget.style.transform = 'translateY(-4px)';
          e.currentTarget.style.borderColor = 'rgba(245, 158, 11, 0.4)';
          e.currentTarget.style.boxShadow = '0 8px 20px rgba(245, 158, 11, 0.2)';
        }}
        onMouseLeave={(e) => {
          e.currentTarget.style.transform = 'translateY(0)';
          e.currentTarget.style.borderColor = 'rgba(245, 158, 11, 0.2)';
          e.currentTarget.style.boxShadow = 'none';
        }}
        >
          <ESGIcon iconUrl={icon.url} alt={icon.alt} size={64} />
          <span style={{ fontSize: '0.875rem', color: '#f59e0b', fontWeight: 600 }}>{icon.label}</span>
        </div>
      ))}
    </div>
  );
};

