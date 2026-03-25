import 'package:flutter/material.dart';

class ContentAppBar extends StatelessWidget {
  const ContentAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_horiz, color: Colors.white),
          onPressed: () {},
        )
      ],
    );
  }
}
