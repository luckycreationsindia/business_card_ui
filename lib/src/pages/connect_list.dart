import 'package:business_card_ui/src/models/Customer.dart';
import 'package:business_card_ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectListPage extends StatefulWidget {
  const ConnectListPage({super.key});

  @override
  State<ConnectListPage> createState() => _ConnectListPageState();
}

class _ConnectListPageState extends State<ConnectListPage> {
  final ScrollController _scrollController = ScrollController();
  List<Customer> customerList = [];
  bool isLoading = true;
  bool hasMore = true;
  int page = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadCustomerList();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        loadCustomerList();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: "Connect - Digital Business Card",
      color: Colors.indigo,
      child: Theme(
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
              backgroundColor:
                  const MaterialStatePropertyAll(Color(0xFF1E2032)),
              elevation: const MaterialStatePropertyAll(0),
              overlayColor: const MaterialStatePropertyAll(Color(0xFF1E2032)),
              hintStyle: const MaterialStatePropertyAll(
                TextStyle(color: Color(0xFF424A70)),
              ),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              )),
        ),
        child: Scaffold(
          backgroundColor: const Color(0xFF2C2540),
          body: Container(
            margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Text(
                        "Connect with Others",
                        style: TextStyle(
                          fontSize: 30,
                          color: Color(0xFFE9E6F0),
                        ),
                      ),
                    ),
                    Image.asset(
                      "assets/images/logo.png",
                      height: 50,
                      width: 50,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: customerList.length,
                    itemBuilder: (context, index) {
                      return getRow(customer: customerList[index]);
                    },
                  ),
                ),
                isLoading
                    ? const CircularProgressIndicator()
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getRow({required Customer customer}) {
    return InkWell(
      onTap: () {
        String url = "${Uri.base.origin}/?id=${customer.id!}";
        launchUrl(
          Uri.parse(url),
          webOnlyWindowName: '_blank',
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: customer.profile != null && customer.profile!.isNotEmpty
                  ? Image.network(
                      customer.profile ?? '',
                      height: 100,
                      width: 100,
                    )
                  : Image.asset(
                      "assets/images/img_avatar.png",
                      height: 100,
                      width: 100,
                    ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    customer.displayName,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text.rich(
                    TextSpan(
                      text: customer.company ?? "",
                      children: [
                        const TextSpan(text: "\n"),
                        TextSpan(text: customer.jobTitle ?? ""),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  loadCustomerList() {
    if (!hasMore) return;
    setState(() {
      isLoading = true;
    });

    page++;

    CustomerRestClient(Consts.dio)
        .loadCustomerList({"page": page}).then((value) {
      if (value.isEmpty) {
        hasMore = false;
      }
      customerList.addAll(value);
    }).catchError((err) {
      print(err);
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }
}
