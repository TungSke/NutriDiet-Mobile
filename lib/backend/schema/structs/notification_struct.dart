// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NotificationStruct extends BaseStruct {
  NotificationStruct({
    String? text1,
    String? text2,
  })  : _text1 = text1,
        _text2 = text2;

  // "text1" field.
  String? _text1;
  String get text1 => _text1 ?? '';
  set text1(String? val) => _text1 = val;

  bool hasText1() => _text1 != null;

  // "text2" field.
  String? _text2;
  String get text2 => _text2 ?? '';
  set text2(String? val) => _text2 = val;

  bool hasText2() => _text2 != null;

  static NotificationStruct fromMap(Map<String, dynamic> data) =>
      NotificationStruct(
        text1: data['text1'] as String?,
        text2: data['text2'] as String?,
      );

  static NotificationStruct? maybeFromMap(dynamic data) => data is Map
      ? NotificationStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'text1': _text1,
        'text2': _text2,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'text1': serializeParam(
          _text1,
          ParamType.String,
        ),
        'text2': serializeParam(
          _text2,
          ParamType.String,
        ),
      }.withoutNulls;

  static NotificationStruct fromSerializableMap(Map<String, dynamic> data) =>
      NotificationStruct(
        text1: deserializeParam(
          data['text1'],
          ParamType.String,
          false,
        ),
        text2: deserializeParam(
          data['text2'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'NotificationStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is NotificationStruct &&
        text1 == other.text1 &&
        text2 == other.text2;
  }

  @override
  int get hashCode => const ListEquality().hash([text1, text2]);
}

NotificationStruct createNotificationStruct({
  String? text1,
  String? text2,
}) =>
    NotificationStruct(
      text1: text1,
      text2: text2,
    );
