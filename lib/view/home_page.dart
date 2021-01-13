import 'package:chalege_accept/controllers/home_controller.dart';
import 'package:chalege_accept/widgets/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:chalege_accept/view/product_page.dart';

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
                        height: 70,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Divider(
                          color: Colors.orangeAccent,
                          height: 20,
                          thickness: 5,
                          indent: 20,
                          endIndent: 0,
                        ),
                      ),
                      Center(
                        child: CircleAvatar(
                          radius: 85.0,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/chalege-accept.appspot.com/o/images.png?alt=media&token=aa41f2db-d4b1-4b12-86e5-6554b6f446e8',
                              scale: 10),
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Divider(
                          color: Colors.orangeAccent,
                          height: 20,
                          thickness: 5,
                          indent: 20,
                          endIndent: 0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                  'https://firebasestorage.googleapis.com/v0/b/chalege-accept.appspot.com/o/1.png?alt=media&token=cccdeda6-416b-4049-b3bd-75bb5a2adcc5',
                                  scale: 10),
                            ),
                            CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                  'https://firebasestorage.googleapis.com/v0/b/chalege-accept.appspot.com/o/3.png?alt=media&token=cdf5f4ab-8d13-410c-815d-03d3f73ced39',
                                  scale: 10),
                            ),
                            CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                  'https://firebasestorage.googleapis.com/v0/b/chalege-accept.appspot.com/o/2.png?alt=media&token=44b361d7-83a8-4647-a78a-b81fe76f6f33',
                                  scale: 10),
                            ),
                            CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                  'https://firebasestorage.googleapis.com/v0/b/chalege-accept.appspot.com/o/4.png?alt=media&token=7c0a83a9-8928-4fe7-b549-bfcd99e2df9c',
                                  scale: 10),
                            ),
                            CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                  'https://firebasestorage.googleapis.com/v0/b/chalege-accept.appspot.com/o/6.png?alt=media&token=5efecae9-4518-4477-bf1b-09c741ba92de',
                                  scale: 10),
                            ),
                            CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                  'https://firebasestorage.googleapis.com/v0/b/chalege-accept.appspot.com/o/5.png?alt=media&token=19abd9c5-7575-4049-9d33-f3b608de2b2e',
                                  scale: 10),
                            ),
                          ],
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
              icon: Observer(builder: (BuildContext context) {
                return Icon(
                  Icons.home,
                  color:
                      controller.page == 0 ? Colors.yellow[200] : Colors.white,
                );
              }),
              title: Observer(
                builder: (BuildContext context) {
                  return Text(
                    "Loja",
                    style: TextStyle(
                      color: controller.page == 0
                          ? Colors.yellow[500]
                          : Colors.white,
                    ),
                  );
                },
              ),
            ),
            BottomNavigationBarItem(
              icon: Observer(
                builder: (BuildContext context) {
                  return Icon(
                    Icons.list,
                    color: controller.page == 1
                        ? Colors.yellow[500]
                        : Colors.white,
                  );
                },
              ),
              title: Observer(
                builder: (BuildContext context) {
                  return Text(
                    "Produtos",
                    style: TextStyle(
                      color: controller.page == 1
                          ? Colors.yellow[200]
                          : Colors.white,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
