import 'dart:async';
import 'package:flutter/material.dart';

class AdsSliderWidget extends StatefulWidget {
  const AdsSliderWidget({super.key});

  @override
  State<AdsSliderWidget> createState() => _AdsSliderWidgetState();
}

class _AdsSliderWidgetState extends State<AdsSliderWidget> {
  final PageController _controller = PageController();
  final List<String> ads = [
    "assets/1.JPG",
    "assets/1.JPG",
    "assets/1.JPG",
  ];

  int index = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (index < ads.length - 1) {
        index++;
      } else {
        index = 0;
      }

      _controller.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: ads.length,
            onPageChanged: (i) => setState(() => index = i),
            itemBuilder: (_, i) => ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(ads[i], fit: BoxFit.cover),
            ),
          ),
          Positioned(
            bottom: 10,
            child: Row(
              children: List.generate(
                ads.length,
                    (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: index == i ? 20 : 10,
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == i ? Colors.black : Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
