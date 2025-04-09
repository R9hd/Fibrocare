import 'dart:ui';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:fibercare/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'notification_service.dart';
import 'language_manager.dart';

class SleepSchedulePage extends StatefulWidget {
  const SleepSchedulePage({Key? key}) : super(key: key);

  @override
  _SleepSchedulePageState createState() => _SleepSchedulePageState();
}

class _SleepSchedulePageState extends State<SleepSchedulePage> {
  DateTime _sleepStartTime = DateTime.now().add(const Duration(hours: 1));
  DateTime _sleepEndTime = DateTime.now().add(const Duration(hours: 8));
  final NotificationService _notificationService = NotificationService();
  String _lastSavedTime = '';

  @override
  void initState() {
    super.initState();
    _initializeTimeZones();
    _initializeNotifications();
  }

  Future<void> _initializeTimeZones() async {
    try {
      tz.initializeTimeZones();
    } catch (e) {
      debugPrint('Error initializing time zones: $e');
    }
  }

  Future<void> _initializeNotifications() async {
    try {
      await _notificationService.initNotification();
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  Future<void> _showDateTimePicker(BuildContext context, bool isStartTime) async {
    final selectedDateTime = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        DateTime initialDate = isStartTime ? _sleepStartTime : _sleepEndTime;
        return AlertDialog(
          title: Text(isStartTime 
              ? languageManager.translate('selectSleepStartTime')
              : languageManager.translate('selectSleepEndTime')),
          content: SizedBox(
            width: double.maxFinite,
            child: DateTimePicker(
              type: DateTimePickerType.dateTime,
              initialValue: initialDate.toString(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              dateLabelText: languageManager.translate('date'),
              timeLabelText: languageManager.translate('time'),
              onChanged: (val) => initialDate = DateTime.parse(val),
              validator: (val) => null,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(languageManager.translate('cancel')),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, initialDate),
              child: Text(languageManager.translate('ok')),
            ),
          ],
        );
      },
    );

    if (selectedDateTime != null) {
      setState(() {
        if (isStartTime) {
          _sleepStartTime = selectedDateTime;
        } else {
          _sleepEndTime = selectedDateTime;
        }
      });
    }
  }

  Future<void> _scheduleSleepNotifications() async {
    try {
      await _notificationService.scheduleNotification(
        id: 1,
        title: languageManager.translate('sleepReminder'),
        body: languageManager.translate('sleepReminderBody'),
        scheduledNotificationDateTime: _sleepStartTime,
      );

      await _notificationService.scheduleNotification(
        id: 2,
        title: languageManager.translate('wakeUpReminder'),
        body: languageManager.translate('wakeUpReminderBody'),
        scheduledNotificationDateTime: _sleepEndTime,
      );

      setState(() {
        _lastSavedTime = '${languageManager.translate('notificationsScheduled')}:\n'
            '${_formatDateTime(_sleepStartTime)}\n'
            '${_formatDateTime(_sleepEndTime)}';
      });
    } catch (e) {
      setState(() {
        _lastSavedTime = languageManager.translate('failedToSchedule');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color tertiary = Theme.of(context).colorScheme.tertiary;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(languageManager.translate('sleepSchedule'), 
            style: TextStyle(color: tertiary)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: tertiary),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Homepage()),
            );
          },
        ),
      ),
      backgroundColor: const Color(0xFFd4e8eb),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  languageManager.translate('sleepSchedule'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Text(languageManager.translate('sleepTime')),
              subtitle: Text(_formatDateTime(_sleepStartTime)),
              trailing: const Icon(Icons.access_time),
              onTap: () => _showDateTimePicker(context, true),
            ),
            ListTile(
              title: Text(languageManager.translate('wakeUpTime')),
              subtitle: Text(_formatDateTime(_sleepEndTime)),
              trailing: const Icon(Icons.access_time),
              onTap: () => _showDateTimePicker(context, false),
            ),
            if (_lastSavedTime.isNotEmpty) ...[
              const SizedBox(height: 20),
              Center(
                child: Text(
                  _lastSavedTime,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                child: Text(
                  languageManager.translate('scheduleNotifications'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: _scheduleSleepNotifications,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(dt);
  }
}