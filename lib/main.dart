import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:lineup_guru_app/QueueList.dart';
import 'package:lineup_guru_app/second_route.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import 'dart:io';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(isOptional: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QueueNotifier(),
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 189, 89),
            // primary: Color.fromARGB(255, 255, 189, 89),
            // ···
            // Set the background color of cards to be Color.fromARGB(255, 64, 55, 52)
            surface: const Color.fromARGB(255, 64, 55, 52),
            onSurface: Colors.white,
            background: const Color.fromARGB(255, 255, 247, 207),
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(255, 255, 235, 150),
              foregroundColor: Colors.black),
          primaryColor: const Color.fromARGB(255, 255, 189, 89),
          // for navbar rgb(255, 222, 89)
          // for cards rgb(64, 55, 52)
          useMaterial3: true,
        ),
        //  home: Scaffold(
        //    // appBar: CustomAppBar(height: 125),
        //    bottomNavigationBar: BottomNavBar(),
        //  ),
        home: BottomNavBar(),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  const CustomAppBar({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.qr_code),
            SizedBox(width: 10),
            Text(
              "Line-Up Guru",
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageTitleWidget(title: "Services"),
        Expanded(
          child: buildFutureBuilderQueues(),
          // child: GridView.count(
          //   crossAxisCount: 2,
          //   mainAxisSpacing: 40,
          //   crossAxisSpacing: 0,
          //   children: [
          //     GestureDetector(
          //       onTap: () {
          //         print("napindot");
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => const SecondRoute()),
          //         );
          //       },
          //       child: ServiceCard('SAC', Icons.help_center_rounded),
          //     ),
          //     GestureDetector(
          //       onTap: () {},
          //       child: ServiceCard('Payments', Icons.payments_outlined),
          //     ),
          //     GestureDetector(
          //       onTap: () {},
          //       child: ServiceCard('SHS MT', Icons.accessibility),
          //     ),
          //     GestureDetector(
          //       onTap: () {},
          //       child:
          //           ServiceCard('Guidance Center', Icons.credit_score_rounded),
          //     ),
          //   ],
          // ),
        ),
      ],
    );
  }
}

// Create a PageTitleStatefulWidget with a string title field
class PageTitleWidget extends StatefulWidget {
  final String title;
  const PageTitleWidget({Key? key, required this.title}) : super(key: key);

  @override
  PageTitleState createState() => PageTitleState();
}

// Create a State class for the PageTitleStatefulWidget
class PageTitleState extends State<PageTitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 84, 84, 84),
            ),
          ),
          SizedBox(height: 8.0),
          Container(
            height: 1.5,
            width: 500,
            color: Color.fromARGB(255, 255, 189, 89),
          ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String serviceName;
  final String iconName;
  ServiceCard(this.serviceName, this.iconName);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      color: Color.fromARGB(255, 64, 55, 52),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Container(
        height: 150.0, // Adjust the height here
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dont use an Icon/IconData since we cant generate a list of available icons in the app. Also The admin needs to visit the google material icons page for the available icons and names
            Text(
              iconName,
              style: const TextStyle(
                fontFamily: "MaterialIcons",
                color: Colors.yellowAccent,
                fontSize: 48,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              serviceName,
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  int _tabIndex = 0;
  int get tabIndex => _tabIndex;
  set tabIndex(int v) {
    _tabIndex = v;
    setState(() {});
  }

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _tabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(height: 125),
      body: PageView(
        controller: pageController,
        onPageChanged: (v) {
          tabIndex = v;
        },
        children: [
          Container(child: HomePage()),
          Container(child: QRViewExample()),
          Container(child: SettingsPage()),
        ],
      ),
      bottomNavigationBar: CircleNavBar(
        activeIcons: const [
          Icon(Icons.home_outlined, color: Colors.white, size: 35),
          Icon(Icons.qr_code_sharp, color: Colors.white, size: 35),
          Icon(Icons.settings_outlined, color: Colors.white, size: 35),
        ],
        inactiveIcons: const [
          Icon(Icons.home_outlined, color: Colors.black, size: 35),
          Icon(Icons.qr_code_sharp, color: Colors.black, size: 35),
          Icon(Icons.settings_outlined, color: Colors.black, size: 35),
        ],
        color: Color.fromARGB(255, 255, 235, 150),
        circleColor: Color.fromARGB(255, 64, 55, 52),
        circleShadowColor: Colors.black,
        elevation: 10,
        height: 90,
        circleWidth: 70,
        activeIndex: tabIndex,
        onTap: (index) {
          tabIndex = index;
          pageController.jumpToPage(tabIndex);
        },
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 60,
              width: 250,
              child: Card(
                color: Color.fromARGB(255, 64, 55, 52),
                child: Center(
                  child: Text("Manual",
                      style: TextStyle(color: Colors.white, fontSize: 25)),
                ),
              ),
            ),
            SizedBox(height: 50.0),
            Container(
              height: 60,
              width: 250,
              child: Card(
                color: Color.fromARGB(255, 64, 55, 52),
                child: Center(
                  child: Text("App Theme",
                      style: TextStyle(color: Colors.white, fontSize: 25)),
                ),
              ),
            ),
            SizedBox(height: 50.0),
            Container(
              height: 60,
              width: 250,
              child: Card(
                color: Color.fromARGB(255, 64, 55, 52),
                child: Center(
                  child: Text("About Us",
                      style: TextStyle(color: Colors.white, fontSize: 25)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text(result?.code?.toString() ?? 'Scan a code',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.black)),
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 350.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.orange,
          borderRadius: 20,
          borderLength: 40,
          borderWidth: 10,
          // overlayColor: Color.fromARGB(255, 255, 247, 207),
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      controller.scannedDataStream.listen((scanData) {
        if (mounted) {
          setState(() {
            result = scanData;
            controller.pauseCamera();
          });
        }
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
