// ignore_for_file: body_might_complete_normally_catch_error

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/models/ClasseModel.dart';
import 'package:quizapp_flutter/utils/constants.dart';
// import 'package:quizeapp/main.dart';

class ClassService {
  ClassMode? model;
  ClassService({this.model});
  final database = FirebaseFirestore.instance.collection(classe_model_db);

  Future<void> addClass() async {
    final doc = database.doc();
    model!.id_classe = doc.id;
    await doc.set(model!.toMap()).catchError((err) {
      Fluttertoast.showToast(msg: 'somthing whent wrong');
    });
  }

  static Future<void> updateClass(ClassMode model) async {
    final doc = ClassService().database.doc(model.id_classe);
    await doc.update(model.toMap()).catchError((err) {
      Fluttertoast.showToast(msg: 'somthing whent wrong');
    });
  }

  static Future<void> deleteClasse(String model) async {
    final doc = ClassService().database.doc(model);
    await doc.delete().catchError((err) {
      Fluttertoast.showToast(msg: 'somthing whent wrong');
    });
  }

  Future<List<String>?> getFiliere() async {
    return database
        .get()
        .then(
          (value) => value.docs
              .map((e) => e.data()['filiere'].toString())
              .toSet()
              .toList(),
        )
        .catchError((onError) {
      print(onError);
    });
  }

// get classe by id

  Future<ClassMode?> getclasse(idclasse) async => await database
          .doc(idclasse)
          .get()
          .then(
            (value) => ClassMode.fromMap(value.data()),
          )
          .catchError((onError) {
        print(onError);
        toast(onError.toString());
      });
// All classe

  Stream<List<ClassMode>?> getAllClass() => database
          .snapshots()
          .map(
            (value) => value.docs.map((classe) {
              final data = ClassMode.fromMap(classe.data());
              print(data.toMap());
              return data;
            }).toList(),
          )
          .handleError((onError) {
        print(onError);
      });

// All classe future

  Future<List<ClassMode>?> getAllClassFuture() async => database
          .get()
          .then(
            (value) => value.docs.map((classe) {
              final data = ClassMode.fromMap(classe.data());
              print(data.toMap());
              return data;
            }).toList(),
          )
          .catchError((onError) {
        print(onError);
      });

// All classe filter by filiere

  Stream<List<ClassMode>?> getAllClassFiliterByFiliere(String filiere) =>
      database
          .where("filiere", isEqualTo: filiere)
          .snapshots()
          .map(
            (value) => value.docs.map((classe) {
              final data = ClassMode.fromMap(classe.data());
              print(data.toMap());
              return data;
            }).toList(),
          )
          .handleError((onError) {
        print(onError);
      });

// All classe order by enseignemet

  Stream<List<ClassMode>?> getAllClassFiliterByBranch(String filiere) =>
      database
          .where("type_enseignement", isEqualTo: filiere)
          .snapshots()
          .map(
            (value) => value.docs.map((classe) {
              final data = ClassMode.fromMap(classe.data());
              print(data.toMap());
              return data;
            }).toList(),
          )
          .handleError((onError) {
        print(onError);
      });
// All classe filter by section

  Stream<List<ClassMode>?> getAllClassFiliterBySection(String filiere) =>
      database
          .where("type_section", isEqualTo: filiere)
          .snapshots()
          .map(
            (value) => value.docs.map((classe) {
              final data = ClassMode.fromMap(classe.data());
              print(data.toMap());
              return data;
            }).toList(),
          )
          .handleError((onError) {
        print(onError);
      });
  // Fin de la classe
}
