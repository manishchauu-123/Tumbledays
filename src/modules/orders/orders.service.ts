import { Injectable, NotFoundException } from '@nestjs/common';

@Injectable()
export class OrdersService {
  private orders = [
    {
      id: 'TMB-89241',
      status: 'IN_PROCESS',
      service: 'Dry Clean & Steam Iron',
      totalAmount: 946,
      pickupDate: 'Tomorrow, 17 Sep',
      pickupSlot: '08:00 AM - 11:00 AM',
      deliveryDate: 'Thu, 18 Sep 06:00 PM',
      address: 'Flat 402, Green Valley Apartments, Gomti Nagar, Lucknow',
      partner: { name: 'Ramesh Kumar', phone: '+91 91234 56789', rating: 4.9 },
      items: [
        { name: 'Cotton Kurta', qty: 2, price: 99 },
        { name: 'Blazer (2-pc)', qty: 1, price: 349 },
        { name: 'Formal Trousers', qty: 1, price: 119 },
      ],
      createdAt: new Date().toISOString(),
    },
    {
      id: 'TMB-74120',
      status: 'DELIVERED',
      service: 'Wash & Fold',
      totalAmount: 364,
      pickupDate: '12 Sep 2026',
      pickupSlot: '11:00 AM - 02:00 PM',
      deliveryDate: '14 Sep 2026',
      address: 'Flat 402, Green Valley Apartments, Gomti Nagar, Lucknow',
      partner: { name: 'Deepak Sharma', phone: '+91 98765 12345', rating: 4.8 },
      items: [
        { name: 'Everyday Laundry (6 kg)', qty: 6, price: 69 },
      ],
      createdAt: new Date(Date.now() - 86400000 * 4).toISOString(),
    },
  ];

  async findAll(status?: string) {
    if (status && status !== 'ALL') {
      const filtered = this.orders.filter(o => o.status === status);
      return { success: true, count: filtered.length, data: filtered };
    }
    return { success: true, count: this.orders.length, data: this.orders };
  }

  async findOne(id: string) {
    const order = this.orders.find(o => o.id === id);
    if (!order) throw new NotFoundException(`Order ${id} not found`);
    return { success: true, data: order };
  }

  async create(createOrderDto: any) {
    const newOrder = {
      id: `TMB-${Math.floor(10000 + Math.random() * 90000)}`,
      status: 'BOOKED',
      ...createOrderDto,
      createdAt: new Date().toISOString(),
      partner: {
        name: 'Ramesh Kumar',
        phone: '+91 91234 56789',
        rating: 4.9,
      },
    };
    this.orders.unshift(newOrder);
    return { success: true, data: newOrder };
  }

  async updateStatus(id: string, status: string) {
    const order = this.orders.find(o => o.id === id);
    if (!order) throw new NotFoundException(`Order ${id} not found`);
    order.status = status;
    return {
      success: true,
      message: `Order ${id} status updated to ${status}`,
      data: order,
    };
  }

  async reorder(id: string) {
    const previous = this.orders.find(o => o.id === id);
    if (!previous) throw new NotFoundException(`Order ${id} not found`);
    return this.create({
      ...previous,
      pickupDate: 'Tomorrow, 17 Sep',
      pickupSlot: '08:00 AM - 11:00 AM',
    });
  }
}
