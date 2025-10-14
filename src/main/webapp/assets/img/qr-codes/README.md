# QR Code Images Directory

This directory contains QR code images for bank transfer payments.

## Required Files

Place your QR code image in this directory with the following name:
- `payment-qr.png` - Main QR code for bank transfers

## QR Code Requirements

- **Format**: PNG or JPG
- **Size**: Recommended 300x300 pixels or larger
- **Content**: Should contain your bank account information for transfers
- **Quality**: High resolution for easy scanning

## How to Generate QR Code

1. Use any QR code generator (online or app)
2. Input your bank account details:
   - Bank name
   - Account number
   - Account holder name
   - Transfer amount (can be dynamic)
3. Save as `payment-qr.png` in this directory

## Example QR Code Content

```
Bank: Your Bank Name
Account: 1234-5678-9012
Holder: Yummy Restaurant
Amount: [Dynamic based on order]
Reference: Order #[OrderID]
```

## Security Note

Make sure your QR code only contains necessary information and doesn't expose sensitive banking details unnecessarily.

