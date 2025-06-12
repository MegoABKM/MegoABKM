import 'package:flutter/material.dart';

class TimetableEntry {
  final int id;
  final String subjectName;
  final String timeSlot;
  final String day;

  TimetableEntry(this.id, this.subjectName, this.timeSlot, this.day);
}

class TimetableEntryCreate {
  String subjectName;
  String timeSlot;
  String day;

  TimetableEntryCreate(this.subjectName, this.timeSlot, this.day);
}

class TimetableData {
  final List<TimetableEntry> entries;
  final List<String> days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  final List<String> timeSlots = [
    '8:00-9:00',
    '9:00-10:00',
    '10:00-11:00',
    '11:00-12:00',
    '12:00-13:00'
  ];

  TimetableData({required this.entries});

  // Build a map of timeSlot -> day -> subjectName
  Map<String, Map<String, String>> buildTimetableMap() {
    final timetableMap = <String, Map<String, String>>{};

    // Initialize the map with empty strings
    for (var timeSlot in timeSlots) {
      timetableMap[timeSlot] = {for (var day in days) day: ''};
    }

    // Populate with entries
    for (var entry in entries) {
      if (timetableMap.containsKey(entry.timeSlot) &&
          days.contains(entry.day)) {
        timetableMap[entry.timeSlot]![entry.day] = entry.subjectName;
      }
    }

    return timetableMap;
  }

  // Convert to DataTable rows
  List<DataRow> buildDataRows() {
    final timetableMap = buildTimetableMap();
    return timeSlots.map((timeSlot) {
      final cells = <DataCell>[
        DataCell(Text(timeSlot)), // Time column
        ...days.map((day) => DataCell(Text(timetableMap[timeSlot]![day]!))),
      ];
      return DataRow(cells: cells);
    }).toList();
  }
}
