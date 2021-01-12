import 'package:chalege_accept/controllers/home_controller.dart';
import 'package:chalege_accept/widgets/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:chalege_accept/view/product_page.dart';
import 'package:dotted_border/dotted_border.dart';

class HomePage extends StatefulWidget {
  static String tag = '/HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController;

  final controller = GetIt.I<HomeController>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.setPage(0);

    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.grey[200],
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (p) {
          controller.setPage(p);

          print(p);
        },
        children: [
          Observer(
            builder: (BuildContext context) {
              return StreamBuilder(
                stream: controller.snapshot,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
                  return Column(
                    children: [
                      InkWell(
                        child: Center(
                          child: CircleAvatar(
                            radius: 85.0,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(
                                'https://firebasestorage.googleapis.com/v0/b/chalege-accept.appspot.com/o/cropped-cropped-logo-min-removebg-preview%20(1).png?alt=media&token=9db3648b-6e59-4bd5-907b-9a0c3b869114',
                                scale: 10),
                          ),
                        ),
                        onTap: () {},
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Panificadora Don Juan",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on),
                          Text(
                            "R. Tomé Souza 171, California Iabuna BA",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      DottedBorder(
                        color: Colors.yellowAccent,
                        strokeWidth: -2,
                        child: Container(
                          width: 300.0,
                          child: RaisedButton(
                            child: Text("Nossos produtos",
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                            colorBrightness: Brightness.dark,
                            onPressed: () {},
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ProductPage(),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.redAccent,
          primaryColor: Colors.yellow[200],
          textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(color: Colors.white),
              ),
        ),
        child: BottomNavigationBar(
          currentIndex: controller.page,
          onTap: (p) {
            _pageController.animateToPage(p,
                curve: Curves.ease, duration: Duration(milliseconds: 500));
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Loja"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text("Produtos"),
            ),
          ],
        ),
      ),
    );
  }
}
