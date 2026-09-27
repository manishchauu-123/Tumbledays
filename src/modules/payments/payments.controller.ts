import { Controller, Post, Body } from '@nestjs/common';
import { PaymentsService } from './payments.service';

@Controller('api/payments')
export class PaymentsController {
  constructor(private readonly paymentsService: PaymentsService) {}

  @Post('razorpay/create-order')
  async createRazorpayOrder(@Body('amount') amount: number, @Body('orderId') orderId: string) {
    return this.paymentsService.createOrder(amount, orderId);
  }

  @Post('razorpay/verify')
  async verifyPayment(@Body() body: any) {
    return this.paymentsService.verifyPayment(body);
  }
}
