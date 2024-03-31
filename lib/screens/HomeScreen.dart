import '../main.dart';
import 'ContestScreen.dart';
import 'ProfileScreen.dart';
import '../utils/colors.dart';
import '../utils/images.dart';
import 'WheelSpinScreen.dart';
import '../utils/widgets.dart';
import '../utils/constants.dart';
import 'QuizCategoryScreen.dart';
import 'QuizDescriptionScreen.dart';
import '../models/PlayZoneModel.dart';
import '../services/QuizService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'ContainerProfileComplette.dart';
import '../components/DrawerComponent.dart';
import '../components/PlayZoneComponent.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:quizapp_flutter/screens/ChatScreen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:quizapp_flutter/services/userDBService.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import '../components/QuizCategoryComponent.dart';
// import '../models/CategoryModel.dart';
// import 'QuizScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  AdvancedDrawerController _advancedDrawerController =
      AdvancedDrawerController();
  bool profileIsnotComplette() {
    print(
        "Classe: ${appStore.userclasse}, Email: ${appStore.userEmail}, Name: ${appStore.userName}, Age: ${appStore.userAge}");
    return (appStore.userEmail!.trim().isEmpty ||
        appStore.userName!.trim().isEmpty ||
        appStore.userclasse!.trim().isEmpty ||
        appStore.userAge!.trim().isEmpty);
  }

  DateTime? currentBackPressTime;

  final Shader linearGradient = LinearGradient(
    colors: <Color>[colorPrimary, colorSecondary],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    init();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed &&
        state != AppLifecycleState.detached) {
      UserDBService().setUserstatut(true, appStore.userId!);
      print('Online');
    } else {
      UserDBService().setUserstatut(false, appStore.userId!);
      print('Ofline');
    }
  }

  Future<void> init() async {
    afterBuildCreated(() {
      setStatusBarColor(Colors.transparent,
          statusBarIconBrightness: Brightness.dark);

      appSettingService.setAppSettings();

      appStore.setAppLocalization(context);

      OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) {
          if (result.notification.additionalData!.containsKey('id')) {
            String quizId = result.notification.additionalData!['id'];
            QuizService().getQuizByQuizId(quizId).then(
              (value) {
                if (profileIsnotComplette()) {
                  bottomshetUncompletteProfile(context);
                } else {
                  QuizDescriptionScreen(quizModel: value.first).launch(context);
                }
              },
            ).catchError(
              (e) {
                toast(e.toString());
              },
            );
          }
        },
      );
    });

    await 5.seconds.delay;
    LiveStream().on(
      HideDrawerStream,
      (s) {
        scaffoldKey.currentState!.openEndDrawer();
      },
    );
  }

  @override
  void dispose() {
    LiveStream().dispose(HideDrawerStream);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double heightOfStatusBar = MediaQuery.of(context).viewPadding.top;
    double width = MediaQuery.of(context).size.width;
    appStore.setAppLocalization(context);
    List<PlayZoneModel> playZoneList = [
      PlayZoneModel(
          name: appStore.translate('lbl_daily_quiz'),
          image: "images/1 Daily Quiz.png"),
      PlayZoneModel(
          name: appStore.translate('lbl_random_quiz_title'),
          image: "images/2 Random Quiz.png"),
      PlayZoneModel(
          name: appStore.translate('lbl_true_false'),
          image: "images/3 Truefalse.png"),
      PlayZoneModel(
          name: appStore.translate('lbl_guess_word_title'),
          image: "images/4 Guess The Word.png"),
    ];
    return AdvancedDrawer(
      backdropColor: context.scaffoldBackgroundColor,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: appStore.selectedLanguage == 'ar' ? true : false,
      disabledGestures: false,
      childDecoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      openRatio: 0.6,
      openScale: 0.8,
      drawer: DrawerComponent(onCall: () {
        _advancedDrawerController.hideDrawer();
        setState(() {});
      }),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor:
            appStore.isDarkMode == true ? Colors.black : Color(0xfff6f6f6),
        // drawer: DrawerComponent(),
        body: WillPopScope(
          onWillPop: onWillPop,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarBrightness: Brightness.dark,
                      statusBarColor: Colors.transparent),
                  // backgroundColor: colorPrimary,
                  iconTheme: IconThemeData(color: scaffoldColor),
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          _advancedDrawerController.showDrawer();
                        },
                        child: Icon(Icons.menu, color: Colors.white, size: 26),
                      ),
                      Observer(
                        builder: (context) => appStore.userProfileImage
                                .validate()
                                .isEmpty
                            ? CircleAvatar(
                                radius: 26, child: Image.asset(UserPic))
                            : CircleAvatar(
                                radius: 24,
                                child: cachedImage(
                                        appStore.userProfileImage.validate(),
                                        usePlaceholderIfUrlEmpty: true,
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover)
                                    .cornerRadiusWithClipRRect(35),
                              ),
                      ).onTap(() {
                        ProfileScreen().launch(context);
                      }),
                    ],
                  ).paddingOnly(bottom: 4),
                  centerTitle: true,
                  pinned: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(26),
                        bottomRight: Radius.circular(26)),
                  ),
                  expandedHeight: appStore.selectedLanguage == 'ar'
                      ? 300
                      : (context.width() / 3) + 200,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(26),
                            bottomRight: Radius.circular(26)),
                        gradient: LinearGradient(
                            colors: [colorPrimary, colorSecondary],
                            begin: FractionalOffset.centerLeft,
                            end: FractionalOffset.centerRight)),
                    child: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: Container(
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(26),
                              bottomRight: Radius.circular(26)),
                          gradient: LinearGradient(
                              colors: [colorPrimary, colorSecondary],
                              begin: FractionalOffset.centerLeft,
                              end: FractionalOffset.centerRight),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: heightOfStatusBar),
                            55.height,
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: appStore
                                          .translate('lbl_welcome')
                                          .toUpperCase(),
                                      style: boldTextStyle().copyWith(
                                          color: Colors.white,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w400)),
                                  TextSpan(
                                      text: " , ${appStore.userName!}",
                                      style: primaryTextStyle().copyWith(
                                          color: Colors.white, fontSize: 20)),
                                ],
                              ),
                            ),
                            16.height,
                            Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    print(appStore.userAge);
                                    print(appStore.userEmail);
                                    print(appStore.userName);
                                    print(appStore.userclasse);
                                    if (profileIsnotComplette()) {
                                      bottomshetUncompletteProfile(context);
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WheelSpinScreen()));
                                    }
                                  },
                                  child: Container(
                                    height: (context.width() / 3) + 40,
                                    padding: EdgeInsets.all(16),
                                    width: width,
                                    decoration: BoxDecoration(
                                        color: appStore.isDarkMode
                                            ? Colors.black.withOpacity(0.8)
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 165,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                appStore
                                                    .translate('lbl_spin_play'),
                                                style: boldTextStyle().copyWith(
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    foreground: Paint()
                                                      ..shader =
                                                          linearGradient),
                                              ),
                                              appStore.selectedLanguage == 'ar'
                                                  ? 3.height
                                                  : 18.height,
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 25,
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.topRight,
                                                      colors: [
                                                        colorPrimary,
                                                        colorSecondary
                                                      ]),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                    appStore
                                                        .translate('lbl_click'),
                                                    style: primaryTextStyle()
                                                        .copyWith(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.white)),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -120,
                                  right: appStore.selectedLanguage == 'ar'
                                      ? null
                                      : -27,
                                  left: appStore.selectedLanguage == 'ar'
                                      ? 0
                                      : null,
                                  child: Image.asset(Spin_gif,
                                      width: (context.width() / 2) + 35,
                                      height: (context.width() / 2) + 35,
                                      fit: BoxFit.cover),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: SingleChildScrollView(
              child: AnimationLimiter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: AnimationConfiguration.toStaggeredList(
                      duration: Duration(seconds: 1),
                      childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                      children: [
                        22.height,
                        Text(appStore.translate('lbl_play_zone'),
                                style: boldTextStyle().copyWith(fontSize: 22))
                            .paddingOnly(left: 16, right: 16),
                        12.height,
                        SizedBox(
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: List.generate(
                              playZoneList.length,
                              (index) {
                                return PlayZoneComponent(
                                  name: playZoneList[index].name,
                                  image: playZoneList[index].image,
                                  index: index,
                                );
                              },
                            )..addAll(
                                <Widget>[
                                  Builder(builder: (context) {
                                    return ChatComponent().onTap(() {
                                      if (!profileIsnotComplette()) {
                                        showConfirmDialogCustom(
                                          context,
                                          title: 'Posez vos question',
                                          subTitle: appStore.translate(
                                              "lbl_chat_ia_description"),
                                          positiveText:
                                              appStore.translate('lbl_yes'),
                                          negativeText:
                                              appStore.translate('lbl_no'),
                                          primaryColor: colorPrimary,
                                          customCenterWidget:
                                              customCenterDialogImage(
                                                  image: appLogoImage),
                                          onAccept: (context) {},
                                        ).then((value) {
                                          if (value ?? false) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatSCreen()),
                                            );
                                          }
                                        });
                                      } else {
                                        bottomshetUncompletteProfile(context);
                                      }
                                    });
                                  }),
                                  Builder(builder: (context) {
                                    return allCategoriesComponent(context)
                                        .onTap(() {
                                      if (!profileIsnotComplette()) {
                                        QuizCategoryScreen().launch(context);
                                      } else {
                                        bottomshetUncompletteProfile(context);
                                      }
                                    });
                                  })
                                ].reversed.toList(),
                              ),
                          ),
                        ).paddingOnly(left: 16, right: 16),
                        // 22.height,
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(appStore.translate('lbl_category'),
                        //         style: boldTextStyle(size: 20)),
                        //     Text(
                        //       appStore.translate('lbl_see_all'),
                        //       style: primaryTextStyle(color: colorPrimary),
                        //     ).onTap(
                        //       () {
                        //         // if (profileIsnotComplette) {
                        //         //   bottomshetUncompletteProfile(context);
                        //         // } else {
                        //         QuizCategoryScreen().launch(context);
                        //         // }
                        //       },
                        //     )
                        //   ],
                        // ).paddingOnly(left: 16, right: 16),
                        // 12.height,
                        // FutureBuilder(
                        //   future: categoryService.categories(),
                        //   builder: (context, snapshot) {
                        //     if (snapshot.hasData) {
                        //       List<CategoryModel> data =
                        //           snapshot.data as List<CategoryModel>;
                        //       return Container(
                        //         alignment: Alignment.topCenter,
                        //         padding: EdgeInsets.only(left: 16, right: 16),
                        //         child: Wrap(
                        //           spacing: 16,
                        //           runSpacing: 16,
                        //           children: List.generate(
                        //             data.length,
                        //             (index) {
                        //               CategoryModel? mData = data[index];
                        //               return AnimationConfiguration
                        //                   .staggeredList(
                        //                 position: index,
                        //                 duration: Duration(milliseconds: 375),
                        //                 child: SlideAnimation(
                        //                   verticalOffset: 50.0,
                        //                   child: FadeInAnimation(
                        //                     child: QuizCategoryComponent(
                        //                             category: mData)
                        //                         .onTap(
                        //                       () {
                        //                         if (profileIsnotComplette()) {
                        //                           bottomshetUncompletteProfile(
                        //                               context);
                        //                         } else {
                        //                           QuizScreen(
                        //                                   catId: mData.id,
                        //                                   catName: mData.name)
                        //                               .launch(context);
                        //                         }
                        //                       },
                        //                       highlightColor:
                        //                           Colors.transparent,
                        //                       splashColor: Colors.transparent,
                        //                     ),
                        //                   ),
                        //                 ),
                        //               );
                        //             },
                        //           ),
                        //         ),
                        //       );
                        //     }
                        //     return snapWidgetHelper(snapshot,
                        //         errorWidget: emptyWidget(
                        //             text:
                        //                 appStore.translate('lbl_noDataFound')));
                        //   },
                        // ),
                        22.height,
                        Text(appStore.translate('lbl_contest'),
                                style: boldTextStyle(size: 20))
                            .paddingOnly(left: 16, right: 16),
                        12.height,
                        Builder(builder: (context) {
                          return InkWell(
                            onTap: () {
                              if (profileIsnotComplette()) {
                                bottomshetUncompletteProfile(context);
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ContestScreen()));
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 16, right: 16),
                              padding: EdgeInsets.only(
                                  right: appStore.selectedLanguage == 'ar'
                                      ? 0
                                      : 16,
                                  left: appStore.selectedLanguage == 'ar'
                                      ? 16
                                      : 0),
                              decoration: BoxDecoration(
                                  color: colorPrimary,
                                  borderRadius: BorderRadius.circular(16)),
                              width: width,
                              height: 120,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(ContestImage,
                                      height: 120, width: 120),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(appStore.translate("lbl_play_quiz"),
                                          style: boldTextStyle(
                                              color: Colors.white, size: 36),
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis),
                                      2.height,
                                      Text(appStore.translate('lbl_tournament'),
                                          style: boldTextStyle(
                                              size: 20, color: Colors.white54)),
                                    ],
                                  ).expand(),
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          blurRadius: 10.0,
                                          offset: Offset(-5, 5),
                                        )
                                      ],
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.topRight,
                                          colors: [Colors.white, Colors.white]),
                                    ),
                                    child: Icon(Icons.arrow_forward_rounded,
                                        color: colorPrimary),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                        20.height
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container allCategoriesComponent(BuildContext context) {
    return Container(
      width: (context.width() - 48) / 2,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [colorPrimary, colorSecondary]),
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(appStore.translate('lbl_category'),
              style:
                  boldTextStyle().copyWith(color: Colors.white, fontSize: 18)),
          6.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(Categorie_icon,
                      color: Colors.white, height: 20, width: 20),
                  6.width,
                  SizedBox(
                      width: ((context.width() - 48) / 2) - 95,
                      child: Text(appStore.translate('lbl_see_all'),
                          style: primaryTextStyle()
                              .copyWith(color: Colors.white, fontSize: 18),
                          softWrap: true)),
                  Image.asset(Categorie_image, width: 30, height: 30)
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  bottomshetUncompletteProfile(BuildContext context) {
    return showBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ContainerUncompletteProfille(),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press back again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }
}

class ChatComponent extends StatelessWidget {
  const ChatComponent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (context.width() - 48) / 2,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [colorPrimary, colorSecondary]),
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('ChatGPT 4',
              style: primaryTextStyle()
                  .copyWith(color: Colors.white, fontSize: 18)),
          6.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(gpt_Icon,
                      color: Colors.white, height: 20, width: 20),
                  6.width,
                  SizedBox(
                      width: ((context.width() - 48) / 2) - 88,
                      child: Text(
                          // appStore.translate(
                          //     'lbl_playNow'),
                          appStore.translate("ask_question"),
                          style: primaryTextStyle()
                              .copyWith(color: Colors.white, fontSize: 15),
                          softWrap: true)),
                  Image.asset(Chat_icon, width: 30, height: 30)
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
