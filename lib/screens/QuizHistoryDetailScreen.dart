import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/main.dart';
import '../components/AppBarComponent.dart';
import 'package:quizapp_flutter/utils/images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizapp_flutter/utils/ModelKeys.dart';
import 'package:quizapp_flutter/models/QuestionModel.dart';
import 'package:quizapp_flutter/models/QuizHistoryModel.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as mbs;
// import 'package:google_fonts/google_fonts.dart';
// import '../utils/constants.dart';

class QuizHistoryDetailScreen extends StatefulWidget {
  static String tag = '/QuizHistoryDetailScreen';

  final QuizHistoryModel? quizHistoryData;

  QuizHistoryDetailScreen({this.quizHistoryData});

  @override
  QuizHistoryDetailScreenState createState() => QuizHistoryDetailScreenState();
}

class QuizHistoryDetailScreenState extends State<QuizHistoryDetailScreen> {
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
    return Scaffold(
      appBar: appBarComponent(context: context, title: ''),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.quizHistoryData!.quizTitle}',
                        style: boldTextStyle(size: 20),
                      ),
                      16.height,
                      Text(
                          '${appStore.translate('lbl_total_questions')}: ${widget.quizHistoryData!.totalQuestion}',
                          style: boldTextStyle(size: 20)),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    children: [
                      Image.asset(rightIconImage, height: 36, width: 36),
                      8.width,
                      Text('${widget.quizHistoryData!.rightQuestion}',
                          style: boldTextStyle(size: 20)),
                      16.width,
                      SizedBox(height: 10),
                      Image.asset(wrongIconImage, height: 36, width: 36),
                      8.width,
                      Text(
                          '${widget.quizHistoryData!.totalQuestion! - widget.quizHistoryData!.rightQuestion!}',
                          style: boldTextStyle(size: 20)),
                    ],
                  ),
                ),
              ],
            ),
            16.height,
            Divider(),
            16.height,
            ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: widget.quizHistoryData!.quizAnswers!.length,
              itemBuilder: (context, index) {
                QuizAnswer mData = widget.quizHistoryData!.quizAnswers![index];
                return Container(
                  decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: Theme.of(context).cardColor),
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${index + 1}.', style: boldTextStyle()),
                      16.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${mData.question}',
                              softWrap: true, style: primaryTextStyle()),
                          16.height,
                          Container(
                            padding: EdgeInsets.all(8),
                            width: context.width(),
                            decoration: boxDecorationWithRoundedCorners(
                                backgroundColor:
                                    mData.correctAnswer == mData.answers
                                        ? Colors.green.shade500
                                        : Colors.red.shade500),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(appStore.translate('lbl_answer') + ":",
                                    style: boldTextStyle(color: Colors.white)),
                                8.height,
                                Text('${mData.answers}',
                                    softWrap: true,
                                    style:
                                        primaryTextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                          16.height,
                          Container(
                            padding: EdgeInsets.all(8),
                            width: context.width(),
                            decoration: boxDecorationWithRoundedCorners(
                                backgroundColor: Theme.of(context).cardColor),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    appStore.translate('lbl_correct_answer') +
                                        ':',
                                    style: boldTextStyle()),
                                8.height,
                                Text('${mData.correctAnswer}',
                                    softWrap: true, style: primaryTextStyle()),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    onPressed: () {
                                      mbs.showMaterialModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(10))),
                                          context: context,
                                          builder: (context) => Scaffold(
                                                appBar: AppBar(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      10))),
                                                  leading: InkWell(
                                                    onTap: () =>
                                                        Navigator.pop(context),
                                                    child: Icon(
                                                      Icons
                                                          .arrow_circle_down_outlined,
                                                      size: 40,
                                                    ),
                                                  ),
                                                ),
                                                body: SingleChildScrollView(
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 20),
                                                        Text(
                                                            appStore.translate(
                                                                'lbl_questions'),
                                                            style: boldTextStyle()
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20)),
                                                        SizedBox(height: 15),
                                                        Text(
                                                          mData.question ?? "",
                                                          style:
                                                              primaryTextStyle()
                                                                  .copyWith(
                                                                      fontSize:
                                                                          17),
                                                        ),
                                                        SizedBox(height: 20),
                                                        Text(
                                                          appStore.translate(
                                                              'lbl_correct_answer'),
                                                          style: boldTextStyle()
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20),
                                                        ),
                                                        SizedBox(height: 15),
                                                        Text(
                                                          mData.correctAnswer ??
                                                              "",
                                                          style:
                                                              primaryTextStyle()
                                                                  .copyWith(
                                                                      fontSize:
                                                                          17),
                                                        ),
                                                        SizedBox(height: 20),
                                                        Text(
                                                          "Notes : ",
                                                          style: boldTextStyle()
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20),
                                                        ),
                                                        SizedBox(height: 15),
                                                        FutureBuilder<
                                                            QuestionModel>(
                                                          future: FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'question')
                                                              .where(
                                                                  QuestionKeys
                                                                      .optionList,
                                                                  arrayContainsAny: [
                                                                    mData
                                                                        .question,
                                                                    mData
                                                                        .answers
                                                                  ])
                                                              .where(
                                                                  QuestionKeys
                                                                      .correctAnswer,
                                                                  isEqualTo: mData
                                                                      .correctAnswer)
                                                              .get()
                                                              .then((value) {
                                                                print(
                                                                    'valeur : ${value.docs}');
                                                                return value
                                                                    .docs
                                                                    .map((e) {
                                                                      print(
                                                                          'object: ${e.data()}');
                                                                      return QuestionModel
                                                                          .fromJson(
                                                                              e.data());
                                                                    })
                                                                    .toList()
                                                                    .first;
                                                              }),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                    .connectionState !=
                                                                ConnectionState
                                                                    .done) {
                                                              return Loader();
                                                            } else {
                                                              if (!snapshot
                                                                      .hasError ||
                                                                  snapshot
                                                                      .hasData ||
                                                                  snapshot.data !=
                                                                      null) {
                                                                print(snapshot
                                                                    .data);
                                                                return Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      snapshot.data
                                                                              ?.note ??
                                                                          "Note empty",
                                                                      style: primaryTextStyle().copyWith(
                                                                          fontSize:
                                                                              17),
                                                                    )
                                                                  ],
                                                                );
                                                              } else {
                                                                return snapshot
                                                                        .hasError
                                                                    ? Text(
                                                                        snapshot.error?.toString() ??
                                                                            'Something went wrong',
                                                                        style:
                                                                            primaryTextStyle(),
                                                                      )
                                                                    : Loader();
                                                              }
                                                            }
                                                          },
                                                        )
                                                      ],
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                    ),
                                                  ),
                                                ),
                                              ));
                                    },
                                    icon: Icon(
                                      Icons.arrow_circle_up,
                                      size: 40,
                                      color: Colors.amber,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ).expand(),
                    ],
                  ),
                );
              },
            ),
          ],
        ).paddingOnly(left: 16, right: 16),
      ),
    );
  }
}
