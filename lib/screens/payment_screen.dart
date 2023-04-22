// import 'package:flutter/material.dart';
// import 'package:flutter_paystack/flutter_paystack.dart';
//
// class PaymentGatewayApp extends StatefulWidget {
//   @override
//   _PaymentGatewayAppState createState() => _PaymentGatewayAppState();
// }
//
// class _PaymentGatewayAppState extends State<PaymentGatewayApp> {
//   String paymentStatus = '';
//
//   void _initializePaystack() {
//     PaystackPlugin.initialize(
//       publicKey: 'YOUR_PUBLIC_KEY', // Replace with your Paystack public key
//     );
//   }
//
//   void _startPayment() async {
//     Charge charge = Charge()
//       ..amount = 10000 // Amount in kobo (e.g. 10000 kobo is ₦100)
//       ..email = 'test@example.com' // Customer email
//       ..reference = 'payment-${DateTime.now().millisecondsSinceEpoch}'; // Unique payment reference
//
//     CheckoutResponse response = await PaystackPlugin.checkout(
//       context,
//       charge: charge,
//     );
//
//     if (response.status == true && response.reference != null) {
//       setState(() {
//         paymentStatus = 'Payment successful. Reference: ${response.reference}';
//       });
//     } else {
//       setState(() {
//         paymentStatus = 'Payment failed. ${response.message}';
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _initializePaystack();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Payment Gateway Example')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _startPayment,
//               child: Text('Make Payment'),
//             ),
//             SizedBox(height: 16),
//             Text(paymentStatus),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
