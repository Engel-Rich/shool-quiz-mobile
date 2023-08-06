import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/models/ClasseModel.dart';
import 'package:quizapp_flutter/services/ClasseService.dart';
import 'package:quizapp_flutter/services/FileStorageService.dart';
import 'package:quizapp_flutter/utils/ModelKeys.dart';
import 'package:quizapp_flutter/utils/colors.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/utils/widgets.dart';

import '../components/AppBarComponent.dart';
import '../utils/images.dart';

class ProfileScreen extends StatefulWidget {
  static String tag = '/ProfileScreen';

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController nameController =
      TextEditingController(text: appStore.userName);
  TextEditingController emailController =
      TextEditingController(text: appStore.userEmail);

  String? filiere;
  String? className;
  String section = 'FR';
  String typeEnseign = 'GEN';
  ClassMode? mode;

  List<String> filieres = [];
  List<String> classNames = [];
  List<String> typeEnseigns = ['GEN', 'TECH'];
  List<String> sections = ['FR', 'EN'];
  List<ClassMode> modes = [];

// functions

//   Setmode functions

  void setMode() {
    setState(() {
      mode = modes.firstWhere(
        (element) => (element.long_name.trim() == className!.trim() &&
            element.type_section == section &&
            element.type_enseignement == typeEnseign),
      );
    });
  }

// clearListe

// setList

  void setListes() {
    setState(() {
      filieres.clear();
      classNames.clear();
    });
    modes.forEach((element) {
      if (element.type_section == section &&
          element.type_enseignement == typeEnseign) {
        filieres.add(element.filiere);
        classNames.add(element.long_name);
      }
    });
    setState(() {});
  }

  // initMode
  Future<void> initUserMode() async {
    if (appStore.userclasse != null && appStore.userclasse!.trim().isNotEmpty) {
      await ClassService().getclasse(appStore.userclasse).then((value) {
        setState(() {
          mode = value;
          section = value?.type_section ?? section;
          typeEnseign = value?.type_enseignement ?? typeEnseign;
          filiere = value?.filiere;
          className = value?.long_name;
        });
        setListes();
      }).catchError((onError) {
        toast(onError.toString());
      });
    }
  }

  Future<void> initializeClasse() async {
    await ClassService().getAllClassFuture().then((value) {
      print(value?.length ?? "No data");
      modes = value ?? [];
      if (mode != null) {
        modes.removeWhere((element) => element.id_classe == mode!.id_classe);
        modes.add(mode!);
      }
      modes.forEach((element) {
        if (element.type_enseignement == typeEnseign &&
            element.type_section == section) {
          filieres.add(element.filiere);
          classNames.add(element.long_name);
        }
      });
      setState(() {});
    }).catchError((onError) {
      toast(onError.toString());
    });
  }

// i
  PickedFile? image;

  FocusNode nameFocus = FocusNode();

  List<String> ageRangeList = [
    '5 - 10',
    '10 - 15',
    '15 - 20',
    '20 - 25',
    '25 - 30',
    '30 - 35',
    '35 - 40',
    '40 - 45',
    '45 - 50'
  ];

  String dropdownValue =
      (appStore.userAge == null || appStore.userAge!.trim().isEmpty)
          ? '15 - 20'
          : appStore.userAge!;

  @override
  void initState() {
    appStore.setLoading(false);
    super.initState();
    init();
    initUserMode();
    initializeClasse();
  }

  Future<void> init() async {}

