import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:guideTemplate/models/article_model.dart';
import 'package:guideTemplate/utils/ads_helper.dart';
import 'package:guideTemplate/utils/database_helper.dart';
import 'package:guideTemplate/utils/theme.dart';
import 'package:guideTemplate/utils/tools.dart';
import 'package:guideTemplate/widgets/drawer.dart';
import 'package:guideTemplate/widgets/widgets.dart';

class ArticleScreen extends StatefulWidget {
  final int index;

  const ArticleScreen({Key key, this.index}) : super(key: key);

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  AdsHelper ads;
  CustomDrawer customDrawer;
  Article article;

  void getArticle() {
    TemplateDatabaseProvider provider = new TemplateDatabaseProvider();
    provider.getArticl(widget.index).then((onValue) {
      setState(() {
        this.article = onValue;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    ads = new AdsHelper();
    getArticle();
    ads.load();
    customDrawer = new CustomDrawer(() => ads.showInter(), scaffoldKey);
  }

  @override
  void dispose() {
    ads.disposeAllAds();
    super.dispose();
  }

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: customDrawer.buildDrawer(context),
      backgroundColor: MyColors.grey1,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CustomAppBar(
              scaffoldKey: scaffoldKey,
              leading: IconButton(
                icon: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    )),
                onPressed: () {
                  ads.showInter();
                  Navigator.pop(context);
                },
              ),
              title: Tools.packageInfo.appName,
              ads: ads.getBanner(),
              onClicked: () => ads.showInter(probability: 90),
            ),
            Expanded(
              child: article == null
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SingleChildScrollView(
                        child: HtmlWidget(
                          article.body.replaceAll("\n", "</br>"),
                          textStyle: TextStyle(fontSize: 16),
                          customWidgetBuilder: (element) {
                            if (element.attributes['type'] == 'banner') {
                              return ads.getBanner();
                            }
                            if (element.attributes['type'] == 'nativebanner') {
                              return ads.getBanner();
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
