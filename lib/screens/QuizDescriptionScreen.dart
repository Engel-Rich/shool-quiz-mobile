import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/components/QuizDescriptionComponent.dart';
import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/models/QuizModel.dart';
import 'package:quizapp_flutter/screens/QuizQuestionsScreen.dart';
import 'package:quizapp_flutter/utils/colors.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/utils/widgets.dart';

import '../utils/images.dart';
import 'EarnPointScreen.dart';

class QuizDescriptionScreen extends StatefulWidget {
  static String tag = '/QuizDescriptionScreen';

  final QuizModel? quizModel;

  QuizDescriptionScreen({this.quizModel});

  @override
  QuizDescriptionScreenState createState() => QuizDescriptionScreenState();
}

class QuizDescriptionScreenState extends State<QuizDescriptionScreen> {
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuizDescriptionComponent(quizModel: widget.quizModel),
                16.height,
                gradientButton(
                  isFullWidth: true,
                  text: appStore.translate('lbl_start'),
                  context: context,
                  onTap: () {
                    if (getIntAsync(USER_POINTS) > 0) {
                      showConfirmDialogCustom(
                        context,
                        title: appStore.translate('lbl_do_play_quiz'),
                        positiveText: appStore.translate('lbl_yes'),
                        negativeText: appStore.translate('lbl_no'),
                        primaryColor: colorPrimary,
                        customCenterWidget: customCenterDialogImage(image: Quiz_icon),
                        onAccept: (p0) {},
                      ).then((value) {
                        if (value ?? false) {
                          QuizQuestionsScreen(quizData: widget.quizModel, quizType: QuizTypeCategory).launch(context);
                        }
                      });
                    } else {
                      showConfirmDialogCustom(
                        context,
                        title: appStore.translate('lbl_earn_points'),
                        subTitle:appStore.translate('lbl_minimum_requied_points')+" " +POINT_PER_QUESTION.toString(),
                        positiveText: appStore.translate('lbl_yes'),
                        negativeText: appStore.translate('lbl_no'),
                        primaryColor: colorPrimary,
                        customCenterWidget: customCenterDialogImage(image: Quiz_icon),
                        onAccept: (p0) {
                        },
                      ).then((value){
                        if (value ?? false) {
                          EarnPointScreen().launch(context);
                        }
                      });
                    }
                  },
                ).paddingOnly(left: 16, right: 16).center(),
                16.height,
              ],
            ),
          ),
          Positioned(
            right: 16,
            top: height + 4,
            child: CircleAvatar(
              child: Icon(Icons.close, color: black),
              backgroundColor: white,
              radius: 15,
            ).onTap(
              () {
                finish(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
