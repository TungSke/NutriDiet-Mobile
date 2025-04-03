// ignore_for_file: unnecessary_getters_setters, unused_element

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/backend/schema/structs/index.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();

    _safeInit(() {
      _isintro = prefs.getBool('ff_isintro') ?? _isintro;
    });
    _safeInit(() {
      _isLogin = prefs.getBool('ff_isLogin') ?? _isLogin;
    });
    _safeInit(() {
      _bottomindex = prefs.getInt('ff_bottomindex') ?? _bottomindex;
    });
    _safeInit(() {
      _isintroindex = prefs.getInt('ff_isintroindex') ?? _isintroindex;
    });
    _safeInit(() {
      _searchList = prefs.getStringList('ff_searchList') ?? _searchList;
    });
    _safeInit(() {
      _firstname = prefs.getString('ff_firstname') ?? _firstname;
    });
    _safeInit(() {
      _lastname = prefs.getString('ff_lastname') ?? _lastname;
    });
    _safeInit(() {
      _email = prefs.getString('ff_email') ?? _email;
    });
    _safeInit(() {
      _selected = prefs.getInt('ff_selected') ?? _selected;
    });
    _safeInit(() {
      _lastcm = prefs.getString('ff_lastcm') ?? _lastcm;
    });
    _safeInit(() {
      _cmvalue = prefs.getString('ff_cmvalue') ?? _cmvalue;
    });

    _safeInit(() {
      _feet = prefs.getString('ff_feet') ?? _feet;
    });
    _safeInit(() {
      _inchh = prefs.getString('ff_inchh') ?? _inchh;
    });
    _safeInit(() {
      _kg = prefs.getString('ff_kg') ?? _kg;
    });
    _safeInit(() {
      _lb = prefs.getString('ff_lb') ?? _lb;
    });
    _safeInit(() {
      _activityLevel = prefs.getString('ff_activityLevel');
    });
    _safeInit(() {
      _dietStyle = prefs.getString('ff_dietStyle');
    });
    _safeInit(() {
      _kgvalue = prefs.getString('ff_kgvalue') ?? _kgvalue;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  bool _isLogin = false;
  bool get isLogin => _isLogin;
  set isLogin(bool value) {
    _isLogin = value;
    prefs.setBool('ff_isLogin', value);
  }

  bool _isintro = false;
  bool get isintro => _isintro;
  set isintro(bool value) {
    _isintro = value;
    prefs.setBool('ff_isintro', value);
  }

  int _bottomindex = 0;
  int get bottomindex => _bottomindex;
  set bottomindex(int value) {
    _bottomindex = value;
    prefs.setInt('ff_bottomindex', value);
  }

  int _isintroindex = 0;
  int get isintroindex => _isintroindex;
  set isintroindex(int value) {
    _isintroindex = value;
    prefs.setInt('ff_isintroindex', value);
  }

  List<String> _searchList = [];
  List<String> get searchList => _searchList;
  set searchList(List<String> value) {
    _searchList = value;
    prefs.setStringList('ff_searchList', value);
  }

  void addToSearchList(String value) {
    searchList.add(value);
    prefs.setStringList('ff_searchList', _searchList);
  }

  void removeFromSearchList(String value) {
    searchList.remove(value);
    prefs.setStringList('ff_searchList', _searchList);
  }

  void removeAtIndexFromSearchList(int index) {
    searchList.removeAt(index);
    prefs.setStringList('ff_searchList', _searchList);
  }

  void updateSearchListAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    searchList[index] = updateFn(_searchList[index]);
    prefs.setStringList('ff_searchList', _searchList);
  }

  void insertAtIndexInSearchList(int index, String value) {
    searchList.insert(index, value);
    prefs.setStringList('ff_searchList', _searchList);
  }

  String _firstname = '';
  String get firstname => _firstname;
  set firstname(String value) {
    _firstname = value;
    prefs.setString('ff_firstname', value);
  }

  String _lastname = '';
  String get lastname => _lastname;
  set lastname(String value) {
    _lastname = value;
    prefs.setString('ff_lastname', value);
  }

  String _email = '';
  String get email => _email;
  set email(String value) {
    _email = value;
    prefs.setString('ff_email', value);
  }

  int _selected = 0;
  int get selected => _selected;
  set selected(int value) {
    _selected = value;
    prefs.setInt('ff_selected', value);
  }

  String _lastcm = '';
  String get lastcm => _lastcm;
  set lastcm(String value) {
    _lastcm = value;
    prefs.setString('ff_lastcm', value);
  }

  String _cmvalue = '0';
  String get cmvalue => _cmvalue;
  set cmvalue(String value) {
    _cmvalue = value;
    prefs.setString('ff_cmvalue', value);
  }

  String _feet = '0';
  String get feet => _feet;
  set feet(String value) {
    _feet = value;
    prefs.setString('ff_feet', value);
  }

  String _inchh = '0';
  String get inchh => _inchh;
  set inchh(String value) {
    _inchh = value;
    prefs.setString('ff_inchh', value);
  }

  String? _activityLevel;
  String? _dietStyle;
  String? get dietStyle => _dietStyle;
  set dietStyle(String? value) {
    _dietStyle = value;
    prefs.setString('ff_dietStyle', value ?? ''); // Lưu vào SharedPreferences
  }

  String? get activityLevel => _activityLevel;
  set activityLevel(String? value) {
    _activityLevel = value;
    prefs.setString(
        'ff_activityLevel', value ?? ''); // Lưu vào SharedPreferences
  }

  String? _allergyIds;

  String? get allergyIds => _allergyIds;

  set allergyIds(String? value) {
    _allergyIds = value;
    prefs.setString('ff_allergyIds', value ?? ''); // Lưu vào SharedPreferences
  }

  String? _diseaseIds;

  String? get diseaseIds => _diseaseIds;

  set diseaseIds(String? value) {
    _diseaseIds = value;
    prefs.setString('ff_diseaseIds', value ?? ''); // Lưu vào SharedPreferences
  }

  String? _goalType;
  String? get goalType => _goalType;
  set goalType(String? value) {
    _goalType = value;
    prefs.setString('ff_goalType', value ?? ''); // Lưu vào SharedPreferences
  }

  String _kg = '';
  String get kg => _kg;
  set kg(String value) {
    _kg = value;
    prefs.setString('ff_kg', value);
  }

  String _lb = '';
  String get lb => _lb;
  set lb(String value) {
    _lb = value;
    prefs.setString('ff_lb', value);
  }

  String _kgvalue = '0';
  String get kgvalue => _kgvalue;
  set kgvalue(String value) {
    _kgvalue = value;
    prefs.setString('ff_kgvalue', value);
  }

  List<NotificationStruct> _notificationlist = [
    NotificationStruct.fromSerializableMap(jsonDecode(
        '{\"text1\":\"Notifications show when you swipe.\",\"text2\":\"Just now\"}')),
    NotificationStruct.fromSerializableMap(jsonDecode(
        '{\"text1\":\"An app notification is a message or alert.\",\"text2\":\"1 Min\"}')),
    NotificationStruct.fromSerializableMap(jsonDecode(
        '{\"text1\":\"People or other timely  information from\",\"text2\":\"10 Min\"}')),
    NotificationStruct.fromSerializableMap(jsonDecode(
        '{\"text1\":\"Their name imply the differenc between\",\"text2\":\"20 Min\"}')),
    NotificationStruct.fromSerializableMap(jsonDecode(
        '{\"text1\":\"Only visible within the app while ruhin\",\"text2\":\"30 Min\"}')),
    NotificationStruct.fromSerializableMap(jsonDecode(
        '{\"text1\":\"Communication from other people other\",\"text2\":\"40 Min\"}')),
    NotificationStruct.fromSerializableMap(jsonDecode(
        '{\"text1\":\"Verbal Notification means notification\",\"text2\":\"50 Min\"}')),
    NotificationStruct.fromSerializableMap(jsonDecode(
        '{\"text1\":\"Either in person or by telephone directly \",\"text2\":\"59 Min\"}'))
  ];
  List<NotificationStruct> get notificationlist => _notificationlist;
  set notificationlist(List<NotificationStruct> value) {
    _notificationlist = value;
  }

  void addToNotificationlist(NotificationStruct value) {
    notificationlist.add(value);
  }

  void removeFromNotificationlist(NotificationStruct value) {
    notificationlist.remove(value);
  }

  void removeAtIndexFromNotificationlist(int index) {
    notificationlist.removeAt(index);
  }

  void updateNotificationlistAtIndex(
    int index,
    NotificationStruct Function(NotificationStruct) updateFn,
  ) {
    notificationlist[index] = updateFn(_notificationlist[index]);
  }

  void insertAtIndexInNotificationlist(int index, NotificationStruct value) {
    notificationlist.insert(index, value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
