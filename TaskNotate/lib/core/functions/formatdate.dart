// core/functions/formatdate.dart

import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import intl package

// Keep your existing formatDate if you still need it elsewhere for date-only
String formatDate(String? date) {
  if (date == null || date.isEmpty) return "328".tr; // No date provided
  try {
    final parsedDate = DateTime.parse(date.trim());
    // Using DateFormat for locale-aware date formatting if needed, otherwise simple string interpolation
    return DateFormat('yyyy-MM-dd').format(parsedDate); // Example: 2023-10-27
    // return "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
  } catch (e) {
    return "329".tr; // Invalid date
  }
}

// New function for date and time
String formatDateTime(String? dateTimeString) {
  if (dateTimeString == null || dateTimeString.isEmpty)
    return "328".tr; // No date/time provided
  try {
    final parsedDateTime = DateTime.parse(dateTimeString.trim());
    // Format: "dd MMM yyyy, hh:mm a" (e.g., "27 Oct 2023, 02:30 PM")
    // You can customize the format string as needed.
    // For example: 'yyyy-MM-dd HH:mm:ss' for 24-hour format with seconds
    // Or 'dd/MM/yyyy hh:mm a'
    return DateFormat('dd MMM yyyy, hh:mm a').format(parsedDateTime);
  } catch (e) {
    print(
        "Error parsing date-time for formatting: $e"); // Log the error for debugging
    return "329".tr; // Invalid date/time
  }
}
