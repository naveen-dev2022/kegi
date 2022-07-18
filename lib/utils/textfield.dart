import 'package:flutter/material.dart';
import 'package:kegi_sudo/utils/responsive_ui.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final IconData? icon;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final String? errorText;
  final String? label;
  double? _width;
  double? _pixelRatio;
  bool? large;
  bool? medium;

  CustomTextField(
      {this.hint,
      this.textEditingController,
      this.keyboardType,
      this.icon,
      this.obscureText = false,
      this.onChanged,
      this.focusNode,
      this.errorText,
      this.label});

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width!, _pixelRatio!);
    medium = ResponsiveWidget.isScreenMedium(_width!, _pixelRatio!);
    return Material(
      // borderRadius: BorderRadius.circular(30.0),
      // elevation: large! ? 6 : (medium! ? 4 : 2),
      child: TextFormField(
        obscureText: obscureText!,
        onChanged: onChanged,
        controller: textEditingController,
        keyboardType: keyboardType,
        cursorColor: Color(0xffb09bfa),
        focusNode: focusNode,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffb09bfa)),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          prefixIcon: Icon(icon, color: Color(0xff676767), size: 21),
          hintText: hint,
          hintStyle: TextStyle(fontSize: 13, color: Colors.black54),
          labelText: label,
          errorText: errorText,
        ),
      ),
    );
  }
}
