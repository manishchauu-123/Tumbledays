import { Controller, Get, Post, Patch, Param, Body, Query } from '@nestjs/common';
import { OrdersService } from './orders.service';

@Controller('api/orders')
export class OrdersController {
  constructor(private readonly ordersService: OrdersService) {}

  @Get()
  async getAllOrders(@Query('status') status?: string) {
    return this.ordersService.findAll(status);
  }

  @Get(':id')
  async getOrderById(@Param('id') id: string) {
    return this.ordersService.findOne(id);
  }

  @Post()
  async createOrder(@Body() createOrderDto: any) {
    return this.ordersService.create(createOrderDto);
  }

  @Patch(':id/status')
  async updateStatus(@Param('id') id: string, @Body('status') status: string) {
    return this.ordersService.updateStatus(id, status);
  }

  @Post(':id/reorder')
  async reorder(@Param('id') id: string) {
    return this.ordersService.reorder(id);
  }
}
