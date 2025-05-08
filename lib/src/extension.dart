import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:intl/intl.dart';

///تبدیل String به رنگ
extension ColorExtension on String {
  toColor() {
    try {
      var hexColor = replaceAll("#", "");
      if (hexColor.length == 6) {
        hexColor = "FF$hexColor";
      }

      else if (hexColor.length == 8) {
        hexColor="0x$hexColor";
      }
        return Color(int.parse(hexColor));
    }  catch (exception,stackTrace) {
      debugPrint(exception.toString());
      debugPrint(stackTrace.toString());
      Colors.transparent;
    }
  }
}

///یکسری کار بر روی context فعلی
extension MediaQueryValues on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}


///ساخت فضای خالی
extension EmptySpace on num{

  SizedBox get height => SizedBox(height:toDouble());

  SizedBox get width => SizedBox(width:toDouble());

}

///انجام یکسری کار بر روی لیست
extension ListExtension<T> on List<T> {
  ///وجود داشتن index در لیست
  bool indexExists(int index) {
    return index >= 0 && index < length;
  }
}

///تبدیل لیست dynamic   به لیست های دیگر
extension ListDynamicExtension on List<dynamic> {
///تبدیل لیست dynamic   به لیست Map
  List<Map<String, dynamic>> toMapList1() {
    return map((dynamic item) => item as Map<String, dynamic>).toList();
  }

///تبدیل لیست dynamic   به لیست Map
  List<Map<String, dynamic>> toMapList() {
    return map((dynamic item) {
      if (item is LinkedHashMap) {
        // Check if all keys are of type String
        if (item.keys.every((key) => key is String)) {
          return item.cast<String, dynamic>();
        } else {
          // Convert LinkedHashMap to Map<String, dynamic>
          return LinkedHashMap.fromIterable(item.entries, key: (e) => e.key as String, value: (e) => e.value).cast<String, dynamic>();
        }
      } else {
        return item as Map<String, dynamic>;
      }
    }).toList();
  }
}



/*

///تبدیل لیست به لیستی از نوع کشویی
extension ListDropDownExtension on List? {
  List<ModelDropDown>convertToListModelDropDown({String? extraKey}){
    if (this == null ||this!.isEmpty){
      return [];
    }
    else{
      List<ModelDropDown> dataDropDown=[];
      for(int i=0;i<this!.length;i++){
        ModelDropDown modelDropDown=ModelDropDown();
        modelDropDown.id=this![i]['guidRecNo'];
        modelDropDown.title=this![i]['chName'];
        if (extraKey!=null && extraKey.isNotEmpty) {
          modelDropDown.extra=this![i][extraKey];
        }

        dataDropDown.add(modelDropDown);

      }
      return dataDropDown;
    }
  }
}

*/


