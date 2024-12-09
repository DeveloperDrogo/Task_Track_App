import 'dart:convert';

import 'package:task_track_app/features/taskTrack/domain/entities/label_data.dart';

class LabelsModel extends LabelsData {
  LabelsModel({required super.labelName, required super.labelId});
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'labelName': labelName,
      'labelId': labelId,
    };
  }

  factory LabelsModel.fromMap(Map<String, dynamic> map) {
    return LabelsModel(
      labelName: map['name'] ??'',
      labelId: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LabelsModel.fromJson(String source) =>
      LabelsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
