import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guideTemplate/articles.dart';
import 'package:guideTemplate/screens/article_details.dart';
import 'package:guideTemplate/utils/ads_helper.dart';
import 'package:guideTemplate/utils/theme.dart';
import 'package:guideTemplate/utils/tools.dart';
import 'package:guideTemplate/widgets/drawer.dart';
import 'package:guideTemplate/widgets/widgets.dart';

class ArticlesScreen extends StatefulWidget {
  @override
  _ArticlesScreenState createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  AdsHelper ads;
  CustomDrawer customDrawer;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    ads = new AdsHelper();
    ads.loadFbInter(AdsHelper.fbInterId_2);
    customDrawer = new CustomDrawer(() => ads.showInter(), scaffoldKey);
  }

  @override
  void dispose() {
    ads.disposeAllAds();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: customDrawer.buildDrawer(context),
      body: Column(
        children: <Widget>[
          CustomAppBar(
            scaffoldKey: scaffoldKey,
            title: Tools.packageInfo.appName,
            ads: ads.getFbNativeBanner(
                AdsHelper.fbNativeBannerId_2, NativeBannerAdSize.HEIGHT_50),
            onClicked: () => ads.showInter(probablity: 90),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: Articles.titles.length,
              itemBuilder: (context, index) {
                return index % 8 == 0 && index != 0
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: 300.0,
                        margin: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 1.5),
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14.0),
                          child: ads.getFbNative(
                              AdsHelper.fbNativeId,
                              MediaQuery.of(context).size.width,
                              double.infinity),
                        ),
                      )
                    : MainButton(
                        title: Text(
                          Articles.titles[index],
                          style: MyTextStyles.bigTitle,
                        ),
                        svgIcon: 'assets/icons/articles.svg',
                        onClicked: () {
                          ads.showInter();
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return ArticleScreen(
                              index: index,
                            );
                          }));
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
