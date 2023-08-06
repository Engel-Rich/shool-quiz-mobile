import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/screens/EarnPointScreen.dart';
import '../main.dart';
import '../models/QuestionModel.dart';
import '../screens/ContainerProfileComplette.dart';
import '../screens/DailyQuizDescriptionScreen.dart';
import '../screens/QuizQuestionsScreen.dart';
import '../screens/RandomQuizScreen.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/images.dart';
import '../utils/widgets.dart';

class PlayZoneComponent extends StatefulWidget {
  final String? name;
  final String? image;
  final int? index;

  PlayZoneComponent({this.name, this.image, this.index});

  @override
  State<PlayZoneComponent> createState() => _PlayZoneComponentState();
}

class _PlayZoneComponentState extends State<PlayZoneComponent> {
  List<QuestionModel> queList = [];

  bool profileIsnotComplette() => (appStore.userEmail!.trim().isEmpty ||
      appStore.userName!.trim().isEmpty ||
      appStore.userclasse!.trim().isEmpty ||
      appStore.userAge!.trim().isEmpty);

  @override
  void initState() {
    super.initState();
  }

  PersistentBottomSheetController<dynamic> bottomshetUncompletteProfile(
      BuildContext context) {
    return showBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ContainerUncompletteProfille(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (profileIsnotComplette()) {
          bottomshetUncompletteProfile(context);
        } else {
          print("points" + getIntAsync(USER_POINTS).toString());
          if (getIntAsync(USER_POINTS) > 0) {
            if (widget.index == 0) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DailyQuizDescriptionScreen()));
            } else if (widget.index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RandomQuizScreen()));
            } else if (widget.index == 2) {
              showConfirmDialogCustom(
                context,
                title: appStore.translate('lbl_do_play_quiz'),
                positiveText: appStore.translate('lbl_yes'),
                negativeText: appStore.translate('lbl_no'),
                customCenterWidget: customCenterDialogImage(image: Quiz_icon),
                primaryColor: colorPrimary,
                onAccept: (p0) async {
                  questionService
                      .questionByType("truefalse")
                      .then((value) async {
                    value.forEach((element) {
                      queList.add(element);
                      setState(() {});
                    });
                    await QuizQuestionsScreen(
                            quizType: QuizTypeTrueFalse,
                            queList: queList,
                            time: 5)
                        .launch(context);
                  });
                },
              );
            } else {
              showConfirmDialogCustom(
                context,
                primaryColor: colorPrimary,
                title: appStore.translate('lbl_do_play_quiz'),
                positiveText: appStore.translate('lbl_yes'),
                negativeText: appStore.translate('lbl_no'),
                customCenterWidget: customCenterDialogImage(image: Quiz_icon),
                onAccept: (p0) async {
                  questionService
                      .questionByType("GuessWord")
                      .then((value) async {
                    value.forEach((element) {
                      queList.add(element);
                      setState(() {});
                    });
                    await QuizQuestionsScreen(
                            quizType: QuizTypeGuessWord,
                            queList: queList,
                            time: 5)
                        .launch(context);
                  });
                },
              );
            }
          } else {
            showConfirmDialogCustom(
              context,
              title: appStore.translate('lbl_earn_points'),
              subTitle: appStore.translate('lbl_minimum_requied_points') +
                  " " +
                  POINT_PER_QUESTION.toString(),
              positiveText: appStore.translate('lbl_yes'),
              negativeText: appStore.translate('lbl_no'),
              primaryColor: colorPrimary,
              customCenterWidget: customCenterDialogImage(image: Quiz_icon),
              onAccept: (p0) {},
            ).then((value) {
              if (value ?? false) {
                EarnPointScreen().launch(context);
              }
            });
          }
        }
      },
      child: Container(
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
            Text(widget.name!,
                style: boldTextStyle()
                    .copyWith(color: Colors.white, fontSize: 18)),
            6.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(Play_icon, height: 20, width: 20),
                    6.width,
                    SizedBox(
                        width: ((context.width() - 48) / 2) - 104,
                        child: Text(appStore.translate('lbl_playNow'),
                            style: primaryTextStyle()
                                .copyWith(color: Colors.white, fontSize: 15),
                            softWrap: true))
                  ],
                ),
                Image.asset(widget.image!, width: 40, height: 40)
              ],
            )
          ],
        ),
      ),
    );
  }
}
