import 'package:flutter/material.dart';
import 'package:petitpotopro/common/helpers/constant.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';

class Dots extends StatelessWidget {
  final int count;
  final int index;

  const Dots({super.key, required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: const EdgeInsets.only(right: 6),
          width: active ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? AppColors.secondary : mwhite,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}