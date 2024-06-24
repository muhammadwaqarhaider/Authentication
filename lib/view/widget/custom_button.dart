import 'package:firebase/model/utils/styles.dart';
import 'package:flutter/material.dart';

import '../../model/utils/colors.dart';
import '../../model/utils/images.dart';

class CustomButton extends StatelessWidget {
  String text;
  void Function()? onTap;
  CustomButton({Key? key,required this.text,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image:   DecorationImage(
                alignment: Alignment.centerRight,
                image: AssetImage(
                  Images.buttonBackground,
                )
            ),
            color: textBlack,
            // gradient:  LinearGradient(
            //   begin: Alignment.centerLeft,
            //   end: Alignment.centerRight,
            //   colors: [
            //     btnLeft,
            //     btnRight.withOpacity(0.8),
            //   ],),
            boxShadow:  [
              BoxShadow(
                  color: const Color(0XFF7303E3).withOpacity(0.015),
                  blurRadius: 2,
                  spreadRadius: 5,
                  offset: const Offset(0,24)
              ),
            ]
        ),
        child: Center(child: Text(text,style: interMedium.copyWith(color: btnColor),)),
      ),
    );
  }
}
