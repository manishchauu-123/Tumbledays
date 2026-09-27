import { Module } from '@nestjs/common';
import { AuthModule } from './modules/auth/auth.module';
import { OrdersModule } from './modules/orders/orders.module';
import { ServicesModule } from './modules/services/services.module';
import { AddressesModule } from './modules/addresses/addresses.module';
import { CouponsModule } from './modules/coupons/coupons.module';
import { PaymentsModule } from './modules/payments/payments.module';
import { NotificationsModule } from './modules/notifications/notifications.module';

@Module({
  imports: [
    AuthModule,
    OrdersModule,
    ServicesModule,
    AddressesModule,
    CouponsModule,
    PaymentsModule,
    NotificationsModule,
  ],
})
export class AppModule {}
