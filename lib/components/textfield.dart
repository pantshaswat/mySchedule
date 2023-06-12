import 'package:flutter/material.dart';

SuffixIconButton({IconData? icon, Function? onTap}) {
  return GestureDetector(
    onTap: onTap as void Function()?,
    child: Icon(
      icon,
      color: Colors.grey,
    ),
  );
}

Container reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller,
    {IconData? suffixIcon, onTap}) {
  return Container(
    margin: EdgeInsets.only(left: 10, right: 10),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 204, 215, 224),
          Color.fromARGB(255, 57, 148, 222),
        ],
      ),
      borderRadius: BorderRadius.circular(30.0),
    ),
    // padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    child: TextField(
      obscuringCharacter: '*',
      controller: controller,
      obscureText: isPasswordType,
      decoration: InputDecoration(
          suffixIcon: SuffixIconButton(
              icon: suffixIcon,
              onTap: () {
                onTap();
              }),
          prefixIcon: Icon(
            icon,
            color: Colors.grey,
          ),
          hintText: text,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none))),
      keyboardType: isPasswordType
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
    ),
  );
}

Container elevatedButtons(
    dynamic Onpressed, String text, double height, double width) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 53, 36, 103),
          Color.fromARGB(255, 51, 124, 234),
        ],
      ),
      borderRadius: BorderRadius.circular(30.0),
    ),
    child: ElevatedButton(
      onPressed: (Onpressed),
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: const BorderSide(
              width: 1, color: Color.fromARGB(255, 72, 71, 71)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      child: Text(
        text,
        style: TextStyle(fontFamily: 'mainFont', fontSize: 20),
      ),
    ),
  );
}

Widget myDivider() {
  return const Expanded(
    child: Divider(
      color: Color.fromARGB(255, 135, 152, 227),
      indent: 15,
      endIndent: 15,
      thickness: 2,
    ),
  );
}