///تبدیل لیست List<Map <String,dynamic>> data   به لیست های دیگر
extension ListMapExtension<T> on List<Map<String,dynamic>> {
  List<String> getKeyValuesFromListMap(String key){
    if(isEmpty){
      return [];
    }
    List<String> listString = map((item) => (item[key]??'').toString()).toList();
    return listString;
  }
  void removeKey(String key) {
    for (var map in this) {
      map.remove(key);
    }
  }
}
///تبدیل لیست String به لیست دیگر
extension ListStringToListMapExtension<T> on List<String> {
///تبدیل لیست String به لیست Map< String,dynamic> object
  List<Map<String,dynamic>> listConvertStringToMap(String key){
    if(isEmpty){
      return [];
    }
    List<Map<String,dynamic>> listMap = map((item) => {key:item}).toList();
    return listMap;
  }
}
///
extension BoolExtension on bool?{
  ///چک کردن برای اینکه bool برای ارسال بع سمت سرور خالی نباشد
  bool validationBoolean(){
    if(this==null){
      return false;
    }
    else{
      return this!;
    }
  }
}
///جدا کننده قیمت
extension PriceSeparator on dynamic{
  ///قراردادن کارکتر قیمت
  ///1000.removePriceSeparator => '1000'
  String toPrice(){
    try {
      if(this==null || this==0 || this=='' ) {
        return '0';
      }
      // final formatter = NumberFormat('#,##0.00');
      else {
        final NumberFormat numberFormat = NumberFormat('#,###');
        // final NumberFormat numberFormatDouble = NumberFormat('###,#');
        String value= toString().replaceAll(',','');
        if(value.isNotEmpty){
          bool isDouble=value.contains('.');
          List splList=value.split('.');
          int numberPartOne=int.tryParse(splList[0])??0;
          int numberPartTwo=splList.indexExists(1)?int.tryParse(splList[1])??0:0;
          String formattedNumberPartOne = numberFormat.format(numberPartOne);
          String formattedNumberPartTwo = numberFormat.format(numberPartTwo);
          if(isDouble && numberPartTwo!=0){
            String txt='$formattedNumberPartOne.$formattedNumberPartTwo';
            return txt;
          }
          else{
            String txt=formattedNumberPartOne;
            return txt;
          }
        }
        else{
          return '0';
        }
      }
    } catch (exception,stackTrace) {

      debugPrint(exception.toString());
      debugPrint(stackTrace.toString());
      return '0';
    }
  }
  ///حذف کاراکتر جداکننده قیمت
  ///1,000.removePriceSeparator => '1000'
  String? removePriceSeparator(){
    if(this==null){
      return null;
    }
    else if(this.isEmpty){
      return "";
    }
    else{
      String value=toString().replaceAll(',','');
      return value;
    }
  }
  ///سه تا صفر اضافه می کند
  ///number * 1000
  /// 2.addThreeZer => '2,000'
  String addThreeZero(){
    if(this==null || this==0 || this==''){
      return '1,000';
    }
    else if(this is int){
      int value=this*1000;
      return value.toPrice();
    }
    else if(this is double){
      double value=this*1000;
      return value.toPrice();
    }
    else if(this is String){
        String txt=this.removePriceSeparator();
        if(txt.contains('.')){
          double value= (double.tryParse(txt)??0)*1000;
          return (value!=0?value:1000).toPrice();
        }
        else if(txt.contains('.')){
          int value= (int.tryParse(txt)??0)*1000;
          return (value!=0?value:1000).toPrice();
        }
      }
    return '';

    }
  ///validation for txt send to server
  String?   txtValidation(){
    if(this==null || this==''){
      return null;
    }
    else{
      return toString();
    }
  }
  String?   timeValidation(){
    if(this==null || this==''){
      return null;
    }
    else if(toString().length==1 ){
      return '${toString()}0:00:00';
    }
    else if(toString().length==2 ){
      return '${toString()}:00:00';
    }
    else if(toString().length==3 ){
      return '${toString()}00:00';
    }
    else if(toString().length==4 ){
      return '${toString()}0:00';
    }
    else if(toString().length==5 ){
      return '${toString()}:00';
    }
    else if(toString().length==6 ){
      return '${toString()}:0';
    }
    else if(toString().length==7 ){
      return '${toString()}0';
    }
    else if(toString().length>=8 ){
      return toString().substring(0,8);
    }else{
      return toString();
    }
  }
}
///عملیات بر روی String
extension StringExtention on String?{
  ///افزودن روز
  addDate(int numberDayAdd){
    try {
      if(this==null || this=='' ) {
        return '';
      }
      DateFormat dateFormat = DateFormat("yyyy/MM/dd");
      String dateStr = this!;
      DateTime dateTime = dateFormat.parse(dateStr);
      DateTime newDateTime = dateTime.add(Duration(days: numberDayAdd));
      String newDateString = DateFormat("yyyy/MM/dd").format(newDateTime);
      return newDateString;
    }  catch (exception,stackTrace) {
      debugPrint(exception.toString());
      debugPrint(stackTrace.toString());
      return '';
    }
  }
  ///کم کردن روز
  minusDate(int numberDayAdd){
    try {
      if(this==null || this=='' ) {
        return '';
      }
      DateFormat dateFormat = DateFormat("yyyy/MM/dd");
      String dateStr = this!;
      DateTime dateTime = dateFormat.parse(dateStr);
      DateTime newDateTime = dateTime.add(Duration(days: (-1)*numberDayAdd));
      String newDateString = DateFormat("yyyy/MM/dd").format(newDateTime);
      return newDateString;
    } catch (exception,stackTrace) {
      debugPrint(exception.toString());
      debugPrint(stackTrace.toString());
      return '';
    }
  }
  ///ساعت
  timeShow(){
    if(this==null || this==''){
      return '';
    }
    else if (this!.length>5){
      return this!.substring(0,5);
    }
    else{
      return this;
    }
  }
}
///تبدیل String به تاریخ
extension StringDate on String{
  DateTime? toDate(){
    try {
      DateFormat dateFormat = DateFormat("yyyy/MM/dd");
      String dateStr = this;
      DateTime newDateTime = dateFormat.parse(dateStr);
      return newDateTime;
    }  catch (exception,stackTrace) {
      debugPrint(exception.toString());
      debugPrint(stackTrace.toString());
      return null;
    }
  }

