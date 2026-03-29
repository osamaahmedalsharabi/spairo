import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import '../../../data/models/part_order_model.dart';
import 'order_tracking_header.dart';
import 'order_tracking_timeline.dart';

class OrderTrackingView extends StatelessWidget {
  final PartOrderModel order;
  const OrderTrackingView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        title: const Text('تتبع الطلب',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios,
              color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            OrderTrackingHeader(order: order),
            const SizedBox(height: 24),
            OrderTrackingTimeline(order: order),
          ],
        ),
      ),
    );
  }
}
