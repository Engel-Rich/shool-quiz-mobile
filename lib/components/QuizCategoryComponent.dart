// ignore_for_file: unused_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/models/CategoryModel.dart';
import 'package:quizapp_flutter/utils/constants.dart';

class QuizCategoryComponent extends StatefulWidget {
  static String tag = '/QuizCategoryComponent';

  final CategoryModel? category;

  QuizCategoryComponent({this.category});

  @override
  QuizCategoryComponentState createState() => QuizCategoryComponentState();
}

class QuizCategoryComponentState extends State<QuizCategoryComponent> {
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
    return Container(
      width: (context.width() - 48) / 2,
      height: (context.width() - 48) / 2,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16)),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.category!.image != null)
            Container(
              width: ((context.width() - 48) / 2) - 90,
              height: ((context.width() - 48) / 2) - 100,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(widget.category!.image!),
                      fit: BoxFit.cover)),
              alignment: Alignment.center,
            ),
          16.height,
          Text(
            widget.category!.name!,
            style: primaryTextStyle(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
