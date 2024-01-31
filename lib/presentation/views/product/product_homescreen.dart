import 'package:cucumber_app/main.dart';
import 'package:cucumber_app/presentation/views/home/home_screen.dart';
import 'package:cucumber_app/presentation/views/product/in_sale_vegs.dart';
import 'package:cucumber_app/presentation/views/product/products.dart';
import 'package:cucumber_app/presentation/views/product/pending_requests.dart';
import 'package:cucumber_app/presentation/widgets/contact_form_widgets.dart';
import 'package:cucumber_app/utils/constants/constants.dart';
import 'package:flutter/material.dart';

class ProductsHomescreen extends StatefulWidget {
  const ProductsHomescreen({super.key});

  @override
  State<ProductsHomescreen> createState() => _ProductsHomescreenState();
}

class _ProductsHomescreenState extends State<ProductsHomescreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            height: screenHeight,
            width: screenWidth,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color.fromARGB(255, 206, 245, 210),
                  Color.fromARGB(255, 111, 210, 115)
                ])),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Home(),
                                ));
                          },
                          icon: const Icon(Icons.arrow_back_ios,
                              size: 25, color: darkgreen)),
                      const Captions(
                          captionColor: darkgreen,
                          captions: 'Join Our Sales team')
                    ],
                  ),
                ),
                lheight,
                const TabBar(
                  labelColor: darkgreen,
                  overlayColor: MaterialStatePropertyAll(kwhite),
                  indicatorColor: darkgreen,
                  tabs: [
                    Tab(
                      text: 'Add Products',
                    ),
                    Tab(text: 'Current sales'),
                    Tab(
                      text: 'Pending Request',
                    )
                  ],
                ),
                const Expanded(
                  child: TabBarView(
                    children: [AddProducts(), InSale(), PendingRequests()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
