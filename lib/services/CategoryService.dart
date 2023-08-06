import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/models/CategoryModel.dart';
import 'package:quizapp_flutter/services/BaseService.dart';

class CategoryService extends BaseService {
  CategoryService() {
    ref = db.collection('categories');
  }

  Future<List<CategoryModel>> categories() async {
    return await ref.where('parentCategoryId', isEqualTo: '').get().then((x) =>
        x
            .docs
            .map(
                (y) => CategoryModel.fromJson(y.data() as Map<String, dynamic>))
            .toList());
  }

  // List Of Cathegorie for one classe
  Stream<List<CategoryModel>> categoriesClasse(String classe) {
    return ref.where('classe', isEqualTo: classe).snapshots().map(
          (x) => x.docs
              .map((y) =>
                  CategoryModel.fromJson(y.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  Future<List<CategoryModel>> subCategories(String parentCategoryId) {
    return ref
        .where('parentCategoryId', isEqualTo: parentCategoryId)
        .get()
        .then((event) => event.docs
            .map(
                (e) => CategoryModel.fromJson(e.data() as Map<String, dynamic>))
            .toList());
  }
}
