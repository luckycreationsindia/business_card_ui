import 'package:business_card_ui/src/models/Customer.dart';
import 'package:business_card_ui/src/models/misc.dart';
import 'package:business_card_ui/src/views/MainTheme.dart';
import 'package:business_card_ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_tags/simple_tags.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectListPage extends StatefulWidget {
  const ConnectListPage({super.key});

  @override
  State<ConnectListPage> createState() => _ConnectListPageState();
}

class _ConnectListPageState extends State<ConnectListPage> {
  final ScrollController _scrollController = ScrollController();
  List<Customer> customerList = [];
  String selectedSector = "";
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
      child: MainTheme(
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
                        "Let's make some connections",
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
                  child: Stack(
                    children: [
                      ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        controller: _scrollController,
                        itemCount: customerList.length,
                        itemBuilder: (context, index) {
                          return getRow(customer: customerList[index]);
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: 55,
            color: const Color(0xFF2C2540),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => showSectorDialog().then((value) {
                    isLoading = true;
                    selectedSector = value ?? "";
                    customerList.clear();
                    hasMore = true;
                    page = 0;
                    loadCustomerList();
                  }),
                  icon: const Icon(Icons.filter_alt, size: 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getRow({required Customer customer}) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            String url = "${Uri.base.origin}/?id=${customer.id!}";
            launchUrl(
              Uri.parse(url),
              webOnlyWindowName: '_blank',
            );
          },
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child:
                        customer.profile != null && customer.profile!.isNotEmpty
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            customer.displayName,
                            style: const TextStyle(fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                          Text.rich(
                            TextSpan(
                              text: customer.company ?? "",
                              children: [
                                const TextSpan(text: "\n"),
                                TextSpan(text: customer.jobTitle ?? ""),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        ),
        customer.sectors != null && customer.sectors!.isNotEmpty ? const SizedBox(height: 10) : const SizedBox(),
        customer.sectors != null && customer.sectors!.isNotEmpty
            ? Align(
                alignment: Alignment.bottomRight,
                child: SimpleTags(
                  content: customer.sectors!,
                  wrapSpacing: 4,
                  wrapRunSpacing: 4,
                  tagContainerPadding: const EdgeInsets.all(6),
                  tagTextStyle: const TextStyle(color: Colors.white),
                  tagContainerDecoration: BoxDecoration(
                    color: Colors.deepPurple,
                    border: Border.all(color: Colors.orangeAccent),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        customer.sectors != null && customer.sectors!.isNotEmpty ? const SizedBox(height: 10) : const SizedBox(),
      ],
    );
  }

  loadCustomerList() {
    if (!hasMore) return;
    setState(() {
      isLoading = true;
    });

    page++;

    Map<String, dynamic> data = {"page": page};

    if(selectedSector.isNotEmpty) {
      data['filter'] = {"sectors": { "\$in": [selectedSector] }};
    }

    CustomerRestClient(Consts.dio)
        .loadCustomerList(data).then((value) {
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

  Future<String?> showSectorDialog() {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return MainTheme(
          child: FutureBuilder<List<String>>(
            future: loadSectorList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              List<String> sectors = (snapshot.data ?? []);
              sectors.sort((a, b) => a.toString().compareTo(b.toString()));
              return SimpleDialog(
                title: const Text('Choose Sector'),
                children: sectors.map((sector) {
                  return SimpleDialogOption(
                    onPressed: () {
                      context.pop(sector);
                    },
                    child: Text(sector),
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );
  }

  Future<List<String>> loadSectorList() async {
    List<String> result = await MiscRestClient(Consts.dio).getSectors();
    return Future.value(result);
  }
}
