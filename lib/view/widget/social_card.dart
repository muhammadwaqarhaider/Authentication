import 'package:firebase/model/utils/colors.dart';
import 'package:firebase/model/utils/dimensions.dart';
import 'package:firebase/model/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialCard extends StatelessWidget {
  String icon;
  String name;
  void Function()? onTap;
  SocialCard({Key? key,required this.icon,required this.name,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: textWhite,
            borderRadius: BorderRadius.circular(10),
            boxShadow:  [
              BoxShadow(
                  color: Colors.black.withOpacity(0.016),
                  blurRadius: 2,
                  spreadRadius: 5,
                  offset: const Offset(0,4)
              ),
            ]
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(icon, height: 28, width: 28),
              ),
              RichText(
                text: TextSpan(
                  style: interLight.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.black,height: 1),
                  children: <TextSpan>[
                    const TextSpan(text: "sign in \nwith "),
                    TextSpan(text: name,style: interMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.red))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
