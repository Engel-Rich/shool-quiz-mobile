import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/screens/EditUserDetailScreen.dart';
import 'package:quizapp_flutter/screens/RegisterScreen.dart';
import 'package:quizapp_flutter/utils/colors.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/utils/images.dart';
import 'package:quizapp_flutter/utils/widgets.dart';

import '../components/ForgotPasswordDialog.dart';
import '../components/OTPLoginComponent.dart';
import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  static String tag = '/LoginScreen';

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController emailController =
      TextEditingController(text: kReleaseMode ? '' : '');
  TextEditingController passController =
      TextEditingController(text: kReleaseMode ? '' : '');

  FocusNode emailFocus = FocusNode();
  FocusNode passFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light),
    );
    if (getBoolAsync(IS_REMEMBERED) == true) {
      emailController.text = getStringAsync(USER_EMAIL);
      passController.text = getStringAsync(PASSWORD);
    }
  }

  Future<void> loginWithEmail() async {
    hideKeyboard(context);
    if (formKey.currentState!.validate()) {
      appStore.setLoading(true);
      authService
          .signInWithEmailPassword(
              email: emailController.text, password: passController.text)
          .then((value) {
        appStore.setLoading(false);
        HomeScreen().launch(context, isNewTask: true);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }
  }

  Future<void> loginWithGoogle() async {
    appStore.setLoading(true);

    await authService.signInWithGoogle().then(
      (value) {
        appStore.setLoading(false);

        print("User age data: ${getStringAsync(USER_AGE)}");
        print("User Model final : ${value.toJson()}");

        if (getStringAsync(USER_AGE).isNotEmpty) {
          HomeScreen().launch(context);
        } else {
          EditUserDetailScreen(isFromGoogle: true).launch(context);
        }
      },
    ).catchError(
      (e) {
        appStore.setLoading(false);
        toast(e.toString());
        throw e;
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    appStore.setAppLocalization(context);
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset(LoginPageImage,
                        height: context.height() * 0.38,
                        width: context.width(),
                        fit: BoxFit.fill),
                    Positioned(
                      top: 64,
                      left: 16,
                      child: Image.asset(LoginPageLogo, width: 80, height: 80),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(appStore.translate('lbl_sign_in'),
                              style: boldTextStyle(color: white, size: 30)),
                          8.height,
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Text(appStore.translate('lbl_do_not_have_account'), style: primaryTextStyle(color: white)),
                          //     4.width,
                          //     Text(appStore.translate('lbl_sign_up'), style: boldTextStyle(color: white, size: 18)).onTap(
                          //       () {
                          //         RegisterScreen().launch(context);
                          //       },
                          //     ),
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
                30.height,
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appStore.translate('lbl_email_id'),
                              style: primaryTextStyle())
                          .paddingOnly(left: 16, right: 16),
                      8.height,
                      AppTextField(
                        controller: emailController,
                        textFieldType: TextFieldType.OTHER,
                        focus: emailFocus,
                        nextFocus: passFocus,
                        decoration: inputDecoration(
                            hintText: appStore.translate('lbl_email_hint')),
                      ).paddingOnly(left: 16, right: 16),
                      16.height,
                      Text(appStore.translate('lbl_password'),
                              style: primaryTextStyle())
                          .paddingOnly(left: 16, right: 16),
                      8.height,
                      AppTextField(
                        controller: passController,
                        focus: passFocus,
                        textFieldType: TextFieldType.PASSWORD,
                        decoration: inputDecoration(
                            hintText: appStore.translate('lbl_password_hint')),
                      ).paddingOnly(left: 16, right: 16),
                      8.height,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  activeColor: colorPrimary,
                                  value: getBoolAsync(IS_REMEMBERED,
                                      defaultValue: false),
                                  onChanged: (v) async {
                                    await setValue(IS_REMEMBERED, v);
                                    setState(() {});
                                  },
                                ).paddingOnly(left: 6),
                                Text(appStore.translate('lbl_rememberMe'),
                                        style: primaryTextStyle())
                                    .onTap(() async {
                                  await setValue(IS_REMEMBERED,
                                      !getBoolAsync(IS_REMEMBERED));
                                  setState(() {});
                                },
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent),
                              ],
                            ),
                            Text(
                                    '    ' +
                                        appStore
                                            .translate('lbl_forgotPassword') +
                                        ' ?',
                                    style: primaryTextStyle())
                                .onTap(() async {
                              hideKeyboard(context);
                              await showInDialog(context,
                                  builder: (_) => ForgotPasswordDialog());
                            },
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors
                                        .transparent).paddingOnly(right: 16)
                          ],
                        ),
                      ),
                      30.height,
                      gradientButton(
                              text: appStore.translate('lbl_sign_in'),
                              onTap: loginWithEmail,
                              context: context,
                              isFullWidth: true)
                          .paddingOnly(left: 16, right: 16),
                      16.height,
                      Container(
                        height: 50,
                        padding: EdgeInsets.only(
                            top: defaultRadius, bottom: defaultRadius),
                        width: context.width(),
                        child: Text(appStore.translate('lbl_sign_up'),
                                style: boldTextStyle())
                            .center(),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          // border: Border.all(color: appStore.isDarkMode ? scaffoldColor : Colors.black),
                          borderRadius: BorderRadius.circular(defaultRadius),
                        ),
                      ).onTap(() {
                        RegisterScreen().launch(context);
                      },
                          highlightColor: Colors.transparent,
                          splashColor: Colors
                              .transparent).paddingOnly(left: 16, right: 16),
                      30.height,
                      Row(
                        children: [
                          Divider(thickness: 2).expand(),
                          8.width,
                          Text(appStore.translate('lbl_or'),
                              style: secondaryTextStyle()),
                          8.width,
                          Divider(thickness: 2).expand(),
                        ],
                      ).paddingOnly(left: 16, right: 16),
                      30.height,
                      Container(
                        height: 50,
                        padding: EdgeInsets.only(
                            top: defaultRadius, bottom: defaultRadius),
                        width: context.width(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GoogleLogoWidget(),
                            16.width,
                            Text(appStore.translate('lbl_login_with_google'),
                                    style: boldTextStyle())
                                .center(),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(defaultRadius),
                        ),
                      ).onTap(() {
                        try {
                          loginWithGoogle();
                        } catch (e) {
                          print(e);
                        }
                      },
                          highlightColor: Colors.transparent,
                          splashColor: Colors
                              .transparent).paddingOnly(left: 16, right: 16),
                      16.height,
                      Container(
                        height: 50,
                        padding: EdgeInsets.only(
                            top: defaultRadius, bottom: defaultRadius),
                        width: context.width(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone, size: 28),
                            16.width,
                            Text(appStore.translate('lbl_phoneLogin'),
                                    style:
                                        boldTextStyle().copyWith(fontSize: 15))
                                .center(),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(defaultRadius),
                        ),
                      ).onTap(() async {
                        hideKeyboard(context);
                        await showDialog(
                                context: context,
                                builder: (context) => OTPDialog(),
                                barrierDismissible: false)
                            .catchError((e) {
                          toast(e.toString());
                        });
                      },
                          highlightColor: Colors.transparent,
                          splashColor: Colors
                              .transparent).paddingOnly(left: 16, right: 16),
                    ],
                  ),
                ),
                16.height,
              ],
            ),
          ),
          Observer(builder: (context) => Loader().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
