import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/models/QuizModel.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/utils/strings.dart';

class QuizDescriptionComponent extends StatefulWidget {
  static String tag = '/QuizDescriptionComponent';

  final QuizModel? quizModel;

  QuizDescriptionComponent({this.quizModel});

  @override
  QuizDescriptionComponentState createState() =>
      QuizDescriptionComponentState();
}

class QuizDescriptionComponentState extends State<QuizDescriptionComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            widget.quizModel!.imageUrl!,
            width: context.width(),
            height: context.height() * 0.40,
            fit: BoxFit.fill,
          ).cornerRadiusWithClipRRectOnly(
              bottomLeft: defaultRadius.toInt(),
              bottomRight: defaultRadius.toInt()),
          30.height,
          Text(appStore.translate('lbl_about_this_quiz'),
                  style: boldTextStyle().copyWith(fontSize: 25))
              .paddingOnly(left: 16, right: 16),
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            width: context.width(),
            decoration: boxDecorationWithRoundedCorners(
              borderRadius: BorderRadius.circular(defaultRadius),
              border: Border.all(color: grey.withOpacity(0.3)),
              backgroundColor: Theme.of(context).cardColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appStore.translate('lbl_quiz_title'),
                    style: boldTextStyle().copyWith(fontSize: 20)),
                8.height,
                Text(widget.quizModel!.quizTitle.validate(),
                    style: primaryTextStyle()),
                8.height,
                Divider(color: grey.withOpacity(0.3), thickness: 1),
                8.height,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lbl_quiz_description,
                        style: boldTextStyle().copyWith(fontSize: 20)),
                    8.height,
                    Text(widget.quizModel!.description.validate(),
                        style: primaryTextStyle()),
                    8.height,
                    Divider(color: grey.withOpacity(0.3), thickness: 1),
                    8.height,
                  ],
                ).visible(widget.quizModel!.description.validate().isNotEmpty),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(appStore.translate('lbl_no_of_questions') + ":",
                        style: boldTextStyle().copyWith(fontSize: 17)),
                    4.width,
                    Text(widget.quizModel!.questionRef!.length.toString(),
                            softWrap: true, style: primaryTextStyle())
                        .expand(),
                  ],
                ),
                8.height,
                Divider(color: grey.withOpacity(0.3), thickness: 1),
                8.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(appStore.translate('lbl_quiz_duration'),
                        style: boldTextStyle().copyWith(fontSize: 17)),
                    4.width,
                    Text(
                            widget.quizModel!.quizTime.validate().toString() +
                                " minutes",
                            softWrap: true,
                            style: primaryTextStyle())
                        .expand(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
