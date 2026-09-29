import 'package:flutter/material.dart';
import 'package:petitpotopro/common/helpers/style.dart';

class TitleDescWidget extends StatelessWidget {
  const TitleDescWidget({
    super.key,
    this.space = 30,
    required this.style,
    required this.title,
    required this.desc,
  });

  final StyleText style;
  final String title, desc;
  final double? space;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: style.title,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          desc,
          style: style.desc,
          maxLines: 2,
          textAlign: TextAlign.start,
        ),
        SizedBox(
          height: space,
        ),
      ],
    );
  }
}