import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

TextField inputTextField(
    {required String labelText,
    required TextStyle textFieldStyle,
    required TextStyle hintStyleStyle,
    required TextEditingController controller,
    required color,
    obscureText,
    focusNode,
    hasError}) {
  return TextField(
    style: textFieldStyle.copyWith(
      color: hasError ? Colors.redAccent : textFieldStyle.color,
      fontWeight: FontWeight.bold,
    ),
    controller: controller,
    focusNode: focusNode,
    obscureText: obscureText ?? false,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.all(20),
      filled: true,
      fillColor: color,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelText: labelText,
      focusedBorder: const OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      floatingLabelStyle: textFieldStyle.copyWith(
        color: hasError ? Colors.redAccent : textFieldStyle.color,
        height: 5,
        fontWeight: FontWeight.bold,
      ),
      hintStyle: textFieldStyle.copyWith(
        color: hasError ? Colors.redAccent : textFieldStyle.color,
      ),
    ),
  );
}

TextField inputSearchTextField({
  required String labelText,
  required TextStyle textFieldStyle,
  required TextStyle hintStyleStyle,
  required TextEditingController controller,
  required color,
  onSubmited,
  focusNode,
}) {
  return TextField(
    style: textFieldStyle.copyWith(
      color: textFieldStyle.color,
      fontWeight: FontWeight.bold,
    ),
    controller: controller,
    focusNode: focusNode,
    onSubmitted: (v) => onSubmited(),
    textInputAction: TextInputAction.search,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.all(20),
      filled: true,
      fillColor: color,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      labelText: labelText,
      focusedBorder: const OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      hintStyle: textFieldStyle.copyWith(
        color: textFieldStyle.color,
      ),
      prefixIcon: const Icon(
        AntDesign.search1,
        color: kDark,
      ),
    ),
  );
}

TextField inputNumberTextField({
  required String labelText,
  required TextStyle textFieldStyle,
  required TextStyle hintStyleStyle,
  required TextEditingController controller,
  required color,
  focusNode,
  hasError,
}) {
  return TextField(
    style: textFieldStyle.copyWith(
      color: hasError ? Colors.redAccent : textFieldStyle.color,
      fontWeight: FontWeight.bold,
    ),
    controller: controller,
    focusNode: focusNode,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.all(20),
      filled: true,
      fillColor: color,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelText: labelText,
      focusedBorder: const OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      floatingLabelStyle: textFieldStyle.copyWith(
        color: hasError ? Colors.redAccent : textFieldStyle.color,
        height: 5,
        fontWeight: FontWeight.bold,
      ),
      hintStyle: textFieldStyle.copyWith(
        color: hasError ? Colors.redAccent : textFieldStyle.color,
      ),
    ),
  );
}

TextField inputTextArea({
  required String labelText,
  required TextStyle textFieldStyle,
  required TextStyle hintStyleStyle,
  required TextEditingController controller,
  required color,
  focusNode,
  hasError,
}) {
  return TextField(
    style: textFieldStyle.copyWith(
      color: hasError ? Colors.redAccent : textFieldStyle.color,
      fontWeight: FontWeight.bold,
    ),
    controller: controller,
    focusNode: focusNode,
    maxLines: 3,
    keyboardType: TextInputType.multiline,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.all(20),
      filled: true,
      fillColor: color,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      alignLabelWithHint: true,
      labelText: labelText,
      focusedBorder: const OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      floatingLabelStyle: textFieldStyle.copyWith(
        color: hasError ? Colors.redAccent : textFieldStyle.color,
        height: 5,
        fontWeight: FontWeight.bold,
      ),
      hintStyle: textFieldStyle.copyWith(
        color: hasError ? Colors.redAccent : textFieldStyle.color,
      ),
    ),
  );
}
