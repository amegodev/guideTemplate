import 'package:flutter/material.dart';
import 'package:guideTemplate/utils/navigator.dart';
import 'package:guideTemplate/widgets/drawer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:guideTemplate/utils/ads_helper.dart';
import 'package:guideTemplate/utils/theme.dart';
import 'package:guideTemplate/utils/tools.dart';
import 'package:guideTemplate/widgets/widgets.dart';

class FetchingPage extends StatefulWidget {
  @override
  _FetchingPageState createState() => _FetchingPageState();
}

class _FetchingPageState extends State<FetchingPage>
    with TickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;

  AdsHelper ads;
  CustomDrawer customDrawer;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  int totalPoints;
  String username;

  @override
  void initState() {
    super.initState();
    ads = new AdsHelper();
    ads.load();
    customDrawer = new CustomDrawer(() => ads.showInter(), scaffoldKey);

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));

    _animation = Tween(begin: 0.0, end: 100.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _animationStatus = status;
        if (status == AnimationStatus.completed) {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text(
                    'We are almost done',
                  ),
                  content: Text(
                      'Because of the high pressure on the servers, you may not be able to access them, Just try again from the beginning.\nif you are unable to log in after several attempts, please come back after 24 hours.'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        }
      });

    if (_animationStatus == AnimationStatus.dismissed) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    ads.disposeAllAds();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments as Map;
    if (args != null) {
      totalPoints = int.parse(args['totalPoints']);
      username = args['username'];
    }

    return Scaffold(
      key: scaffoldKey,
      drawer: customDrawer.buildDrawer(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CustomAppBar(
                    scaffoldKey: scaffoldKey,
                    ads: ads.getBanner(),
                    title: Tools.packageInfo.appName,
                    bgColor: Color(0xFF74B3D2),
                    onClicked: () => ads.showInter(probability: 90),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.width * 0.5,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Positioned(
                          top: -MediaQuery.of(context).size.width,
                          child: Container(
                            height: MediaQuery.of(context).size.width * 1.5,
                            width: MediaQuery.of(context).size.width * 1.5,
                            decoration: BoxDecoration(
                              color: Color(0xFF212A3B),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          top: -MediaQuery.of(context).size.width,
                          child: Container(
                            height: MediaQuery.of(context).size.width * 1.485,
                            width: MediaQuery.of(context).size.width * 1.485,
                            decoration: BoxDecoration(
                              color: Color(0xFF74B3D2),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Fetching Server availability',
                                  style: MyTextStyles.bigTitle.apply(
                                    color: Color(0xFF212A3B),
                                    fontSizeFactor: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              Expanded(
                                child: AnimatedBuilder(
                                  animation: _animation,
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return CircularPercentIndicator(
                                      radius: 80.0,
                                      lineWidth: 8.0,
                                      backgroundColor:
                                          MyColors.black.withOpacity(0.1),
                                      percent: _animation.value * 0.01,
                                      center: Text(
                                        _animation.value.toStringAsFixed(0) +
                                            "%",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      progressColor: Color(0xFF212A3B),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      height: 100.0,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _animation,
                          builder: (BuildContext context, Widget child) {
                            return _animation.value < 50.0
                                ? Text(
                                    'Initializing...',
                                    style: MyTextStyles.title,
                                    textAlign: TextAlign.center,
                                  )
                                : _animation.value < 80.0
                                    ? Text(
                                        'Fetching Server...',
                                        style: MyTextStyles.title,
                                        textAlign: TextAlign.center,
                                      )
                                    : _animation.value < 95.0
                                        ? Text(
                                            'Saving data...',
                                            style: MyTextStyles.title,
                                            textAlign: TextAlign.center,
                                          )
                                        : ButtonFilled(
                                            bgColor: MyColors.black,
                                            title: Text(
                                              'Next',
                                              style: MyTextStyles.title
                                                  .apply(color: Colors.white),
                                            ),
                                            onClicked: () {
                                              MyNavigator.goTryAgain(context);
                                            },
                                          );
                          },
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Text(
                      "Not working?",
                      style: new TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.underline),
                    ),
                    onTap: () {
                      MyNavigator.goTryAgain(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 30.0,),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey)),
                  ),
                  child: ads.getNative(MediaQuery.of(context).size.width, double.infinity),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
