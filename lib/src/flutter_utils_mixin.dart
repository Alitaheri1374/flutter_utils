import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../flutter_utils.dart' ;
// import 'package:advertising_id/advertising_id.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:package_info_plus/package_info_plus.dart';

///برای راحتر تر انجام دادن کارها در برنامه
mixin FlutterUtilsMixin {
  ///****************************************
  ///String
  ///to persion
  String? toPersian(String? str) {
    if (str == null) return null;
    return convertNumberToEnglish(
        str.replaceAll("ي", "ی").replaceAll("ك", "ک").trim());
  }
  ///convert Special characters
  String convertNumberToEnglish(String num) {
    String d = num;
    d = d.replaceAll("۰", "0");
    d = d.replaceAll("۱", "1");
    d = d.replaceAll("۲", "2");
    d = d.replaceAll("٣", "3");
    d = d.replaceAll("٤", "4");
    d = d.replaceAll("۵", "5");
    d = d.replaceAll("٦", "6");
    d = d.replaceAll("٧", "7");
    d = d.replaceAll("۸", "8");
    d = d.replaceAll("۹", "9");

    d = d
        .replaceAll(String.fromCharCode(1632), '0')
        .replaceAll(String.fromCharCode(1776), '0');
    d = d
        .replaceAll(String.fromCharCode(1633), '1')
        .replaceAll(String.fromCharCode(1777), '1');
    d = d
        .replaceAll(String.fromCharCode(1634), '2')
        .replaceAll(String.fromCharCode(1778), '2');
    d = d
        .replaceAll(String.fromCharCode(1635), '3')
        .replaceAll(String.fromCharCode(1779), '3');
    d = d
        .replaceAll(String.fromCharCode(1636), '4')
        .replaceAll(String.fromCharCode(1780), '4');
    d = d
        .replaceAll(String.fromCharCode(1637), '5')
        .replaceAll(String.fromCharCode(1781), '5');
    d = d
        .replaceAll(String.fromCharCode(1638), '6')
        .replaceAll(String.fromCharCode(1782), '6');
    d = d
        .replaceAll(String.fromCharCode(1639), '7')
        .replaceAll(String.fromCharCode(1783), '7');
    d = d
        .replaceAll(String.fromCharCode(1640), '8')
        .replaceAll(String.fromCharCode(1784), '8');
    d = d
        .replaceAll(String.fromCharCode(1641), '9')
        .replaceAll(String.fromCharCode(1785), '9');
    return d;
  }

  ///String
  ///ارسال string به سرور
  ///***
  ///```
  /// text == null  || text.isEmpty return null;
  ///```
  ///***
  String? stringValidationToServer({TextEditingController? textEditingController, String? text,
    String? removeCharacter}) {
    if (textEditingController != null && textEditingController.text.isNotEmpty) {
      if (removeCharacter != null) {
        return textEditingController.text.replaceAll(removeCharacter, '');
      }
      else {
        return textEditingController.text;
      }
    }
    else if (text != null && text != '') {
      if (removeCharacter != null) {
        return text.replaceAll(removeCharacter, '');
      } else {
        return text;
      }
    }
    return null;
  }

  ///ست کردن dynamic value  توی  txtController
  String setTextController({required dynamic value}) {
    // PrintHelper.customPrint(value: value);
    if (value == null || value == '') return '';
    return value.toString();
  }

  ///****************************************
  ///date

  ///*
  ///```
  /// text == null  || text.isEmpty return null;
  ///```
  ///***
  String? dateValidationToServer(
      {TextEditingController? textEditingController, String? text}) {
    if (textEditingController != null &&
        textEditingController.text.isNotEmpty) {
      return textEditingController.text;
    } else if (text != null && text != '') {
      return text;
    }
    return null;
  }
  ///ست کردن dynamic value  توی  txtController
  ///```
  ///***
  /// value == null || value == '' || value == '1/01/01 00:00:00' =>return ''
  ///```
  ///***
  String setDateTextController({required dynamic value}) {
    if (value == null || value == '' || value == '1/01/01 00:00:00') {
      return '';
    } else if (value.toString().length >= 10) {
      return value.toString().substring(0, 10);
    }
    return value.toString();
  }

  ///****************************************
  ///تبدیل تاریخ میلادی به شمسی
  String convertToDateShamsi({required String dateMiladi}) {
    String date = dateMiladi.replaceAll('00:00:00', '');
    date = date.replaceAll(' ', '');
    try {
      Gregorian gregorian = Gregorian(int.parse(date.split('/')[0]),
          int.parse(date.split('/')[1]), int.parse(date.split('/')[2]));
      Jalali jalali = gregorian.toJalali();
      String jalaliDate =
          '${jalali.year}/${jalali.month > 9 ? jalali.month : '0${jalali.month}'}/${jalali.day > 9 ? jalali.day : '0${jalali.day}'}';
      return jalaliDate;
    } catch (exception, stackTrace) {
      debugPrint(exception.toString());
      debugPrint(stackTrace.toString());
      return '';
    }
  }

  ///تبدیل تاریخ شمسی به میلادی
  String convertToDateMiladi({required String dateShamsi}) {
    String date = dateShamsi.replaceAll('00:00:00', '');
    date = date.replaceAll(' ', '');
    try {
      Jalali j = Jalali(int.parse(date.split('/')[0]),
          int.parse(date.split('/')[1]), int.parse(date.split('/')[2]));
      Gregorian gregorian = j.toGregorian();
      String gregorianDate =
          '${gregorian.year}/${gregorian.month > 9 ? gregorian.month : '0${gregorian.month}'}/${gregorian.day > 9 ? gregorian.day : '0${gregorian.day}'}';

      return gregorianDate;
    } catch (exception, stackTrace) {
      debugPrint(exception.toString());
      debugPrint(stackTrace.toString());
      return '';
    }
  }

  ///محاسبه تعداد روز بین دو تاریخ
  String differenceDate({required String startDate, required String endDate, bool notNegative = false}) {
    try {
      DateTime? dateStart = startDate.toDate();
      DateTime? dateEnd = endDate.toDate();
      if (dateStart != null && dateEnd != null) {
        Duration difference = dateEnd.difference(dateStart);
        int days = difference.inDays;
        if (notNegative) {
          return days > 0 ? days.toString() : '0';
        } else {
          return days.toString();
        }
      } else {
        return '0';
      }
    } catch (exception, stackTrace) {
      debugPrint(exception.toString());
      debugPrint(stackTrace.toString());
      return '0';
    }
  }

  /// Parse the original date string to DateTime and convsert to Shamsi DateTime
  String convertToShamsiDateTime(String createdAt) {
    // Parse the original date string to DateTime
    DateTime gregorianDate = DateTime.parse(createdAt);
    // Convert to Jalali
    Jalali jalaliDate = Jalali.fromDateTime(gregorianDate);
    // Format the time
    String formattedTime = DateFormat('HH:mm').format(gregorianDate);
    // Format the Jalali date
    String formattedDate =
        '${jalaliDate.year}/${jalaliDate.month}/${jalaliDate.day}';

    return '$formattedDate $formattedTime';
  }

  ///***
  ///برگرداندن تاریخ (DateTime) بر اساس
  ///return DateTime with format  yyy/mm/dd
  ///***
  String dateNow() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy/MM/dd').format(now);
    return formattedDate;
  }
  ///return DateTime with format  'yyyyMMdd_HHmmss'
  String dateNowWithoutSpace() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMdd_HHmmss').format(now);
    return formattedDate;
  }

  ///****************************************
  ///convert base64 to Unit8list
  Uint8List convertBase64ToUnit8list({required String stringBase64}) {
    Uint8List bytes = const Base64Decoder().convert(stringBase64);
    return bytes;
  }
  ///convert String to base64
  String? convertStringToBase64({required String? stringBase64,}) {
    if (stringBase64 != null && stringBase64 != '') {
      if (stringBase64.length >= 22) {
        String base64Substring =
            stringBase64.substring(22, stringBase64.length);
        return base64Substring;
      } else {
        return stringBase64;
      }
    } else {
      return null;
    }
  }

  ///convert String to base64
  ///String Contain FileType
  String? convertStringToBase64BaseForType(
      {required String? stringBase64, required String fileType}) {
    if (stringBase64 != null && stringBase64 != '') {
      switch (fileType.toLowerCase()) {
        case 'excel':
          var data =
              stringBase64.split('data:application/vnd.ms-excel;base64, ');
          if (data.indexExists(1)) {
            return data[1];
          }
          break;
        default:
          break;
      }
      return null;
    } else {
      return null;
    }
  }

  ////*****************************************************************************************************************************************************
  ///create focusNode List
  List<FocusNode> generatorFocusList(int count) {
    return List<FocusNode>.generate(count, (int index) => FocusNode());
  }

  ////*****************************************************************************************************************************************************
  /// convert LinkedMap To Map
  Map<String, dynamic> convertLinkedMapToMap(
      {required LinkedHashMap<dynamic, dynamic> linkedMap}) {
    Map<String, dynamic> resultMap = {...linkedMap};

    // linkedMap.forEach((key, value) {
    //   if (key is String) {
    //     resultMap[key] = value;
    //   }
    // });

    return resultMap;
  }

  ///get Google Ad Id
  ///unique id
  Future<String?> getGoogleAdId() async {
    String? advertisingId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      advertisingId = await AdvertisingId.id(true);
    } on PlatformException {
      advertisingId = null;
    }
    return advertisingId;
  }

  ///***
  ///round for double with decimal count
  ///***
  double roundDouble({required double? value, required int countDecimal}) {
    int decimals = countDecimal;
    num fac = pow(10, decimals);
    double result = value ?? 0.0;
    result = (result * fac).round() / fac;
    return result;
  }

  ///***
  ///حذف صفر از آخر متغییر double
  ///***
  String removeZeroFromLastDouble(String input) {
    String value = input;
    while (value.contains('.') &&
        (value[value.length - 1] == '0' || value[value.length - 1] == '.')) {
      value = value.substring(0, value.length - 2);
    }
    return value;
  }

  ///***
  ///getDeviceInfo
  ///***
  Future<Map<String, dynamic>> getDeviceInfo() async {
    Map<String, dynamic> object = {};
    String? chAdID = await getGoogleAdId();

    // String? chFirebaseToken = await PushNotifications.getToken();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String? chApplicationVersion = packageInfo.version;

    // final deviceInfoPlugin = DeviceInfoPlugin();
    // final deviceInfo = await deviceInfoPlugin.deviceInfo;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    String? chDeviceName;
    String? chAndroidVersion;

      if(defaultTargetPlatform==TargetPlatform.android){
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        // print('Running on ${androidInfo.model}');
        chDeviceName='${androidInfo.brand} - ${androidInfo.model} - ${androidInfo.device}';
        chAndroidVersion=androidInfo.version.release.toString();
      }else if(defaultTargetPlatform==TargetPlatform.iOS){
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        // print('Running on ${iosInfo.utsname.machine}');
        chDeviceName='${iosInfo.name} - ${iosInfo.model} - ${iosInfo.systemName} - ${iosInfo.utsname.machine} - ${iosInfo.utsname.sysname}';
        chAndroidVersion=iosInfo.utsname.version;

      }
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // print('Running on ${androidInfo.model}');
      chDeviceName =
          '${androidInfo.brand} - ${androidInfo.model} - ${androidInfo.device}';
      chAndroidVersion = androidInfo.version.release.toString();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      // print('Running on ${iosInfo.utsname.machine}');
      chDeviceName =
          '${iosInfo.name} - ${iosInfo.model} - ${iosInfo.systemName} - ${iosInfo.utsname.machine} - ${iosInfo.utsname.sysname}';
      chAndroidVersion = iosInfo.utsname.version;
    }

    object = {
      'chAdID': chAdID,
      // 'chFirebaseToken': null,
      'chApplicationVersion': chApplicationVersion,
      // 'chApplicationVersion': 'not set',
      'chDeviceName': chDeviceName,
      'chAndroidVersion': chAndroidVersion,
    };

    return object;
  }


  ///تشخیص نوع Direction متن
   bool isRTL(String? text,BuildContext context) {
    if(text==null || text ==''){
      // if(Directionality.of(context)==TextDirection.rtl){
      if(Directionality.of(context).name=="rtl"){
        return true;
      }
      else {
        return false;
      }
    }
    return Bidi.detectRtlDirectionality(text);
  }

  ///***
  /// این تابع یک ورودی عدد میگرد و یک حلقه به همان تعداد ایجاد میکند.
  ///
  /// [length]  ورودی
///تابع [execute] به ازای هر [index] اجرا میشود
  ///
  /// مثال:
  /// ```dart
  /// Future<void> useLoop() async {
  ///   String str = "";
  ///   await helperLoop(
  ///     length: 400000,
  ///     execute: (index) => str = '$str $index',
  ///   );
  ///   debugPrint(str);
  /// }
  /// ```
  Future<bool> helperLoop({
    required int length,
    required Function(int index) execute,
    int chunkLength = 25,
  }) {
    final completer =  Completer<bool>();
    Function(int i)? exec;
    exec = (i) {
      if (i >= length) return completer.complete(true);
      for (int j = i; j < min(length, i + chunkLength); j++) {
        execute(j);
      }
      Future.delayed(const Duration(milliseconds: 0), () {
        exec!(i + chunkLength);
      });
    };
    exec(0);
    return completer.future;
  }
}
