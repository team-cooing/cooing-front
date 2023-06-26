class HintStatus {
  Map<String, dynamic> isHintOpends;

  HintStatus({required this.isHintOpends});

  factory HintStatus.fromJson(Map<String, dynamic> json){
    return HintStatus(isHintOpends: json['is_hint_opends']);
  }

  Map<String, dynamic> toJson(){
    return {
      "is_hint_opends": isHintOpends
    };
  }
}
