import 'dart:typed_data';

import 'package:business_card_ui/extensions.dart';
import 'package:business_card_ui/src/models/Customer.dart';
import 'package:business_card_ui/src/views/BottomNavButton.dart';
import 'package:business_card_ui/src/views/ContactData.dart';
import 'package:business_card_ui/src/views/ModuleCard.dart';
import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:vcard_maintained/vcard_maintained.dart';

late Customer customerData;

void main() async {
  setPathUrlStrategy();
  var dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onResponse: (response, handler) {
        var data = response.data;
        if (data['status'] == 'Success') {
          handler.next(Response(
              requestOptions: response.requestOptions, data: data['message']));
        } else {
          handler.reject(DioException(
            requestOptions: response.requestOptions,
            error: "Error Loading Data",
          ));
        }
      },
    ),
  );
  String id = Uri.base.queryParameters['id'] ?? "";
  customerData = await CustomerRestClient(dio).loadCustomer(id);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Customer>.value(
          value: customerData,
        ),
      ],
      child: MaterialApp(
        title: '${customerData.displayName} - Business Card',
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        onGenerateRoute: (RouteSettings settings) {
          Widget? pageView =
              MyHomePage(title: '${customerData.displayName} - Business Card');
          return MaterialPageRoute(
            builder: (BuildContext context) => pageView,
          );
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: '${customerData.displayName} - Business Card'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final homeKey = GlobalKey();
  final aboutKey = GlobalKey();
  final addressKey = GlobalKey();
  final galleryKey = GlobalKey();
  final productKey = GlobalKey();
  final serviceKey = GlobalKey();
  final contactKey = GlobalKey();
  final paymentKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double moduleWidth = MediaQuery.of(context).size.width > 400
        ? 400
        : MediaQuery.of(context).size.width;
    Customer customer = Provider.of<Customer>(context);
    String mainColor = customer.mainColor;
    final fullWidth = MediaQuery.of(context).size.width;
    final margins = (fullWidth - moduleWidth) / 2;

    return Container(
      decoration: BoxDecoration(
        color: HexColor.fromHex(mainColor),
      ),
      padding: EdgeInsets.symmetric(horizontal: margins),
      child: Scaffold(
        backgroundColor: const Color(0xFFE2E3E4),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Card(
                key: homeKey,
                margin: EdgeInsets.zero,
                elevation: 0,
                child: SizedBox(
                  width: moduleWidth,
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundImage: customer.profile != null &&
                                  customer.profile!.isNotEmpty
                              ? NetworkImage(customer.profile!)
                              : Image.asset('assets/images/img_avatar.png')
                                  .image,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        customer.displayName,
                        textAlign: TextAlign.center,
                      ),
                      customer.jobTitle != null && customer.jobTitle!.isNotEmpty
                          ? Text(
                              customer.jobTitle!,
                              textAlign: TextAlign.center,
                            )
                          : Container(),
                      customer.company != null && customer.company!.isNotEmpty
                          ? Text(
                              customer.company!,
                              textAlign: TextAlign.center,
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ModuleCard(
                pageKey: contactKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: getContactData(customer),
                    ),
                    TextButton(
                      onPressed: () async {
                        var vCard = VCard();
                        vCard.firstName = customer.first_name;
                        vCard.lastName = customer.last_name ?? '';
                        vCard.formattedName = customer.displayName;
                        vCard.cellPhone = customer.contacts != null &&
                                customer.contacts!.isNotEmpty
                            ? customer.contacts![0]
                            : null;
                        vCard.organization = customer.company ?? '';
                        vCard.jobTitle = customer.jobTitle ?? '';
                        if (customer.address != null) {
                          var address = MailingAddress('WORK');
                          address.city = customer.city ?? '';
                          address.stateProvince = customer.state ?? '';
                          address.countryRegion = customer.country ?? '';
                          address.postalCode =
                              customer.pincode?.toString() ?? '';
                          address.street = customer.address ?? '';
                          vCard.workAddress = address;
                        }
                        if (customer.profile != null &&
                            customer.profile!.isNotEmpty) {
                          vCard.photo.attachFromUrl(customer.profile!, 'JPEG');
                        }

                        await FileSaver.instance.saveFile(
                          name: '${vCard.firstName}.vcf',
                          bytes: Uint8List.fromList(
                            vCard.getFormattedString().codeUnits,
                          ),
                          mimeType: MimeType.custom,
                          customMimeType: "text/vcard",
                        );
                      },
                      child: Text(
                        "Save Contact",
                        style: TextStyle(
                          color: HexColor.fromHex(mainColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              customer.about != null && customer.about!.isNotEmpty
                  ? ModuleCard(
                      pageKey: aboutKey,
                      child: Column(
                        children: [
                          const Text(
                            "About",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SelectableText(
                            customer.about!,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : Container(),
              const SizedBox(height: 10),
              customer.address != null && customer.address!.isNotEmpty
                  ? ModuleCard(
                      pageKey: addressKey,
                      child: Column(
                        children: [
                          const Text(
                            "Address",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SelectableText(
                            customer.address!,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : Container(),
              const SizedBox(height: 10),
              (customer.bankDetails != null &&
                          customer.bankDetails!.isNotEmpty) ||
                      (customer.upi != null && customer.upi!.isNotEmpty)
                  ? ModuleCard(
                      pageKey: paymentKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "Payment Details",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 10),
                          customer.bankDetails != null &&
                                  customer.bankDetails!.isNotEmpty
                              ? Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                      "Bank Details:\n${customer.bankDetails!}"),
                                )
                              : Container(),
                          customer.upi != null && customer.upi!.isNotEmpty
                              ? Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: InkWell(
                                    onTap: () {
                                      String uri =
                                          "upi://pay?pa=${customer.upi!}";
                                      if (customer.upiData != null) {
                                        if (customer.upiData!
                                            .containsKey("pn")) {
                                          uri +=
                                              "&pn=${customer.upiData!['pn']}";
                                        }
                                        if (customer.upiData!
                                            .containsKey("url")) {
                                          uri +=
                                              "&refUrl=${customer.upiData!['refUrl']}";
                                          uri +=
                                              "&url=${customer.upiData!['url']}";
                                        }
                                      }
                                      launchUrl(Uri.parse(uri));
                                    },
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: SizedBox(
                                              height: 15,
                                              child: Image.asset(
                                                "assets/images/upi_payment.png",
                                              ),
                                            ),
                                          ),
                                          TextSpan(
                                            text: "  ${customer.upi!}",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BottomNavButton(
                  pageKey: homeKey,
                  icon: Icons.home_outlined,
                  title: "Home",
                ),
                BottomNavButton(
                  pageKey: contactKey,
                  icon: Icons.contact_mail_outlined,
                  title: "Contact",
                ),
                BottomNavButton(
                  pageKey: aboutKey,
                  icon: Icons.info_outline_rounded,
                  title: "About",
                ),
                BottomNavButton(
                  pageKey: paymentKey,
                  icon: Icons.payment_outlined,
                  title: "Payment",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getContactData(Customer customer) {
    List<Widget> result = [];
    if (customer.contacts != null && customer.contacts!.isNotEmpty) {
      result.add(
        ContactData(
          title: "Call",
          icon: Icons.call_outlined,
          onClick: () {
            final Uri params = Uri(
              scheme: 'tel',
              path: customer.contacts![0],
            );
            launchUrl(params);
          },
        ),
      );
    }
    if (customer.whatsapp != null && customer.whatsapp!.isNotEmpty) {
      result.add(
        ContactData(
          title: "WhatsApp",
          icon: FontAwesomeIcons.whatsapp,
          onClick: () {
            launchUrl(Uri.parse("https://wa.me/${customer.whatsapp!}"));
          },
        ),
      );
    }
    if (customer.email != null && customer.email!.isNotEmpty) {
      result.add(
        ContactData(
          title: "Mail",
          icon: Icons.mail_outline,
          onClick: () {
            final Uri params = Uri(
              scheme: 'mailto',
              path: customer.email!,
              query: 'subject=Contact&body=',
            );
            launchUrl(params);
          },
        ),
      );
    }
    if (customer.website != null && customer.website!.isNotEmpty) {
      result.add(
        ContactData(
          title: "Website",
          icon: Icons.language_outlined,
          onClick: () {
            launchUrl(
              Uri.parse(customer.website!),
              mode: LaunchMode.inAppWebView,
            );
          },
        ),
      );
    }
    if (customer.address != null && customer.address!.isNotEmpty) {
      result.add(
        ContactData(
          title: "Location",
          icon: Icons.location_on_outlined,
          onClick: () {
            var address = customer.address!.replaceAll('/\\,/g', '');
            var url = address.replaceAll('/\\ /g', '%20');
            var uri = "https://maps.google.com/maps?q=$url";
            launchUrl(Uri.parse(uri));
          },
        ),
      );
    }
    return result;
  }
}
