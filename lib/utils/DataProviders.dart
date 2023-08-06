import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/models/Model.dart';
import 'package:quizapp_flutter/screens/DailyQuizDescriptionScreen.dart';
import 'package:quizapp_flutter/screens/EarnPointScreen.dart';
import 'package:quizapp_flutter/screens/MyQuizHistoryScreen.dart';
import 'package:quizapp_flutter/screens/QuizCategoryScreen.dart';
import 'package:quizapp_flutter/screens/SelfChallengeFormScreen.dart';
import 'package:quizapp_flutter/screens/SettingScreen.dart';
import 'package:quizapp_flutter/utils/ModelKeys.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/utils/images.dart';
import '../screens/HelpDeskScreen.dart';
import '../screens/LeaderBoardScreen.dart';
import '../screens/ReferAndEarnScreen.dart';

String description =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";

List<DrawerItemModel> getDrawerItems() {
  List<DrawerItemModel> drawerItems = [];
  drawerItems.add(DrawerItemModel(name: appStore.translate('lbl_home'), image: HomeImage));
  // drawerItems.add(DrawerItemModel(name: appStore.translate('lbl_profile'), image: ProfileImage, widget: ProfileScreen()));
  drawerItems.add(DrawerItemModel(name: appStore.translate('lbl_leaderboard'), image: leaderBoard,widget: LeadingBoardScreen(isContest: false)));
  drawerItems.add(DrawerItemModel(name: appStore.translate('lbl_daily_quiz'), image: DailyQuizImage, widget: DailyQuizDescriptionScreen()));
  drawerItems.add(DrawerItemModel(name: appStore.translate('lbl_quiz_category'), image: QuizCategoryImage, widget: QuizCategoryScreen()));
  drawerItems.add(DrawerItemModel(name: appStore.translate('lbl_self_challenge'), image: SelfChallengeImage, widget: SelfChallengeFormScreen()));
  drawerItems.add(DrawerItemModel(name: appStore.translate('lbl_my_quiz_history'), image: QuizHistoryImage, widget: MyQuizHistoryScreen()));
  if (!getBoolAsync(DISABLE_AD)) drawerItems.add(DrawerItemModel(name: appStore.translate('lbl_earn_points'), image: EarnPointsImage, widget: EarnPointScreen()));
  drawerItems.add(DrawerItemModel(name: appStore.translate('lbl_refer_earn'), widget: ReferAndEarnScreen(), image:referEarn));
  drawerItems.add(DrawerItemModel(name: appStore.translate('lbl_setting'), widget: SettingScreen(), image: SettingImage));
  drawerItems.add(DrawerItemModel(name:appStore.translate('lbl_help_desk'), widget: HelpDeskScreen(), image: helpDesk));
  drawerItems.add(DrawerItemModel(name: appStore.translate('lbl_delete_account'), image: delete));
  drawerItems.add(DrawerItemModel(name: appStore.translate('lbl_logout'), image: LogoutImage));
  return drawerItems;
}

List<WalkThroughItemModel> getWalkThroughItems() {
  List<WalkThroughItemModel> walkThroughItems = [];
  walkThroughItems.add(
    WalkThroughItemModel(
      image: WalkThroughImage1,
      title: "APPRENDRE TOUT EN S'AMUSANT/",
      subTitle: "School Quiz vous propose une façon unique de l'apprentissages la plus additive",
    ),
  );
  walkThroughItems.add(
    WalkThroughItemModel(
      image: WalkThroughImage2,
      title: 'PROGRAMME ÉDUCATIF ET CULTURE GÉNÉRALE',
      subTitle: 'School Quiz vous propose un contenus basé sur le programme éducatif en vigueur et sur une culture général',
    ),
  );
  walkThroughItems.add(
    WalkThroughItemModel(
      image: WalkThroughImage3,
      title:"CONTROLE DE L'ÉVOLUTION",
      subTitle: 'School Quiz vous permet de controler votre évolution en vous montrant votre niveau tout au long de votre apprentissage',
    ),
  );
  walkThroughItems.add(
    WalkThroughItemModel(
      image: WalkThroughImage4,
      title:"ACCROÎTRE RAPIDEMENT SES CONNAISSANCES SANS EFFORT",
      subTitle: 'School Quiz permet la croissance exponentielle du niveau de connaissance en un temps record',
    ),
  );
  return walkThroughItems;
}

List<DrawerItemModel> getQuestionTypeList() {
  List<DrawerItemModel> questionTypeList = [];
  questionTypeList.add(DrawerItemModel(image: OptionQuiz, name: QuestionTypeKeys.options));
  questionTypeList.add(DrawerItemModel(image: TruFalseQuiz, name: QuestionTypeKeys.trueFalse));

  return questionTypeList;
}

List<AddAnswerModel> getAddAnswerList() {
  List<AddAnswerModel> addAnswerList = [];
  addAnswerList.add(AddAnswerModel(name: '+  Add Answer'));
  addAnswerList.add(AddAnswerModel(name: '+  Add Answer'));
  addAnswerList.add(AddAnswerModel(name: '+  Add Answer'));
  addAnswerList.add(AddAnswerModel(name: '+  Add Answer'));

  return addAnswerList;
}

List<AddAnswerModel> getTrueFalseAddAnswerList() {
  List<AddAnswerModel> addTrueFalseAnswerList = [];
  addTrueFalseAnswerList.add(AddAnswerModel(name: 'True'));
  addTrueFalseAnswerList.add(AddAnswerModel(name: 'False'));
  return addTrueFalseAnswerList;
}