  ///example  final helloWorld = 'hello world'.toUpperCase(); // 'HELLO WORLD'
  ///example  final helloWorld = 'hello world'.toCapitalized(); // 'Hello world'
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  ///example  final helloWorldCap = 'hello world'.toTitleCase(); // 'Hello World'
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
  String firstCharToLowerCase() => length > 0 ?this[0].toLowerCase() + substring(1):'';

}


///تغییرات بر روی string
extension CharecterStr on String?{
///تبدیل به فارسی
  String? fixPersianChars() {
    if (this == null) return null;
    if (this!.isEmpty) return "";
    String data=this!.replaceAll("ي", "ی").replaceAll("ك", "ک").trim();
    return data;
  }
  String? fixSearchChars() {
    if (this == null) return null;
    if (this!.isEmpty) return "";
    String data=this!.replaceAll("ي", "ی").replaceAll("ك", "ک").trim();
    data = data.replaceAll("۰", "0");
    data = data.replaceAll("۱", "1");
    data = data.replaceAll("۲", "2");
    data = data.replaceAll("٣", "3");
    data = data.replaceAll("٤", "4");
    data = data.replaceAll("۵", "5");
    data = data.replaceAll("٦", "6");
    data = data.replaceAll("٧", "7");
    data = data.replaceAll("۸", "8");
    data = data.replaceAll("۹", "9");

    data = data.replaceAll(String.fromCharCode(1632), '0').replaceAll(String.fromCharCode(1776), '0');
    data = data.replaceAll(String.fromCharCode(1633), '1').replaceAll(String.fromCharCode(1777), '1');
    data = data.replaceAll(String.fromCharCode(1634), '2').replaceAll(String.fromCharCode(1778), '2');
    data = data.replaceAll(String.fromCharCode(1635), '3').replaceAll(String.fromCharCode(1779), '3');
    data = data.replaceAll(String.fromCharCode(1636), '4').replaceAll(String.fromCharCode(1780), '4');
    data = data.replaceAll(String.fromCharCode(1637), '5').replaceAll(String.fromCharCode(1781), '5');
    data = data.replaceAll(String.fromCharCode(1638), '6').replaceAll(String.fromCharCode(1782), '6');
    data = data.replaceAll(String.fromCharCode(1639), '7').replaceAll(String.fromCharCode(1783), '7');
    data = data.replaceAll(String.fromCharCode(1640), '8').replaceAll(String.fromCharCode(1784), '8');
    data = data.replaceAll(String.fromCharCode(1641), '9').replaceAll(String.fromCharCode(1785), '9');
    return data;

  }
  String? toEnglishDigit() {
    if (this == null) return null;
    if (this!.isEmpty) return "";
    String data=this!;
    data = data.replaceAll("۰", "0");
    data = data.replaceAll("۱", "1");
    data = data.replaceAll("۲", "2");
    data = data.replaceAll("٣", "3");
    data = data.replaceAll("٤", "4");
    data = data.replaceAll("۵", "5");
    data = data.replaceAll("٦", "6");
    data = data.replaceAll("٧", "7");
    data = data.replaceAll("۸", "8");
    data = data.replaceAll("۹", "9");

    data = data.replaceAll(String.fromCharCode(1632), '0').replaceAll(String.fromCharCode(1776), '0');
    data = data.replaceAll(String.fromCharCode(1633), '1').replaceAll(String.fromCharCode(1777), '1');
    data = data.replaceAll(String.fromCharCode(1634), '2').replaceAll(String.fromCharCode(1778), '2');
    data = data.replaceAll(String.fromCharCode(1635), '3').replaceAll(String.fromCharCode(1779), '3');
    data = data.replaceAll(String.fromCharCode(1636), '4').replaceAll(String.fromCharCode(1780), '4');
    data = data.replaceAll(String.fromCharCode(1637), '5').replaceAll(String.fromCharCode(1781), '5');
    data = data.replaceAll(String.fromCharCode(1638), '6').replaceAll(String.fromCharCode(1782), '6');
    data = data.replaceAll(String.fromCharCode(1639), '7').replaceAll(String.fromCharCode(1783), '7');
    data = data.replaceAll(String.fromCharCode(1640), '8').replaceAll(String.fromCharCode(1784), '8');
    data = data.replaceAll(String.fromCharCode(1641), '9').replaceAll(String.fromCharCode(1785), '9');
    return data;

  }
}



///padding For Widgets
extension PaddingWiget on Widget{
  Widget withPadding([EdgeInsetsGeometry padding =const EdgeInsets.all(8.0)]){
    return Padding(padding: padding,child: this,);
  }
}

///Border Radius  For Widgets
extension RoundedCorner on Widget{
  Widget withRoundedCorner([double radius=12]){
    return ClipRRect(borderRadius: BorderRadius.circular(radius),child: this,);
  }
}