import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:guideTemplate/utils/strings.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class Tools {
  static double width = 100.0;
  static double height = 100.0;

  static PackageInfo packageInfo = PackageInfo(
    appName: ' ',
    packageName: ' ',
    version: ' ',
    buildNumber: ' ',
  );

  //===================================> Config
  static Config config;
  static Future<void> getAppInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    packageInfo = info;
    print("===( Future )============= packageInfo ======================> : " +
        packageInfo.toString());
    return;
  }

  static Future<void> fetchData() async {
    config = new Config();
    String url = Strings.jsonUrl;
    var res = await http.get(Uri.encodeFull(url));
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      config.trafficUrl = data["trafficurl"];
      config.trafficMessage = data["trafficmessage"];
      config.admob = data["admob"];
      config.fb = data["fb"];
    }
    print("===( Future )============= config body ======================> : " +
        config.toString());
    return;
  }

  static getDeviceDimention(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    print("===( width )===> $width\n===( height )===> $height");
  }

  static launchURLRate() async {
    var url = 'https://play.google.com/store/apps/details?id=' +
        Tools.packageInfo.packageName;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static launchURLMore() async {
    var url;
    if (Strings.storeId != "") {
      url = 'https://play.google.com/store/apps/dev?id=' + Strings.storeId;
    } else {
      url = 'https://play.google.com/store/apps/developer?id=' +
          Strings.storeName.split(' ').join('+');
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> copyDataBase() async {
    String path = '';
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String assetFullName = 'assets/databases/articles.db';

      Directory(documentsDirectory.path + '/myData').createSync();

      path = join(
          documentsDirectory.path, 'myData', assetFullName.split('/').last);
      // Only copy if the database doesn't exist
      //if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound){
      // Load database from asset and copy
      ByteData data = await rootBundle.load(assetFullName);
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Save copied asset to documents
      await new File(path).writeAsBytes(bytes);
      print(
          "===( Future )============= Item Copied ======================> : $path");
      /*  }else{
        print("==============================> Database Already Exist!");
      } */
    } catch (e) {
      print("Erreur Copie : $e");
    }
    return;
  }

  static List shuffle(List items, int start, int end) {
    var random = new Random();

    for (var i = items.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items.sublist(start, end);
  }

  static void openWebView({String url, VoidCallback onClose}) async {
    ChromeSafariBrowser browser =
        new MyChromeSafariBrowser(new MyInAppBrowser(), () => onClose());
    await browser.open(
      url: url,
      options: ChromeSafariBrowserClassOptions(
        android: AndroidChromeCustomTabsOptions(
          enableUrlBarHiding: true,
          showTitle: false,
        ),
      ),
    );
  }
}

////////////////////////////////////////////
class MyInAppBrowser extends InAppBrowser {
  @override
  Future onLoadStart(String url) async {
    print("\n\nStarted $url\n\n");
  }

  @override
  Future onLoadStop(String url) async {
    print("\n\nStopped $url\n\n");
  }

  @override
  void onLoadError(String url, int code, String message) {
    print("\n\nCan't load $url.. Error: $message\n\n");
  }

  @override
  void onExit() {
    print("\n\nBrowser closed!\n\n");
  }
}

class MyChromeSafariBrowser extends ChromeSafariBrowser {
  final VoidCallback onClose;
  MyChromeSafariBrowser(browserFallback, this.onClose)
      : super(bFallback: browserFallback);

  @override
  void onOpened() {
    print("ChromeSafari browser opened");
  }

  @override
  void onCompletedInitialLoad() {
    print("ChromeSafari browser initial load completed");
  }

  @override
  void onClosed() {
    onClose();
    print("ChromeSafari browser closed");
  }
}

class Config {
  String trafficUrl;
  String trafficMessage;
  Map admob;
  Map fb;

  @override
  toString() {
    String text = "trafficUrl : " +
        this.trafficUrl +
        ", \ntrafficMessage : " +
        this.trafficMessage +
        ", \nadmob : " +
        this.admob.toString() +
        ", \nfb : " +
        this.fb.toString();
    return text;
  }
}
