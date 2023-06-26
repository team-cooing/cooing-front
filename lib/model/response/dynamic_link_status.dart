class DynamicLinkStatus {
  bool isOpened;

  DynamicLinkStatus({required this.isOpened});

  factory DynamicLinkStatus.fromJson(Map<String, dynamic> json) {
    return DynamicLinkStatus(isOpened: json['isOpened']);
  }

  Map<String, dynamic> toJson(){
    return {
      "isOpened": isOpened
    };
  }
}
