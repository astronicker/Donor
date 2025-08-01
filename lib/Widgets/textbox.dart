import 'package:donor/Theme/color_extension.dart';
import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final TextEditingController controller;
  final double? width;
  final Color? boxColor;
  final int? maxLenght;
  final BorderRadius borderRadius;
  final String? hintText;
  final TextInputType? inputType;
  final bool readOnly;

  const TextBox({
    super.key,
    required this.controller,
    this.width,
    this.boxColor,
    this.maxLenght,
    required this.borderRadius,
    this.hintText,
    this.inputType,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(
          width: width ?? screenWidth,
          child: TextFormField(
            style: TextStyle(fontSize: 18),
            readOnly: readOnly,
            maxLength: maxLenght,
            buildCounter:
                (
                  BuildContext context, {
                  required int currentLength,
                  required bool isFocused,
                  required int? maxLength,
                }) {
                  return null;
                },
            controller: controller,
            keyboardType: inputType,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                top: 15,
                bottom: 15,
                left: 25,
                right: 10,
              ),
              hintText: hintText,
              hintStyle: TextStyle(
                color: context.colorScheme.secondary.withOpacity(.75),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(
                  width: 2,
                  color: boxColor ?? context.colorScheme.primaryContainer,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(
                  width: 2,
                  color: boxColor ?? context.colorScheme.primaryContainer,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
