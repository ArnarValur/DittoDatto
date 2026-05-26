/**
 * Mock Data for Restaurant Preview
 * Simulating "Fröken Reykjavík"
 */

export const mockRestaurant = {
  name: 'Fröken Reykjavík',
  logo: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&q=80&w=200&h=200',
  address: 'Lækjargata 12',
  city: 'Reykjavík, Iceland',
  rating: 4.8,
  reviewCount: 90,
  hoursDisplay: 'Open until 22:00',

  description: `Fröken Reykjavík is a casual smart restaurant in stylish Art Deco-inspired surroundings that seamlessly blends elegance with a warm and inviting atmosphere. Featuring a bar and a private area for groups or small events.
  
  The menu showcases modern Northern European cuisine, with a strong emphasis on locally sourced ingredients, ensuring fresh, high-quality flavors in every dish. Whether you're stopping by for a crafted cocktail or want to enjoy an indulgent meal and our excellent selection of wine from the wine room, Fröken Reykjavík looks forward to welcoming you.`,

  mapImage: 'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=80&w=1000&h=600',

  images: [
    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&q=80&w=1200', // Main
    'https://images.unsplash.com/photo-1559339352-11d035aa65de?auto=format&fit=crop&q=80&w=600', // Side 1
    'https://images.unsplash.com/photo-1550966871-3ed3c47e2ce2?auto=format&fit=crop&q=80&w=600', // Side 2
    'https://images.unsplash.com/photo-1552566626-52f8b828add9?auto=format&fit=crop&q=80&w=600', // Side 3
    'https://images.unsplash.com/photo-1544148103-0773bf10d330?auto=format&fit=crop&q=80&w=600', // Side 4
    'https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?auto=format&fit=crop&q=80&w=600' // Extra
  ],

  experiences: [
    {
      id: 'dinner',
      title: 'Dinner',
      timeRange: 'From 17:30 - 22:00',
      image: 'https://images.unsplash.com/photo-1559339352-11d035aa65de?auto=format&fit=crop&q=80&w=800',
      description: 'Experience our full evening a la carte menu featuring seasonal local ingredients.'
    },
    {
      id: 'lunch',
      title: 'Lunch',
      timeRange: 'From 12:00 - 17:30',
      image: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?auto=format&fit=crop&q=80&w=800',
      description: 'Light and fresh options perfect for a midday break.'
    },
    {
      id: 'holiday',
      title: 'Holiday Feast',
      timeRange: 'Nov 14 - Dec 30',
      priceDisplay: '15.900 kr per guest',
      image: 'https://images.unsplash.com/photo-1544148103-0773bf10d330?auto=format&fit=crop&q=80&w=800',
      description: '5-course festive menu celebrating the holiday season with traditional flavors.'
    },
    {
      id: 'nye',
      title: 'New Year\'s Eve',
      priceDisplay: '35.900 kr per guest',
      timeRange: 'Dec 31',
      image: 'https://images.unsplash.com/photo-1467810563316-b5476525c0f9?auto=format&fit=crop&q=80&w=800',
      description: 'Ring in the new year with an exclusive 7-course gala dinner and champagne.'
    }
  ]
}
