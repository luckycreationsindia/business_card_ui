import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainTheme extends StatelessWidget {
  final Widget child;

  const MainTheme({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          background: const Color(0xFF2C2540),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        primaryTextTheme: GoogleFonts.promptTextTheme(
          Theme.of(context)
              .primaryTextTheme
              .copyWith(
                bodyLarge: const TextStyle(),
                bodyMedium: const TextStyle(),
                bodySmall: const TextStyle(),
              )
              .apply(
                bodyColor: const Color(0xFFE9E6F0),
                displayColor: const Color(0xFFE9E6F0),
              ),
        ),
        textTheme: GoogleFonts.promptTextTheme(
          Theme.of(context)
              .primaryTextTheme
              .copyWith(
                bodyLarge: const TextStyle(),
                bodyMedium: const TextStyle(),
                bodySmall: const TextStyle(),
              )
              .apply(
                bodyColor: const Color(0xFFE9E6F0),
                displayColor: const Color(0xFFE9E6F0),
              ),
        ),
        inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
              fillColor: const Color(0xFF1E2032),
              hintStyle: const TextStyle(color: Color(0xFF424A70)),
              iconColor: const Color(0xFF424A70),
            ),
        searchBarTheme: Theme.of(context).searchBarTheme.copyWith(
            backgroundColor: const MaterialStatePropertyAll(Color(0xFF1E2032)),
            elevation: const MaterialStatePropertyAll(0),
            overlayColor: const MaterialStatePropertyAll(Color(0xFF1E2032)),
            hintStyle: const MaterialStatePropertyAll(
              TextStyle(color: Color(0xFF424A70)),
            ),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            )),
      ),
      child: child,
    );
  }
}
