import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/models/QuestionModel.dart';
import 'package:quizapp_flutter/utils/colors.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/utils/widgets.dart';
import 'package:shake_animation_widget/shake_animation_widget.dart';

class QuizQuestionComponent extends StatefulWidget {
  static String tag = '/QuizQuestionComponent1';

  final QuestionModel? question;
  final bool? isShow;

  QuizQuestionComponent({this.question, this.isShow});

  @override
  QuizQuestionComponentState createState() => QuizQuestionComponentState();
}

class QuizQuestionComponentState extends State<QuizQuestionComponent> {
  List<String> ans = [];
  List<String> optionList = [];
  TextEditingController textEditingController = TextEditingController();
  final List<ShakeAnimationController> _shakeAnimationController =
      List.generate(5, (index) => ShakeAnimationController());

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (widget.question!.answer == null) {
      textEditingController.text = '';
    } else {
      textEditingController.text = widget.question!.answer!;
    }

    //
    // widget.question!.optionList!.forEach((element) {
    //   ans.add(element);
    // });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    ans.clear();
    widget.question!.optionList!.forEach((element) {
      ans.add(element);
    });
    if (widget.isShow == false) {
      ans.clear();
      widget.question!.optionList!.forEach((element) {
        if (element != widget.question!.correctAnswer) {
          optionList.add(element);
        }
      });
      ans.add(widget.question!.correctAnswer!);
      ans.add(optionList.first);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${widget.question!.addQuestion}',
            style: boldTextStyle(size: 20), textAlign: TextAlign.center),
        30.height,
        (widget.question!.image != null && widget.question!.image!.isNotEmpty)
            ? cachedImage(widget.question!.image!.validate(),
                height: 150, fit: BoxFit.contain, width: context.width())
            : Container(),
        16.height,
        Column(
          children: List.generate(
            ans.length,
            (index) {
              String mData = ans[index];
              return ShakeAnimationWidget(
                shakeAnimationController: _shakeAnimationController[index],
                isForward: false,
                child: Container(
                  padding: EdgeInsets.all(16),
                  width: context.width(),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor:
                        widget.question!.selectedOptionIndex == index
                            ? colorPrimary.withOpacity(0.7)
                            : appStore.isDarkMode
                                ? Colors.grey.withOpacity(0.2)
                                : scaffoldColor,
                  ),
                  child: Text('$mData',
                      style: primaryTextStyle(
                          color: widget.question!.selectedOptionIndex == index
                              ? Colors.white
                              : Colors.black)),
                ).onTap(
                  () async {
                    setState(
                      () {
                        widget.question!.selectedOptionIndex = index;
                        log(widget.question!.optionList![index]);
                        widget.question!.answer =
                            widget.question!.optionList![index];
                        LiveStream()
                            .emit(answerQuestionStream, widget.question);
                        _shakeAnimationController[index].start();
                      },
                    );
                    await Duration(milliseconds: 600).delay;
                    _shakeAnimationController[index].stop();
                  },
                ),
              );
            },
          ),
        ),
        SizedBox(
          child: AppTextField(
            controller: textEditingController,
            textFieldType: TextFieldType.NAME,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (p0) {
              setState(
                () {
                  widget.question!.answer = p0.toUpperCase();
                  LiveStream().emit(answerQuestionStream, widget.question);
                },
              );
            },
            onFieldSubmitted: (p0) {
              setState(
                () {
                  widget.question!.answer = p0.toUpperCase();
                  LiveStream().emit(answerQuestionStream, widget.question);
                },
              );
            },
          ),
        ).visible(widget.question!.questionType == QuestionTypeGuessWord)
      ],
    );
  }
}
