const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// In-memory persistent data store
let mockOrders = [
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

const mockServices = [
  { id: 'dry-clean', name: 'Dry Clean', startingPrice: 99, turnaround: '48 hrs', tag: 'POPULAR' },
  { id: 'wash-fold', name: 'Wash & Fold', startingPrice: 69, turnaround: '24 hrs', tag: 'BEST VALUE' },
  { id: 'wash-iron', name: 'Wash & Iron', startingPrice: 35, turnaround: '36 hrs', tag: 'DAILY ESSENTIAL' },
  { id: 'shoe-cleaning', name: 'Shoe Cleaning', startingPrice: 199, turnaround: '72 hrs', tag: 'SPECIAL CARE' },
  { id: 'steam-iron', name: 'Steam Iron', startingPrice: 15, turnaround: '12 hrs', tag: 'FAST' },
  { id: 'home-linen', name: 'Home Linen', startingPrice: 149, turnaround: '48 hrs', tag: 'HEAVY CARE' },
];

const mockCoupons = [
  { code: 'FIRST50', title: 'Flat 50% OFF', discountType: 'percentage', discountValue: 50, maxDiscount: 150, minOrder: 199 },
  { code: 'CLEAN100', title: 'Flat ₹100 OFF', discountType: 'flat', discountValue: 100, maxDiscount: 100, minOrder: 499 },
  { code: 'WEEKEND20', title: '20% Weekend Special', discountType: 'percentage', discountValue: 20, maxDiscount: 120, minOrder: 349 },
];

// Health Check
app.get('/api/health', (req, res) => {
  res.json({
    status: 'OK',
    service: 'Tumbledays API Server (NestJS / Node.js)',
    city: 'Lucknow',
    version: '1.0.0',
    timestamp: new Date().toISOString(),
  });
});

// Auth Routes (Phone OTP & Google Auth)
app.post('/api/auth/send-otp', (req, res) => {
  const { phone } = req.body;
  if (!phone) return res.status(400).json({ error: 'Phone number is required' });
  res.json({ success: true, message: `OTP sent to +91 ${phone}`, mockOtp: '1234' });
});

app.post('/api/auth/verify-otp', (req, res) => {
  const { phone, otp } = req.body;
  if (otp === '1234' || (otp && otp.length === 4)) {
    return res.json({
      success: true,
      token: `jwt_mock_${Date.now()}`,
      user: {
        id: 'usr-101',
        name: 'Manish Verma',
        phone,
        city: 'Lucknow',
        walletBalance: 350.0,
      },
    });
  }
  res.status(401).json({ error: 'Invalid verification code' });
});

app.post('/api/auth/google-login', (req, res) => {
  res.json({
    success: true,
    token: `jwt_google_${Date.now()}`,
    user: {
      id: 'usr-google-101',
      name: 'Manish Verma',
      email: 'manish@tumbledays.com',
      city: 'Lucknow',
      walletBalance: 350.0,
    },
  });
});

// Services Routes
app.get('/api/services', (req, res) => {
  res.json({ success: true, count: mockServices.length, data: mockServices });
});

// Orders CRUD & Stepper Status Transitions
app.get('/api/orders', (req, res) => {
  const { status } = req.query;
  if (status && status !== 'ALL') {
    const filtered = mockOrders.filter(o => o.status === status);
    return res.json({ success: true, count: filtered.length, data: filtered });
  }
  res.json({ success: true, count: mockOrders.length, data: mockOrders });
});

app.get('/api/orders/:id', (req, res) => {
  const order = mockOrders.find(o => o.id === req.params.id);
  if (!order) return res.status(404).json({ error: 'Order not found' });
  res.json({ success: true, data: order });
});

app.post('/api/orders', (req, res) => {
  const newOrder = {
    id: `TMB-${Math.floor(10000 + Math.random() * 90000)}`,
    ...req.body,
    status: 'BOOKED',
    createdAt: new Date().toISOString(),
    partner: { name: 'Ramesh Kumar', phone: '+91 91234 56789', rating: 4.9 },
  };
  mockOrders.unshift(newOrder);
  res.status(201).json({ success: true, data: newOrder });
});

app.patch('/api/orders/:id/status', (req, res) => {
  const { status } = req.body;
  const order = mockOrders.find(o => o.id === req.params.id);
  if (!order) return res.status(404).json({ error: 'Order not found' });
  order.status = status;
  res.json({ success: true, message: `Status updated to ${status}`, data: order });
});

// Coupons & Discounts
app.get('/api/coupons', (req, res) => {
  res.json({ success: true, count: mockCoupons.length, data: mockCoupons });
});

app.post('/api/coupons/validate', (req, res) => {
  const { code, subtotal = 0 } = req.body;
  const coupon = mockCoupons.find(c => c.code.toUpperCase() === (code || '').toUpperCase());
  if (!coupon) return res.status(404).json({ error: 'Coupon code not found' });
  if (subtotal < coupon.minOrder) {
    return res.status(400).json({ error: `Minimum order value of ₹${coupon.minOrder} required` });
  }
  const discount = coupon.discountType === 'percentage'
    ? Math.min((subtotal * coupon.discountValue) / 100, coupon.maxDiscount)
    : Math.min(coupon.discountValue, subtotal);
  res.json({ success: true, code: coupon.code, discount, finalAmount: Math.max(0, subtotal - discount) });
});

// Addresses & Google Places Autocomplete proxy
app.get('/api/addresses/autocomplete', (req, res) => {
  const query = req.query.query || 'Gomti Nagar';
  res.json({
    success: true,
    predictions: [
      { description: `${query}, Vibhuti Khand, Gomti Nagar, Lucknow`, placeId: 'pl_101' },
      { description: `${query}, Indira Nagar, Lucknow`, placeId: 'pl_102' },
      { description: `${query}, Hazratganj, Lucknow`, placeId: 'pl_103' },
    ],
  });
});

// Razorpay Payments
app.post('/api/payments/razorpay/create-order', (req, res) => {
  const { amount = 500 } = req.body;
  res.json({
    success: true,
    razorpayOrderId: `order_rzp_${Date.now()}`,
    amount: Math.round(amount * 100),
    currency: 'INR',
    keyId: process.env.RAZORPAY_KEY_ID || 'rzp_test_tumbledays_lucknow',
  });
});

app.listen(PORT, () => {
  console.log(`🌿 Tumbledays API Server running on port ${PORT}`);
});
