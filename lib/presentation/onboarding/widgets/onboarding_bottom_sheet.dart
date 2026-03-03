import 'package:flutter/material.dart';

class OnboardingBottomSheet extends StatelessWidget {
  final String title;
  final String description;
  final double heightFactor;
  final EdgeInsets padding;

  const OnboardingBottomSheet({
    super.key,
    this.title = 'Description',
    this.description =
        'The IamJ will let your plan to be more specified, sophisticated, and finally achieve your goal',
    this.heightFactor = 0.25,
    this.padding = const EdgeInsets.all(32),
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: padding,
        height: MediaQuery.of(context).size.height * heightFactor,
        decoration: const BoxDecoration(
          color: Color(0xFF222222),
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.white70,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [],
            ),
          ],
        ),
      ),
    );
  }
}

