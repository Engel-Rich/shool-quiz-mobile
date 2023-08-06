import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/models/OnlineQuizModel.dart';
import 'package:quizapp_flutter/services/BaseService.dart';

class OnlineQuizServices extends BaseService {
  OnlineQuizServices({String? onlineQuizId}) {
    // ref = db.collection('onlineQuiz').doc(onlineQuizId).collection('AllQuestion');
    ref = db.collection('onlineQuiz');
  }

  Stream<List<OnlineQuizModel>> listQuestion() {
    return ref.snapshots().map((x) => x.docs.map((y) => OnlineQuizModel.fromJson(y.data() as Map<String, dynamic>)).toList());
  }
}
