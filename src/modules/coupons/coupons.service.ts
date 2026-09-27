import { Injectable, BadRequestException } from '@nestjs/common';

@Injectable()
export class CouponsService {
  private coupons = [
    {
      code: 'FIRST50',
      title: 'Flat 50% OFF',
      description: 'Up to ₹150 on your first laundry pickup in Lucknow',
      discountType: 'percentage',
      discountValue: 50,
      maxDiscount: 150,
      minOrder: 199,
      isActive: true,
    },
    {
      code: 'CLEAN100',
      title: 'Flat ₹100 OFF',
      description: 'On dry cleaning orders above ₹499',
      discountType: 'flat',
      discountValue: 100,
      maxDiscount: 100,
      minOrder: 499,
      isActive: true,
    },
    {
      code: 'WEEKEND20',
      title: '20% Weekend Special',
      description: 'Valid Friday to Sunday on all services',
      discountType: 'percentage',
      discountValue: 20,
      maxDiscount: 120,
      minOrder: 349,
      isActive: true,
    },
  ];

  async findAll() {
    return { success: true, count: this.coupons.length, data: this.coupons };
  }

  async validate(code: string, subtotal: number) {
    const coupon = this.coupons.find(c => c.code.toUpperCase() === (code || '').toUpperCase());
    if (!coupon) throw new BadRequestException('Coupon code not found');

    if (subtotal < coupon.minOrder) {
      throw new BadRequestException(`Minimum order value of ₹${coupon.minOrder} required for ${coupon.code}`);
    }

    let discount = 0;
    if (coupon.discountType === 'percentage') {
      discount = Math.min((subtotal * coupon.discountValue) / 100, coupon.maxDiscount);
    } else {
      discount = Math.min(coupon.discountValue, subtotal);
    }

    return {
      success: true,
      code: coupon.code,
      discount,
      finalAmount: Math.max(0, subtotal - discount),
    };
  }
}
