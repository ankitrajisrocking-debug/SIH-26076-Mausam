import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),

      child: Row(
        children: [

          Expanded(
            child: _ActionButton(
              icon: Icons.agriculture,
              text: "Agromet",
            ),
          ),

          const SizedBox(width: 30),

          Expanded(
            child: _ActionButton(
              icon: Icons.analytics_outlined,
              text: "Crowd Source",
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {

  final IconData icon;
  final String text;

  const _ActionButton({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 75,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(
            icon,
            size: 30,
          ),

          const SizedBox(width: 10),

          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}