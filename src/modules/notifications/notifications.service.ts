import { Injectable } from '@nestjs/common';

@Injectable()
export class NotificationsService {
  async sendPushNotification(fcmToken: string, title: string, body: string, data?: Record<string, string>) {
    console.log(`[FCM PUSH] To: ${fcmToken || 'ALL_USERS'} | ${title}: ${body}`);
    // In production with Firebase Service Account:
    // admin.messaging().send({ token: fcmToken, notification: { title, body }, data });
    return {
      success: true,
      deliveredTo: fcmToken || 'mock_device_token',
      sentAt: new Date().toISOString(),
    };
  }

  async notifyOrderStatusChange(orderId: string, status: string) {
    return this.sendPushNotification(
      'device_token_user_101',
      `Order ${orderId} Update`,
      `Your laundry status is now: ${status}`,
      { orderId, status },
    );
  }
}
