import { Injectable, UnauthorizedException } from '@nestjs/common';

@Injectable()
export class AuthService {
  async sendOtp(phone: string) {
    // Simulates OTP sending via SMS gateway or Firebase Auth
    return {
      success: true,
      message: `OTP sent to +91 ${phone}`,
      mockOtp: '1234',
    };
  }

  async verifyOtp(phone: string, otp: string) {
    if (otp === '1234' || otp.length === 4) {
      return {
        success: true,
        token: `jwt_tumbledays_${Date.now()}`,
        user: {
          id: 'usr-101',
          name: 'Manish Verma',
          phone,
          city: 'Lucknow',
          walletBalance: 350.0,
        },
      };
    }
    throw new UnauthorizedException('Invalid OTP verification code');
  }

  async verifyGoogleToken(idToken: string) {
    // Decodes Firebase Google idToken or provides fallback
    return {
      success: true,
      token: `jwt_google_${Date.now()}`,
      user: {
        id: 'usr-google-101',
        name: 'Google User',
        email: 'user@gmail.com',
        city: 'Lucknow',
        walletBalance: 350.0,
      },
    };
  }
}
