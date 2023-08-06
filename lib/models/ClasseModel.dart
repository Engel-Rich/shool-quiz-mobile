// ignore_for_file: non_constant_identifier_names

class ClassMode {
  String? id_classe;
  String long_name;
  String shurt_name;
  String type_enseignement;
  String filiere;
  String type_section;
  String? image_classe;
  bool? isSecondary;

  ClassMode({
    this.id_classe,
    this.isSecondary,
    this.image_classe,
    required this.type_section,
    required this.filiere,
    required this.long_name,
    required this.shurt_name,
    required this.type_enseignement,
  });

  Map<String, dynamic> toMap() => {
        "id_classe": id_classe,
        "long_name": long_name,
        "isSecondary": isSecondary ?? true,
        "filiere": filiere,
        'image_classe': image_classe,
        "type_section": type_section,
        "shurt_name": shurt_name,
        "type_enseignement": type_enseignement,
      };

  factory ClassMode.fromMap(data) => ClassMode(
        id_classe: data['id_classe'],
        isSecondary: data["isSecondary"],
        filiere: data['filiere'],
        type_section: data['type_section'],
        long_name: data['long_name'],
        shurt_name: data['shurt_name'],
        image_classe: data['image_classe'] ?? null,
        type_enseignement: data['type_enseignement'],
      );
}
