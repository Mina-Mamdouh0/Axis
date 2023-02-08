import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inverntry/constants.dart';

class CustomTextField extends StatelessWidget {
   CustomTextField({
    required this.hintText,
    required this.icon,
     required this.mixLines,
    required this.controller,
    this.obscureText = false,
    required this.keyboardType,
     this.inputFormatters,
     this.onChanged,
     this.readOnly,
     this.onTap,
    Key? key,
  }) : super(key: key);

  final String hintText;
  final IconData icon;
   final int mixLines;
  final TextEditingController controller;
  List<TextInputFormatter>? inputFormatters;
  bool? readOnly;
  final bool obscureText;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
      child: TextField(
        readOnly: readOnly??false,
        controller: controller,
        maxLines: mixLines,
        cursorColor: kDarkGreenColor,
        obscureText: obscureText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onTap: onTap,
        style: GoogleFonts.poppins(
          color: kDarkGreenColor,
          fontWeight: FontWeight.w600,
          fontSize: 15.0,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(18.0),
          filled: true,
          fillColor: kGinColor,
          prefixIcon: Icon(
            icon,
            size: 24.0,
            color: kDarkGreenColor,
          ),
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            color: kDarkGreenColor,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: kGinColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: kDarkGreenColor),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
