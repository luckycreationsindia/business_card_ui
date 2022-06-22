import 'package:businesscard/extensions.dart';
import 'package:businesscard/src/models/Customer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactData extends StatelessWidget {
  const ContactData({
    Key? key,
    required this.icon,
    required this.title,
    required this.onClick,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final Function() onClick;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onClick,
            icon: Icon(
              icon,
              color: HexColor.fromHex(Provider.of<Customer>(context).appColor),
            ),
          ),
          Text(title),
        ],
      ),
    );
  }
}