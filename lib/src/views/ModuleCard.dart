import 'package:flutter/material.dart';

class ModuleCard extends StatelessWidget {
  const ModuleCard({Key? key, required this.child, required this.pageKey})
      : super(key: key);
  final GlobalKey pageKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    double moduleWidth = MediaQuery.of(context).size.width > 400 ? 400 : MediaQuery.of(context).size.width;

    return Card(
      key: key,
      margin: EdgeInsets.zero,
      elevation: 0,
      child: SizedBox(
        width: moduleWidth,
        child: Container(
          margin: const EdgeInsets.all(10),
          child: child,
        ),
      ),
    );
  }
}
