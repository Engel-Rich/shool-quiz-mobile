import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quizapp_flutter/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../components/AppBarComponent.dart';
import '../utils/constants.dart';
import '../utils/images.dart';
import '../utils/widgets.dart';
import 'AboutUsScreen.dart';
import 'LoginScreen.dart';

class HelpDeskScreen extends StatefulWidget {
  @override
  HelpDeskScreenState createState() => HelpDeskScreenState();
}

class HelpDeskScreenState extends State<HelpDeskScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void logout() {
    authService.logout().then((value) {
      LoginScreen().launch(context, isNewTask: true);
    }).catchError((e) {
      toast(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    appStore.setAppLocalization(context);

    return Scaffold(
      appBar: appBarComponent(context: context, title: "Help Desk"),
      body: Theme(
        data: ThemeData(highlightColor: Colors.transparent, splashFactory: NoSplash.splashFactory),
        child: Column(
          children: [
            SettingItemWidget(
              padding: EdgeInsets.all(0),
              leading: iconWidget(AboutUsImage),
              title: appStore.translate('lbl_about_us'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUsScreen()));
              },
            ),
            Divider(color: lightGray),
            8.height,
            SettingItemWidget(
              padding: EdgeInsets.all(0),
              leading: iconWidget(RateUsImage),
              title: appStore.translate('lbl_rate_us'),
              onTap: () {
                PackageInfo.fromPlatform().then(
                  (value) async {
                    launchUrl(Uri.parse('$playStoreBaseURL${value.packageName}'));
                  },
                );
              },
            ),
            Divider(color: lightGray),
            8.height,
            SettingItemWidget(
              padding: EdgeInsets.all(0),
              leading: iconWidget(PrivacyPolicyImage),
              title: appStore.translate('lbl_privacy_policy'),
              onTap: () {
                if (getStringAsync(PRIVACY_POLICY_PREF).isEmptyOrNull) {
                  toast("Url is Empty");
                } else
                  launchUrlString('${getStringAsync(PRIVACY_POLICY_PREF)}');
              },
            ),
            Divider(color: lightGray),
            8.height,
            SettingItemWidget(
              padding: EdgeInsets.all(0),
              leading: iconWidget(TermsAndConditionsImage),
              title: appStore.translate('lbl_terms_and_conditions'),
              onTap: () {
                if (!getStringAsync(TERMS_AND_CONDITION_PREF).isEmptyOrNull)
                  launchUrlString('${getStringAsync(TERMS_AND_CONDITION_PREF)}');
                else
                  toast('Url is Empty');
              },
            ),
          ],
        ).paddingAll(16),
      ),
    );
  }
}
