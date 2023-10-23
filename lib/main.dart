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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => QueueNotifier(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ServerUrlNotifier(),
        ),
      ],
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

  const CustomAppBar({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Row(
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
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PageTitleWidget(title: "Services"),
        Expanded(
          child: buildFutureBuilderQueues(),
        ),
      ],
    );
  }
}

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
            style: const TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 84, 84, 84),
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            height: 1.5,
            width: 500,
            color: const Color.fromARGB(255, 255, 189, 89),
          ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String serviceName;
  final String iconName;
  const ServiceCard(this.serviceName, this.iconName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: SizedBox(
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
            const SizedBox(height: 16.0),
            Text(
              serviceName,
              style: const TextStyle(
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
  const BottomNavBar({super.key});

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
      appBar: const CustomAppBar(height: 125),
      body: PageView(
        controller: pageController,
        onPageChanged: (v) {
          tabIndex = v;
        },
        children: const [
          HomePage(),
          QRViewExample(),
          SettingsPage(),
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
        color: const Color.fromARGB(255, 255, 235, 150),
        circleColor: const Color.fromARGB(255, 64, 55, 52),
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

// Create a StatefulWidget with a url variable

class ServerUrlNotifier extends ChangeNotifier {
  String _serverUrl = "http://localhost:88";

  String get serverUrl => _serverUrl;

  set serverUrl(String url) {
    _serverUrl = url;
    notifyListeners();
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 60,
              width: 250,
              child: Card(
                child: Center(
                  child: ServerUrlWidget(),
                ),
              ),
            ),
            SizedBox(height: 50.0),
            SizedBox(
              height: 60,
              width: 250,
              child: Card(
                child: Center(
                  child: Text(
                    "Manual",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50.0),
            SizedBox(
              height: 60,
              width: 250,
              child: Card(
                child: Center(
                  child: Text(
                    "App Theme",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50.0),
            SizedBox(
              height: 60,
              width: 250,
              child: Card(
                child: Center(
                  child: Text(
                    "About Us",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServerUrlWidget extends StatefulWidget {
  const ServerUrlWidget({super.key});

  @override
  State<ServerUrlWidget> createState() => _ServerUrlState();
}

// Define a corresponding State class.
// This class holds data related to the Form.
class _ServerUrlState extends State<ServerUrlWidget> {
  // Create a text controller. Later, use it to retrieve the
  // current value of the TextField.
  final textFieldCtl = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree
    textFieldCtl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    textFieldCtl.addListener(syncNotifier);
  }

  void syncNotifier() {
    Provider.of<ServerUrlNotifier>(
      context,
      listen: false, // No need to listen
    ).serverUrl = textFieldCtl.text;
  }

  @override
  void didChangeDependencies() {
    textFieldCtl.text = Provider.of<ServerUrlNotifier>(
      context,
      listen: true, // Be sure to listen
    )._serverUrl;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServerUrlNotifier>(
      builder: ((context, model, child) {
        return TextField(
          controller: textFieldCtl,
          style: const TextStyle(fontSize: 20),
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
              floatingLabelAlignment: FloatingLabelAlignment.center,
              hintStyle: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
              hintText: 'Server Url'),
        );
      }),
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
