import 'package:flutter/material.dart';
import 'package:guideTemplate/screens/next_screen.dart';
import 'package:guideTemplate/utils/ads_helper.dart';
import 'package:guideTemplate/utils/navigator.dart';
import 'package:guideTemplate/utils/strings.dart';
import 'package:guideTemplate/utils/theme.dart';
import 'package:guideTemplate/utils/tools.dart';
import 'package:guideTemplate/widgets/dialogs.dart';
import 'package:guideTemplate/widgets/drawer.dart';
import 'package:guideTemplate/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreeState createState() => _HomeScreeState();
}

class _HomeScreeState extends State<HomeScreen> {
  AdsHelper ads;
  CustomDrawer customDrawer;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    ads = new AdsHelper();
    Tools.copyDataBase();
    ads.load();
    customDrawer = new CustomDrawer(() => ads.showInter(),scaffoldKey);
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
      body: FutureBuilder(
          future: Tools.fetchData(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              return Column(
                children: <Widget>[
                  CustomAppBar(
                    scaffoldKey: scaffoldKey,
                    title: Tools.packageInfo.appName,
                    ads: ads.getBanner(),
                    onClicked: () => ads.showInter(),
                  ),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        MainButton(
                          title: Text(
                            'Start',
                            style: MyTextStyles.bigTitle,
                          ),
                          bgColor: Color(0xFFF1A737),
                          svgIcon: 'assets/icons/play.svg',
                          onClicked: () {
                            ads.showInter();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext context) {
                                  return NextScreen(
                                    widget: MainButton(
                                      title: Text(
                                        'Next',
                                        style: MyTextStyles.bigTitle,
                                      ),
                                      bgColor: Color(0xFFF1A737),
                                      svgIcon: 'assets/icons/play.svg',
                                      onClicked: () {
                                        ads.showInter();
                                        MyNavigator.goCounter(context);
                                      },
                                    ),
                                  );
                                }));
                          },
                        ),
                        MainButton(
                          title: Text(
                            'Walkthrough',
                            style: MyTextStyles.bigTitle,
                          ),
                          bgColor: Color(0xFF00B5D9),
                          svgIcon: 'assets/icons/articles.svg',
                          onClicked: () {
                            ads.showInter();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext context) {
                                  return NextScreen(
                                    widget: MainButton(
                                      title: Text(
                                        'Next',
                                        style: MyTextStyles.bigTitle,
                                      ),
                                      bgColor: Color(0xFFF1A737),
                                      svgIcon: 'assets/icons/articles.svg',
                                      onClicked: () {
                                        MyNavigator.goArticles(context);
                                      },
                                    ),
                                  );
                                }));
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: MainButton(
                            title: Text(
                              'Our Store',
                              style: MyTextStyles.bigTitle,
                            ),
                            svgIcon: 'assets/icons/more_apps.svg',
                            onClicked: () {
                              Tools.launchURLMore();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: MainButton(
                            title: Text(
                              Strings.privacy,
                              style: MyTextStyles.bigTitle,
                            ),
                            svgIcon: 'assets/icons/privacy_policy.svg',
                            onClicked: () {
                              ads.showInter();
                              MyNavigator.goPrivacy(context);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: MainButton(
                            title: Text(
                              'About',
                              style: MyTextStyles.bigTitle,
                            ),
                            svgIcon: 'assets/icons/about.svg',
                            onClicked: () async {
                              showDialog(
                                  context: context,
                                  builder: (_) => RatingDialog()).then((value) {
                                if (value == null){
                                  ads.showInter();
                                  return;
                                }
                                String text = '';
                                if (value <= 3) {
                                  ads.showInter();
                                  if (value <= 2)
                                    text = 'Your rating was $value ☹ alright, thank you.';
                                  if (value == 3) text = 'Thanks for your rating 🙂';
                                } else if (value >= 4)
                                  text = 'Thanks for your rating 😀';
                                scaffoldKey.currentState.showSnackBar(
                                  new SnackBar(
                                    content: Text(text),
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
          }
      ),
    );
  }
}