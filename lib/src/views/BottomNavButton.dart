import 'package:business_card_ui/extensions.dart';
import 'package:business_card_ui/src/models/Customer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavButton extends StatelessWidget {
  const BottomNavButton({
    Key? key,
    required this.pageKey,
    required this.icon,
    required this.title,
  }) : super(key: key);
  final GlobalKey pageKey;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          IconButton(
            onPressed: () => Scrollable.ensureVisible(
              pageKey.currentContext!,
              duration: const Duration(seconds: 2),
            ),
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