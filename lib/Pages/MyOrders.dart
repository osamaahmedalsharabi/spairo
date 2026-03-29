import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    // Example dynamic orders with history for each step
    final List<Map<String, dynamic>> orders = [
      {
        'orderNumber': '12345',
        'orderMonth': 'يوليو',
        'orderTime': 'تم الطلب في 10 صباحاً',
        'productCount': 1,
        'price': 50,
        'currentStep': 2,
        'stepHistory': [
          '10:05 تم قبول الطلب',
          '10:20 بدأ التوصيل',
          '11:00 في الطريق',
          '', // not reached yet
        ],
      },
      {
        'orderNumber': '12346',
        'orderMonth': 'أغسطس',
        'orderTime': 'تم الطلب في 11 صباحاً',
        'productCount': 2,
        'price': 120,
        'currentStep': 1,
        'stepHistory': [
          '11:10 تم قبول الطلب',
          '11:30 بدأ التوصيل',
          '',
          '',
        ],
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: Text(""),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/home");
              },
              icon: Icon(Icons.arrow_forward))
        ],
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'الطلبات (${orders.length})',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return OrderCardWidget(
              orderNumber: order['orderNumber'],
              orderMonth: order['orderMonth'],
              orderStatusText: order['orderTime'],
              productCount: order['productCount'],
              price: order['price'],
              currentStep: order['currentStep'],
              stepHistory: List<String>.from(order['stepHistory']),
            );
          },
        ),
      ),
    );
  }
}

class OrderCardWidget extends StatefulWidget {
  final String orderNumber;
  final String orderMonth;
  final String orderStatusText;
  final int productCount;
  final int price;
  final int currentStep;
  final List<String> stepHistory;

  const OrderCardWidget({
    super.key,
    required this.orderNumber,
    required this.orderMonth,
    required this.orderStatusText,
    required this.productCount,
    required this.price,
    required this.currentStep,
    required this.stepHistory,
  });

  @override
  State<OrderCardWidget> createState() => _OrderCardWidgetState();
}

class _OrderCardWidgetState extends State<OrderCardWidget> {
  bool _isExpanded = false;

  final List<String> steps = [
    'تم قبول الطلب',
    'بدأ التوصيل',
    'في الطريق',
    'تم الوصول',
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: AppColors.background,
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (expanded) {
          setState(() => _isExpanded = expanded);
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'رقم الطلب: ${widget.orderNumber}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'تم الطلب في ${widget.orderMonth}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 2),
            Text(
              'عدد المنتجات: ${widget.productCount} | السعر: ${widget.price} ريال',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: List.generate(steps.length, (index) {
                bool done = index <= widget.currentStep;
                String history = widget.stepHistory[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: done ? Colors.orange : Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: done
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        if (index != steps.length - 1)
                          Container(
                            width: 2,
                            height: 50,
                            color: Colors.grey[300],
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            steps[index],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  done ? FontWeight.bold : FontWeight.normal,
                              color: done ? Colors.orange : Colors.grey[700],
                            ),
                          ),
                          if (done && history.isNotEmpty)
                            Text(
                              history,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
