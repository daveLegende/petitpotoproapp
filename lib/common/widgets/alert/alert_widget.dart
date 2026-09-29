import 'package:flutter/material.dart';
import 'package:petitpotopro/common/helpers/style.dart';

class AlerteContainer extends StatelessWidget {
  const AlerteContainer({
    super.key,
    required this.style,
    required this.text,
    required this.color,
  });

  final StyleText style;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_user_outlined, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: style.caption,
            ),
          ),
        ],
      ),
    );
  }
}