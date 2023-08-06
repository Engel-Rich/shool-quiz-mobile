import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/components/QuizCategoryComponent.dart';
import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/models/CategoryModel.dart';
import 'package:quizapp_flutter/screens/QuizScreen.dart';
import 'package:quizapp_flutter/utils/widgets.dart';

import '../components/AppBarComponent.dart';
import 'ContainerProfileComplette.dart';

class QuizCategoryScreen extends StatefulWidget {
  static String tag = '/QuizCategoryScreen';

  @override
  QuizCategoryScreenState createState() => QuizCategoryScreenState();
}

class QuizCategoryScreenState extends State<QuizCategoryScreen> {
  List<CategoryModel> categoryItems = [];
  bool isLoading = false;
  bool profileIsnotComplette() => (appStore.userEmail!.trim().isEmpty ||
      appStore.userName!.trim().isEmpty ||
      appStore.userAge!.trim().isEmpty);

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
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
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarComponent(
          context: context, title: appStore.translate('lbl_quiz_category')),
      body: StreamBuilder(
        stream: categoryService.categoriesClasse(appStore.userclasse!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CategoryModel> data = snapshot.data as List<CategoryModel>;
            return SingleChildScrollView(
              child: Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(16),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: List.generate(
                    data.length,
                    (index) {
                      CategoryModel? mData = data[index];
                      return QuizCategoryComponent(category: mData).onTap(
                        () {
                          if (profileIsnotComplette()) {
                            bottomshetUncompletteProfile(context);
                          } else {
                            QuizScreen(catId: mData.id, catName: mData.name)
                                .launch(context);
                          }
                        },
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                      );
                    },
                  ),
                ),
              ),
            );
          }
          return snapWidgetHelper(snapshot,
              errorWidget:
                  emptyWidget(text: appStore.translate('lbl_noDataFound')));
        },
      ),
    );
  }
}
