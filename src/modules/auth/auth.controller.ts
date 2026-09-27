import { Controller, Post, Body, BadRequestException } from '@nestjs/common';
import { AuthService } from './auth.service';

@Controller('api/auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('send-otp')
  async sendOtp(@Body('phone') phone: string) {
    if (!phone) throw new BadRequestException('Phone number is required');
    return this.authService.sendOtp(phone);
  }

  @Post('verify-otp')
  async verifyOtp(@Body('phone') phone: string, @Body('otp') otp: string) {
    if (!phone || !otp) throw new BadRequestException('Phone and OTP are required');
    return this.authService.verifyOtp(phone, otp);
  }

  @Post('google-login')
  async googleLogin(@Body('idToken') idToken: string) {
    return this.authService.verifyGoogleToken(idToken);
  }
}
