import { Controller, Get, Post, Body } from '@nestjs/common';
import { CouponsService } from './coupons.service';

@Controller('api/coupons')
export class CouponsController {
  constructor(private readonly couponsService: CouponsService) {}

  @Get()
  async getActiveCoupons() {
    return this.couponsService.findAll();
  }

  @Post('validate')
  async validateCoupon(@Body('code') code: string, @Body('subtotal') subtotal: number) {
    return this.couponsService.validate(code, subtotal);
  }
}
