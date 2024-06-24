import 'package:firebase/model/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../model/utils/colors.dart';


class CustomTextField extends StatelessWidget {
  TextEditingController? textEditingController;
  TextInputType textInputType;
  String hint;
  bool isSecure;
  String? preFix;
  void Function(String)? onChanged;
  String? Function(String?)? validator;
  CustomTextField({Key? key,this.textEditingController,required this.hint,
    this.preFix,this.textInputType=TextInputType.text,this.isSecure=false,
    this.onChanged,this.validator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow:  [
            BoxShadow(
                color: Colors.black.withOpacity(0.008),
                blurRadius: 2,
                spreadRadius: 5,
                offset: const Offset(0,18.3)
            ),
          ]
      ),
      child: TextFormField(
        controller: textEditingController,
        style: interRegular,
        keyboardType: textInputType,
        cursorColor: Theme.of(context).primaryColor,
        autofocus: false,
        obscureText: isSecure,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          focusColor: const Color(0XF7F7F7),
          hoverColor: const Color(0XF7F7F7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(style: BorderStyle.none, width: 0),
          ),
          isDense: true,
          hintText: hint,
          fillColor: fieldColor,
          hintStyle: interLight,
          filled: true,
          prefixIcon: preFix!=null?Padding(
            padding: const EdgeInsets.all(8),
            child: SvgPicture.asset(preFix!, height: 5, width: 5),
          ):null,
        ),
      ),
    );
  }
}
