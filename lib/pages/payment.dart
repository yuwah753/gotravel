import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gotravel/controllers/user_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentPage extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, dynamic> destination;

  PaymentPage(
      {required this.startDate,
      required this.endDate,
      required this.destination});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _selectedPaymentMethod;
  final _firestore = FirebaseFirestore.instance;
  final UserController userController = Get.find();
  String? _qrCodeData;

  Future<void> _confirmPayment() async {
    try {
      await _firestore.collection('bookings').add({
        'user_id': userController.userId.value,
        'destination': widget.destination,
        'startDate': widget.startDate,
        'endDate': widget.endDate,
        'paymentMethod': _selectedPaymentMethod,
        'qrCodeData': _qrCodeData,
      });

      await _firestore
          .collection('users')
          .doc(userController.userId.value)
          .update({
        'travel_trips': FieldValue.increment(1),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment successful!')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error storing data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing payment')),
      );
    }
  }

  void _generateQRCode() {
    final bookingData = {
      'user_id': userController.userId.value,
      'destination': widget.destination,
      'startDate': widget.startDate,
      'endDate': widget.endDate,
      'paymentMethod': _selectedPaymentMethod,
    };
    _qrCodeData = bookingData.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Payment Method',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  child: Text('Credit Card'),
                  value: 'Credit Card',
                ),
                DropdownMenuItem(
                  child: Text('QRIS'),
                  value: 'QRIS',
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                  if (value == 'QRIS') {
                    _generateQRCode();
                  } else {
                    _qrCodeData = null;
                  }
                });
              },
            ),
            SizedBox(height: 20),
            if (_selectedPaymentMethod == 'Credit Card') ...[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Expiration Date',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Card Holder Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            if (_selectedPaymentMethod == 'QRIS' && _qrCodeData != null) ...[
              SizedBox(height: 20),
              Center(
                child: QrImageView(
                  data: _qrCodeData!,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              SizedBox(height: 20),
            ],
            Spacer(),
            ElevatedButton(
              onPressed:
                  _selectedPaymentMethod != null ? _confirmPayment : null,
              child: Text(
                'Confirm Payment',
                style: TextStyle(fontFamily: 'ABeeZee'),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightBlue[300],
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
