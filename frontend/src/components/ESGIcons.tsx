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
      style={{ filter: 'drop-shadow(0 2px 4px rgba(34, 197, 94, 0.2))' }}
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
        <div key={index} style={{ textAlign: 'center', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '8px' }}>
          <ESGIcon iconUrl={icon.url} alt={icon.alt} size={48} />
          <span style={{ fontSize: '0.875rem', color: '#059669', fontWeight: 500 }}>{icon.label}</span>
        </div>
      ))}
    </div>
  );
};

