import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';

// Function to format a date
String? formatDate(DateTime? _date){
  if (_date == null){
    return null;
  }
  return "${_date?.day} / ${_date?.month} / ${_date?.year}";
}

void getDate(BuildContext context, {required Function(DateTime?) onSelect}) {
	showDatePicker(context: context, 
	firstDate: DateTime(2020),
	lastDate: DateTime(2095));
}
