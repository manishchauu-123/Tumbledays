import { Injectable } from '@nestjs/common';

@Injectable()
export class ServicesService {
  private services = [
    {
      id: 'dry-clean',
      name: 'Dry Clean',
      startingPrice: 99,
      unit: 'pc',
      turnaround: '48 hrs',
      description: 'Premium eco-wash & soft care with Italian stain removal',
      tag: 'POPULAR',
    },
    {
      id: 'wash-fold',
      name: 'Wash & Fold',
      startingPrice: 69,
      unit: 'kg',
      turnaround: '24 hrs',
      description: 'Everyday wear sorted by kg, washed in eco detergents',
      tag: 'BEST VALUE',
    },
    {
      id: 'wash-iron',
      name: 'Wash & Iron',
      startingPrice: 35,
      unit: 'pc',
      turnaround: '36 hrs',
      description: 'Clean wash + crisp steam finish ready for hangers',
      tag: 'DAILY ESSENTIAL',
    },
    {
      id: 'shoe-cleaning',
      name: 'Shoe Cleaning',
      startingPrice: 199,
      unit: 'pair',
      turnaround: '72 hrs',
      description: 'Deep scrub, sanitization & deodorize for sneakers & leathers',
      tag: 'SPECIAL CARE',
    },
    {
      id: 'steam-iron',
      name: 'Steam Iron',
      startingPrice: 15,
      unit: 'pc',
      turnaround: '12 hrs',
      description: 'Crease-free gentle steam touch without fabric burn',
      tag: 'FAST',
    },
    {
      id: 'home-linen',
      name: 'Home Linen',
      startingPrice: 149,
      unit: 'pc',
      turnaround: '48 hrs',
      description: 'Curtains, bedsheets, blankets & sofa covers',
      tag: 'HEAVY CARE',
    },
  ];

  async findAll() {
    return { success: true, count: this.services.length, data: this.services };
  }

  async findCatalog(serviceId: string) {
    return {
      success: true,
      serviceId,
      items: [
        { id: '1', name: 'Cotton Shirt / Kurta', category: 'Men', price: 99, unit: 'pc' },
        { id: '2', name: 'Formal Trousers', category: 'Men', price: 119, unit: 'pc' },
        { id: '3', name: 'Blazer / Coat (2-pc)', category: 'Men', price: 349, unit: 'pc' },
        { id: '4', name: 'Silk Saree / Heavy Suit', category: 'Women', price: 279, unit: 'pc' },
      ],
    };
  }
}
