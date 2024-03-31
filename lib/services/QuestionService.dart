import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/models/QuestionModel.dart';
import 'package:quizapp_flutter/services/BaseService.dart';
import 'package:quizapp_flutter/utils/ModelKeys.dart';

class QuestionService extends BaseService {
  QuestionService() {
    ref = db.collection('question');
  }

  Future<QuestionModel> questionById(String id) async {
    //return await ref.where('id', isEqualTo: id).limit(1).get().then((value) => QuestionModel.fromJson(value.docs.first.data()));
    return ref.where(CommonKeys.id, isEqualTo: id).limit(1).get().then((res) {
      if (res.docs.isNotEmpty) {
        return QuestionModel.fromJson(
            res.docs.first.data() as Map<String, dynamic>);
      } else {
        toast('Quiz is not available');
        throw 'Not available';
      }
    });
  }

  Future<List<QuestionModel>> questionByCatId(String? catId) async {
    if (catId != null) {
      return await ref
          .where(QuestionKeys.category,
              isEqualTo: categoryService.ref.doc(catId))
          .get()
          .then(
        (event) {
          return event.docs
              .map((e) =>
                  QuestionModel.fromJson(e.data() as Map<String, dynamic>))
              .toList();
        },
      );
    } else {
      return await ref.get().then((value) {
        return value.docs
            .map(
                (e) => QuestionModel.fromJson(e.data() as Map<String, dynamic>))
            .toList();
      });
    }
  }

  Future<List<QuestionModel>> questionByType(String? type) async {
    return ref
        .where("questionType", isEqualTo: type)
        .where("classeId", isEqualTo: appStore.userclasse)
        .get()
        .then((res) {
      if (res.docs.isNotEmpty) {
        return res.docs
            .map(
                (e) => QuestionModel.fromJson(e.data() as Map<String, dynamic>))
            .toList();
      } else {
        toast('Quiz is not available');
        throw 'Not available';
      }
    });
  }

  Future<List<QuestionModel>> questionList() async {
    return ref
        .where("classeId", isEqualTo: appStore.userclasse)
        .get()
        .then((value) {
      return value.docs
          .map((e) => QuestionModel.fromJson(e.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
