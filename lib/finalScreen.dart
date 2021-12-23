import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'finalDialogBox.dart';
import 'package:get_storage/get_storage.dart';
import 'permissions.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class finalScreen extends StatefulWidget {
  const finalScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<finalScreen> createState() => _finalScreenState();
}

class _finalScreenState extends State<finalScreen> {
  final data = GetStorage();
  int activeIndex = 0;
  TextEditingController controller = TextEditingController();
  bool permit = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    if (data.read('code') == null) {
      WidgetsBinding.instance!.addPostFrameCallback(
          (_) => openDialog(context, controller, false, false));
    }
    permitStatus();
  }

  void permitStatus() async {
    permit = await askPermission();
    while (!permit) {
      permit = await warningDialog(context, permit);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget textMessage(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: 1,
        effect: WormEffect(
          dotHeight: 10.0,
        ),
      );

  Widget buildImage(int index) => Container(
        color: Colors.grey,
        child: Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: Column(
            children: [
              Image.asset("assets/image/1eyH.gif"),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "JustCall with Message",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            'JustCall',
          ),
        ),
      ),
      body: Center(
        child: ListView(
          children: [
            SizedBox(
              height: 5.0,
            ),
            Column(
              children: <Widget>[
                CarouselSlider.builder(
                  options: CarouselOptions(
                      height: 300,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          activeIndex = index;
                        });
                      }),
                  itemCount: 1,
                  itemBuilder: (context, index, realIndex) {
                    return buildImage(index);
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                buildIndicator(),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'About',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 20.0,
                  color: Colors.brown,
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: Text(
                'Application for getting Contact Number by sending a message on Mobile Number.',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: Text(
                'How to Use :',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.blueGrey,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            textMessage(
                '1)Give Neccesary Permission and Set the Login Password'),
            SizedBox(
              height: 2.0,
            ),
            textMessage('2)Set PassCode of 4 digits.'),
            SizedBox(
              height: 2.0,
            ),
            textMessage(
                '3)Now message to your Number in the Format passCode ContactName'),
            SizedBox(
              height: 2.0,
            ),
            textMessage(
                '4)Remeber to have a single spaceBar between passcode and ContactName'),
            SizedBox(
              height: 2.0,
            ),
            textMessage('5)Yayy! you will get the desired Number JustCall!!'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.sms,
            ),
            label: 'Change Passcode',
            tooltip: 'Change passcode',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye),
            label: 'View PassCode',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            openDialog(context, controller, false, true);
          } else {
            viewPasscodeDialog(context);
          }
        },
        backgroundColor: Colors.white,
      ),
    );
  }
}
