import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:quizapp_flutter/AppLocalizations.dart';
import 'package:quizapp_flutter/screens/SplashScreen.dart';
import 'package:quizapp_flutter/services/AuthService.dart';
import 'package:quizapp_flutter/services/CategoryService.dart';
import 'package:quizapp_flutter/services/ContestService.dart';
import 'package:quizapp_flutter/services/DailyQuizService.dart';
import 'package:quizapp_flutter/services/OnlineQuizServices.dart';
import 'package:quizapp_flutter/services/QuestionService.dart';
import 'package:quizapp_flutter/services/QuizHistoryService.dart';
import 'package:quizapp_flutter/services/QuizService.dart';
import 'package:quizapp_flutter/services/SettingService.dart';
import 'package:quizapp_flutter/services/userDBService.dart';
import 'package:quizapp_flutter/store/AppStore.dart';
import 'package:quizapp_flutter/utils/AppTheme.dart';
import 'package:quizapp_flutter/utils/constants.dart';

AppStore appStore = AppStore();

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

AuthService authService = AuthService();
UserDBService userDBService = UserDBService();
CategoryService categoryService = CategoryService();
QuestionService questionService = QuestionService();
ContestService contestService = ContestService();
QuizService quizService = QuizService();
QuizHistoryService quizHistoryService = QuizHistoryService();
DailyQuizService dailyQuizService = DailyQuizService();
AppSettingService appSettingService = AppSettingService();
OnlineQuizServices onlineQuizServices = OnlineQuizServices();

bool bannerReady = false;
bool interstitialReady = false;
bool rewarded = false;

// OpenedNotificationHandler? _onOpenedNotification;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp().then((value) async {
    MobileAds.instance.initialize();
  });

  await initialize(aLocaleLanguageList: [
    LanguageDataModel(
        id: 1,
        name: 'English',
        languageCode: 'en',
        flag: 'images/flag/ic_us.png'),
    LanguageDataModel(
        id: 2,
        name: 'Hindi',
        languageCode: 'hi',
        flag: 'images/flag/ic_india.png'),
    LanguageDataModel(
        id: 3,
        name: 'Arabic',
        languageCode: 'ar',
        flag: 'images/flag/ic_ar.png'),
    LanguageDataModel(
        id: 4,
        name: 'Spanish',
        languageCode: 'es',
        flag: 'images/flag/ic_spain.png'),
    LanguageDataModel(
        id: 5,
        name: 'Afrikaans',
        languageCode: 'af',
        flag: 'images/flag/ic_south_africa.png'),
    LanguageDataModel(
        id: 6,
        name: 'French',
        languageCode: 'fr',
        flag: 'images/flag/ic_france.png'),
    LanguageDataModel(
        id: 7,
        name: 'German',
        languageCode: 'de',
        flag: 'images/flag/ic_germany.png'),
    LanguageDataModel(
        id: 8,
        name: 'Indonesian',
        languageCode: 'id',
        flag: 'images/flag/ic_indonesia.png'),
    LanguageDataModel(
        id: 9,
        name: 'Portuguese',
        languageCode: 'pt',
        flag: 'images/flag/ic_portugal.png'),
    LanguageDataModel(
        id: 10,
        name: 'Turkish',
        languageCode: 'tr',
        flag: 'images/flag/ic_turkey.png'),
    LanguageDataModel(
        id: 11,
        name: 'vietnam',
        languageCode: 'vi',
        flag: 'images/flag/ic_vitnam.png'),
    LanguageDataModel(
        id: 12,
        name: 'Dutch',
        languageCode: 'nl',
        flag: 'images/flag/ic_dutch.png'),
  ]);

  selectedLanguageDataModel =
      getSelectedLanguageModel(defaultLanguage: defaultLanguage);
  if (selectedLanguageDataModel != null) {
    appStore.setLanguage(selectedLanguageDataModel!.languageCode.validate());
  } else {
    selectedLanguageDataModel = localeLanguageList.first;
    appStore.setLanguage(selectedLanguageDataModel!.languageCode.validate());
  }
  defaultRadius = 12.0;
  defaultAppButtonRadius = 12.0;
  setOrientationPortrait();

  appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN));
  if (appStore.isLoggedIn) {
    appStore.setUserId(getStringAsync(USER_ID));
    appStore.setName(getStringAsync(USER_DISPLAY_NAME));
    appStore.setUserEmail(getStringAsync(USER_EMAIL));
    appStore.setProfileImage(getStringAsync(USER_PHOTO_URL));
    appStore.setUserAge(getStringAsync(USER_AGE));
    appStore.setUserClasse(getStringAsync(USER_CLASS));
  }
  int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
  if (themeModeIndex == ThemeModeLight) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == ThemeModeDark) {
    appStore.setDarkMode(true);
  }

  await OneSignal.shared.setAppId(mOneSignalAppId);
  OneSignal.shared.consentGranted(true);
  OneSignal.shared.promptUserForPushNotificationPermission();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: child!,
          );
        },
        title: mAppName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: SplashScreen(),
        locale: Locale(appStore.selectedLanguage),
        supportedLocales: LanguageDataModel.languageLocales(),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        localeResolutionCallback: (locale, supportedLocales) => locale,
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
