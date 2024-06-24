import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


import '../../model/utils/colors.dart';
import '../../model/utils/dimensions.dart';
import '../../model/utils/styles.dart';

class EditTextField extends StatelessWidget {
  String text;
  String? name;
  TextInputType textInputType;
  bool isSecure;
  String? preFix;
  void Function(String)? onChanged;
  String? Function(String?)? validator;
  EditTextField({Key? key,required this.text,this.name,this.preFix,this.textInputType=TextInputType.text,this.isSecure=false,this.onChanged,this.validator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        color: editFieldColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(preFix!=null)const SizedBox(width: 15,),
          if(preFix!=null)SvgPicture.asset(preFix!, height: 35,color: preFix!.contains("google")?null:colorPurple,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0,top: 12),
                  child: Text(text,style: interLight.copyWith(color: textDullGray,fontSize: Dimensions.fontSizeSmall),),
                ),
                SizedBox(
                  height: 35,
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.top,
                    style: interLight,
                    keyboardType: textInputType,
                    cursorColor: Theme.of(context).primaryColor,
                    autofocus: false,
                    obscureText: isSecure,
                    onChanged: onChanged,
                    validator: validator,
                    decoration: InputDecoration(
                      focusColor: const Color(0XFFF7F7F7),
                      hoverColor: const Color(0XFFF7F7F7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(style: BorderStyle.none, width: 0),
                      ),
                      isDense: true,
                      hintText: name,
                      hintStyle: interLight.copyWith(color: textDullBlack),
                      fillColor: editFieldColor,
                      filled: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
