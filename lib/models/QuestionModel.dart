import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizapp_flutter/utils/ModelKeys.dart';

class QuestionModel {
  String? addQuestion;
  String? correctAnswer;
  String? id;
  int? selectedOptionIndex;
  List<String>? optionList;
  String? answer;
  String? questionType;
  DateTime? createdAt;
  String? note;
  DateTime? updatedAt;
  String? questionTime;
  String? image;

  QuestionModel({
    this.addQuestion,
    this.correctAnswer,
    this.id,
    this.optionList,
    this.note,
    this.selectedOptionIndex,
    this.answer,
    this.questionType,
    this.createdAt,
    this.updatedAt,
    this.questionTime,
    this.image,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      addQuestion: json[QuestionKeys.addQuestion],
      correctAnswer: json[QuestionKeys.correctAnswer],
      id: json[CommonKeys.id],
      optionList: json[QuestionKeys.optionList] != null
          ? new List<String>.from(json[QuestionKeys.optionList])
          : null,
      note: json.containsKey('note') ? json['note'] : '',
      questionType: json['questionType'],
      createdAt: json[CommonKeys.createdAt] != null
          ? (json[CommonKeys.createdAt] as Timestamp).toDate()
          : null,
      updatedAt: json[CommonKeys.updatedAt] != null
          ? (json[CommonKeys.updatedAt] as Timestamp).toDate()
          : null,
      questionTime: json[QuestionTimeKeys.questionTime],
      image: json[CategoryKeys.image],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[QuestionKeys.addQuestion] = this.addQuestion;
    data[QuestionKeys.correctAnswer] = this.correctAnswer;
    data[CommonKeys.id] = this.id;
    data['questionType'] = this.questionType;
    data[CommonKeys.createdAt] = this.createdAt;
    data[CommonKeys.updatedAt] = this.updatedAt;
    data[QuestionKeys.addQuestion] = this.addQuestion;
    data[QuestionTimeKeys.questionTime] = this.questionTime;
    data[CategoryKeys.image] = this.image;
    if (this.optionList != null) {
      data[QuestionKeys.optionList] = this.optionList;
    }
    return data;
  }
}
