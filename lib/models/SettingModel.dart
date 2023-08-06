class AppSettingModel {
  String? contactInfo;
  bool? disableAd;
  String? privacyPolicy;
  String? termCondition;
  String? referPoints;

  AppSettingModel({
    this.contactInfo,
    this.disableAd,
    this.privacyPolicy,
    this.termCondition,
    this.referPoints,
  });

  factory AppSettingModel.fromJson(Map<String, dynamic> json) {
    return AppSettingModel(
      contactInfo: json['contactInfo'],
      disableAd: json['disableAd'],
      privacyPolicy: json['privacyPolicy'],
      termCondition: json['termCondition'],
      referPoints: json['referPoints']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contactInfo'] = this.contactInfo;
    data['disableAd'] = this.disableAd;
    data['privacyPolicy'] = this.privacyPolicy;
    data['termCondition'] = this.termCondition;
    data['referPoints'] =this.referPoints;
    return data;
  }
}
