import 'package:flutter/material.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({super.key});

  @overr
  Widget build(BuildContext context) {
    return Column(
      children: [

        Row(
          children: [

            const SizedBox(width: 25),

            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
                size: 32,
              ),
            ),

            const Expanded(
              child: Text(
                "National Institute of technology - NIT Silchar",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
                size: 32,
              ),
            ),

            const SizedBox(width: 15),
          ],
        ),

        const SizedBox(height: 5),

        const Text(
          "01 September 2026",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}