  Widget profileImage() {
    if (image != null) {
      return Image.file(File(image!.path),
          height: 130,
          width: 130,
          fit: BoxFit.cover,
          alignment: Alignment.center);
    } else {
      if (getStringAsync(LOGIN_TYPE) == LoginTypeGoogle ||
          getStringAsync(LOGIN_TYPE) == LoginTypeEmail) {
        if (appStore.userProfileImage == '') {
          return CircleAvatar(radius: 50, child: Image.asset(UserPic))
              .paddingAll(16);
        }
        return cachedImage(appStore.userProfileImage.validate(),
            height: 130,
            width: 130,
            fit: BoxFit.cover,
            alignment: Alignment.center);
      } else {
        return CircleAvatar(radius: 26, child: Image.asset(UserPic))
            .paddingAll(16);
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future update() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      appStore.setLoading(true);
      setState(() {});

      Map<String, dynamic> req = {};

      if (nameController.text != appStore.userName) {
        req.putIfAbsent(UserKeys.name, () => nameController.text.trim());
      }
      // Classe remplissage

      if (mode!.id_classe != appStore.userclasse) {
        req.putIfAbsent('classe', () => mode!.id_classe);
      }

      //  fin de la classe

      if (dropdownValue != getStringAsync(USER_AGE)) {
        req.putIfAbsent(UserKeys.age, () => dropdownValue);
        setValue(USER_AGE, dropdownValue);
      }
      if (appStore.userEmail!.trim().isEmpty) {
        req.putIfAbsent(UserKeys.email, () => emailController.text.trim());
        setValue(USER_EMAIL, emailController.text.trim());
      }
      await auth.currentUser!.updateEmail(emailController.text.trim());
      await auth.currentUser!.updateDisplayName(nameController.text.trim());

      if (image != null) {
        await uploadFile(file: File(image!.path), prefix: 'userProfiles').then(
          (path) async {
            req.putIfAbsent(UserKeys.photoUrl, () => path);
            await auth.currentUser!.updatePhotoURL(path);
            await setValue(USER_PHOTO_URL, path);
            appStore.setProfileImage(path);
          },
        ).catchError(
          (e) {
            toast(e.toString());
          },
        );
      }

      await userDBService.updateDocument(req, appStore.userId).then(
        (value) async {
          appStore.setLoading(false);
          appStore.setName(nameController.text);
          setValue(USER_DISPLAY_NAME, nameController.text);
          appStore.setUserAge(dropdownValue);
          setValue(USER_AGE, dropdownValue);
          appStore.setUserClasse(mode!.id_classe);
          appStore.setUserEmail(emailController.text.trim());
          setValue(USER_EMAIL, emailController.text.trim());
          finish(context);
        },
      );
    }
  }

  Future getImage() async {
    if (!isLoggedInWithGoogle()) {
      // ignore: deprecated_member_use
      image = await ImagePicker()
          .getImage(source: ImageSource.gallery, imageQuality: 100);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarComponent(
          context: context, title: appStore.translate('lbl_profile')),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: <Widget>[
                      Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 2,
                        margin: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80)),
                        child: profileImage(),
                      ),
                      Positioned(
                        child: CircleAvatar(
                          backgroundColor: colorPrimary,
                          radius: 15,
                          child:
                              Icon(Icons.edit_outlined, color: white, size: 20)
                                  .onTap(
                            () {
                              getImage();
                            },
                          ),
                        ),
                        right: 8,
                        bottom: 8,
                      ).visible(!isLoggedInWithGoogle()),
                    ],
                  ).paddingOnly(top: 16, bottom: 16).center(),
                  Observer(
                      builder: (context) => Text(appStore.userName!,
                              style: boldTextStyle(size: 20))
                          .center()),
                  4.height,
                  Text('${appStore.translate('lbl_points')} ${getIntAsync(USER_POINTS)}',
                          style: boldTextStyle(size: 18, color: colorPrimary))
                      .center(),
                  16.height,
                  Divider(),
                  16.height,
                  Text(appStore.translate('lbl_email_id'),
                      style: primaryTextStyle()),
                  8.height,
                  AppTextField(
                    controller: emailController,
                    textFieldType: TextFieldType.EMAIL,
                    focus: nameFocus,
                    readOnly: appStore.userEmail!.trim().isNotEmpty,
                    onTap: () {
                      if (appStore.userEmail!.trim().isNotEmpty) {
                        toast("you can't change email address");
                      }
                    },
                    decoration: inputDecoration(
                        hintText: appStore.translate('lbl_email_hint')),
                  ),
                  16.height,
                  Text(appStore.translate('lbl_name'),
                      style: primaryTextStyle()),
                  8.height,
                  AppTextField(
                    controller: nameController,
                    textFieldType: TextFieldType.NAME,
                    readOnly: isLoggedInWithGoogle() ? true : false,
                    decoration: inputDecoration(
                        hintText: appStore.translate('lbl_name_hint')),
                  ),
                  16.height,
                  Text(appStore.translate('lbl_age'),
                      style: primaryTextStyle()),
                  8.height,
                  DropdownButtonFormField<String>(
                    value: dropdownValue,
                    decoration: inputDecoration(),
                    dropdownColor: Theme.of(context).cardColor,
                    items: List.generate(
                        ageRangeList.length,
                        (index) => DropdownMenuItem<String>(
                              value: ageRangeList[index],
                              child: Text(
                                ageRangeList[index],
                                style: primaryTextStyle(),
                              ),
                            )),
                    onChanged: (value) {
                      dropdownValue = value!;
                    },
                    validator: (value) {
                      return value == null ? errorThisFieldRequired : null;
                    },
                  ),

                  //  Type Enseignement

                  16.height,
                  Text(appStore.translate('lbl_gen_tech')),
                  8.height,
                  DropdownButtonFormField<String>(
                    value: typeEnseign,
                    decoration: inputDecoration(hintText: 'Branch'),
                    dropdownColor: Theme.of(context).cardColor,
                    items: List.generate(
                        typeEnseigns.length,
                        (index) => DropdownMenuItem<String>(
                              value: typeEnseigns[index],
                              child: Text(
                                typeEnseigns[index],
                                style: primaryTextStyle(),
                              ),
                            )),
                    onChanged: (value) {
                      typeEnseign = value!;
                      setListes();
                    },
                    validator: (value) {
                      return value == null ? errorThisFieldRequired : null;
                    },
                  ),

                  //  Section

                  16.height,
                  Text(appStore.translate('lbl_fr_en')),
                  8.height,
                  DropdownButtonFormField<String>(
                    value: section,
                    decoration: inputDecoration(hintText: 'section'),
                    dropdownColor: Theme.of(context).cardColor,
                    items: List.generate(
                        sections.length,
                        (index) => DropdownMenuItem<String>(
                              value: sections[index],
                              child: Text(
                                sections[index],
                                style: primaryTextStyle(),
                              ),
                            )),
                    onChanged: (value) {
                      section = value!;
                      setListes();
                    },
                    validator: (value) {
                      return value == null ? errorThisFieldRequired : null;
                    },
                  ),

                  // 16.height,
                  // Text(appStore.translate('lbl_age')),
                  // //  filière
                  // 8.height,
                  // DropdownButtonFormField<String>(
                  //   value: filiere,
                  //   decoration: inputDecoration(),
                  //   dropdownColor: Theme.of(context).cardColor,
                  //   items: List.generate(
                  //       filieres.length,
                  //       (index) => DropdownMenuItem<String>(
                  //             value: filieres[index],
                  //             child: Text(
                  //               filieres[index],
                  //               style: primaryTextStyle(),
                  //             ),
                  //           )),
                  //   onChanged: (value) {
                  //     filiere = value!;
                  //   },
                  //   validator: (value) {
                  //     return value == null ? errorThisFieldRequired : null;
                  //   },
                  // ),

                  //  classe

                  16.height,
                  Text(appStore.translate('lbl_clss')),
                  8.height,
                  DropdownButtonFormField<String>(
                    value: className,
                    decoration: inputDecoration(hintText: 'classe'),
                    dropdownColor: Theme.of(context).cardColor,
                    items: List.generate(
                        classNames.length,
                        (index) => DropdownMenuItem<String>(
                              value: classNames[index],
                              child: Text(
                                classNames[index],
                                style: primaryTextStyle(),
                              ),
                            )),
                    onChanged: (value) {
                      className = value!;
                      setMode();
                      appStore.setLoading(false);
                    },
                    validator: (value) {
                      return value == null ||
                              mode == null ||
                              mode!.id_classe == null
                          ? errorThisFieldRequired
                          : null;
                    },
                  ),
                  //
                  30.height,
                  Container(
                    width: context.width(),
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorPrimary,
                          colorSecondary,
                        ],
                        begin: FractionalOffset.centerLeft,
                        end: FractionalOffset.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(defaultRadius),
                    ),
                    child: TextButton(
                      child: Text(appStore.translate('lbl_update_profile'),
                          style: primaryTextStyle(color: white)),
                      onPressed: update,
                    ),
                  ).visible(!isLoggedInWithGoogle()),
                  22.height
                ],
              ).paddingOnly(left: 16, right: 16),
            ),
          ),
          Observer(
            builder: (context) => Loader().visible(appStore.isLoading),
          ),
        ],
      ),
    );
  }
}
