import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/models/QuestionModel.dart';
import 'package:quizapp_flutter/screens/QuizQuestionsScreen.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/utils/widgets.dart';

import '../components/AppBarComponent.dart';

class RandomQuizScreen extends StatefulWidget {
  static String tag = '/RandomQuizScreen';

  @override
  RandomQuizScreenState createState() => RandomQuizScreenState();
}

class RandomQuizScreenState extends State<RandomQuizScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController noOfQueController = TextEditingController();

  FocusNode noOfQueFocus = FocusNode();

  int? selectedTime;
  int? totalNoQuestion;
  String? categoryId;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    questionService.questionList().then((value) {
      totalNoQuestion = value.length;
      setState(() {});
    });
  }

  createQuiz() {
    if (formKey.currentState!.validate()) {
      hideKeyboard(context);
      appStore.setLoading(true);
      questionService.questionList().then(
        (value) async {
          appStore.setLoading(false);
          if (value.isNotEmpty) {
            List<QuestionModel> queList = [];
            int queCount;
            if (int.tryParse(noOfQueController.text.validate())! > value.length) {
              queCount = value.length;
              queList = value;
            } else {
              queCount = int.tryParse(noOfQueController.text.validate())!;
              QuestionModel getRandomElement<QuestionModel>(List<QuestionModel> value) {
                final random = new Random();
                var i = random.nextInt(value.length);
                return value[i];
              }

              for (var i = 0; queList.length < queCount; i++) {
                var randomItem = getRandomElement(value);
                if (!queList.contains(randomItem)) {
                  queList.add(randomItem);
                }
              }
            }
            await QuizQuestionsScreen(quizType: QuizTypeRandom, queList: queList, time: selectedTime).launch(context);
          } else {
            toast(appStore.translate('lbl_no_questions_found_category'));
          }
        },
      ).catchError(
        (e) {
          appStore.setLoading(false);
          throw e;
        },
      );
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarComponent(context: context, title: "Random Quiz"),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  Text(appStore.translate('lbl_random_quiz'), style: secondaryTextStyle(), textAlign: TextAlign.center).center(),
                  30.height,
                  Text(appStore.translate('lbl_no_of_questions'), style: primaryTextStyle()),
                  8.height,
                  AppTextField(
                    controller: noOfQueController,
                    textFieldType: TextFieldType.PHONE,
                    focus: noOfQueFocus,
                    decoration: inputDecoration(hintText: appStore.translate('lbl_hint_no_ques')),
                    maxLength: 3,
                    isValidationRequired: true,
                    errorThisFieldRequired: 'This field is required',
                    onChanged: (p0) {
                      if (p0.toInt() > totalNoQuestion!) {
                        noOfQueController.text = totalNoQuestion!.toString();
                        toast("Total No Of Question $totalNoQuestion");
                      }
                    },

                    validator: (value) {
                      log(value);
                      if (value.toInt() > totalNoQuestion!) {
                        return "Total No Of Question $totalNoQuestion";
                      } else if (value.isEmptyOrNull)
                        return 'This field is required';
                      else
                        return null;
                    },
                  ),
                  16.height,
                  Text(appStore.translate('lbl_time'), style: primaryTextStyle()),
                  8.height,
                  DropdownButtonFormField(
                    hint: Text(appStore.translate('lbl_select_time'), style: secondaryTextStyle()),
                    value: selectedTime,
                    dropdownColor: Theme.of(context).cardColor,
                    decoration: inputDecoration(),
                    items: List.generate(12, (index) {
                      return DropdownMenuItem(
                        value: (index + 1) * 5,
                        child: Text('${(index + 1) * 5} Minutes', style: primaryTextStyle()),
                      );
                    }),
                    onChanged: (dynamic value) {
                      selectedTime = value;
                    },
                    validator: (dynamic value) {
                      return value == null ? 'This field is required' : null;
                    },
                  ),
                  30.height,
                  gradientButton(
                      text: appStore.translate('lbl_ok'),
                      onTap: () {
                        createQuiz();
                      },
                      context: context,
                      isFullWidth: true),
                ],
              ).paddingOnly(left: 16, right: 16),
            ),
          ),
          Observer(builder: (context) => Loader().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
