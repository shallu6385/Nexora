import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const Color timetableBlue = Color(0xFF0B3473);

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();

  String _day = 'Monday';

  TimeOfDay _start = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _end = const TimeOfDay(hour: 10, minute: 0);

  bool _isSaving = false;

  final List<String> _days = const [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  CollectionReference<Map<String, dynamic>> get _classes {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Please log in first.');
    }

    return FirebaseFirestore.instance
        .collection('students')
        .doc(user.uid)
        .collection('timetable');
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  Future<void> _addClass() async {
    if (_isSaving) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showMessage('Please log in before saving your timetable.');
      return;
    }

    final subject = _subjectController.text.trim();
    final room = _roomController.text.trim();

    if (subject.isEmpty) {
      _showMessage('Please enter a subject name.');
      return;
    }

    final startMinutes = _start.hour * 60 + _start.minute;
    final endMinutes = _end.hour * 60 + _end.minute;

    if (endMinutes <= startMinutes) {
      _showMessage('End time must be after start time.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _classes.add({
        'uid': user.uid,
        'subject': subject,
        'room': room,
        'day': _day,
        'startMinutes': startMinutes,
        'endMinutes': endMinutes,
        'startTime': _formatTime(_start),
        'endTime': _formatTime(_end),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      Navigator.of(context).pop();

      _subjectController.clear();
      _roomController.clear();

      _showMessage('Class saved successfully!');
    } on FirebaseException catch (e) {
      _showMessage(
        'Firebase error (${e.code}): ${e.message ?? 'Unable to save class.'}',
      );
    } catch (e) {
      _showMessage('Unable to save class: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _showAddDialog() async {
    _subjectController.clear();
    _roomController.clear();

    _day = 'Monday';
    _start = const TimeOfDay(hour: 9, minute: 0);
    _end = const TimeOfDay(hour: 10, minute: 0);

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Class'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _subjectController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        prefixIcon: Icon(Icons.menu_book_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _roomController,
                      decoration: const InputDecoration(
                        labelText: 'Classroom',
                        prefixIcon: Icon(Icons.room_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _day,
                      decoration: const InputDecoration(
                        labelText: 'Day',
                        border: OutlineInputBorder(),
                      ),
                      items: _days.map((day) {
                        return DropdownMenuItem(value: day, child: Text(day));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            _day = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Start time'),
                      trailing: Text(_formatTime(_start)),
                      onTap: () async {
                        final result = await showTimePicker(
                          context: dialogContext,
                          initialTime: _start,
                        );

                        if (result != null) {
                          setDialogState(() {
                            _start = result;
                          });
                        }
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('End time'),
                      trailing: Text(_formatTime(_end)),
                      onTap: () async {
                        final result = await showTimePicker(
                          context: dialogContext,
                          initialTime: _end,
                        );

                        if (result != null) {
                          setDialogState(() {
                            _end = result;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: _isSaving
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _isSaving
                      ? null
                      : () async {
                          await _addClass();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: timetableBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteClass(
    DocumentReference<Map<String, dynamic>> reference,
  ) async {
    try {
      await reference.delete();
      _showMessage('Class deleted successfully.');
    } on FirebaseException catch (e) {
      _showMessage(
        'Delete error (${e.code}): ${e.message ?? 'Unable to delete class.'}',
      );
    } catch (e) {
      _showMessage('Unable to delete class: $e');
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to view your timetable.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Timetable',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: timetableBlue,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        backgroundColor: timetableBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Class'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _classes.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Unable to load timetable.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: timetableBlue),
            );
          }

          final docs = [...?snapshot.data?.docs];

          const order = [
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday',
            'Sunday',
          ];

          docs.sort((a, b) {
            final dataA = a.data();
            final dataB = b.data();

            final dayA = order.indexOf(dataA['day'] as String? ?? '');
            final dayB = order.indexOf(dataB['day'] as String? ?? '');

            if (dayA != dayB) {
              return dayA.compareTo(dayB);
            }

            final startA = (dataA['startMinutes'] as num?)?.toInt() ?? 0;
            final startB = (dataB['startMinutes'] as num?)?.toInt() ?? 0;

            return startA.compareTo(startB);
          });

          if (docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 72,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No Classes Yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add your classes to create your weekly timetable.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _showAddDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Class'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();

              final subject = data['subject']?.toString() ?? 'Untitled Subject';
              final day = data['day']?.toString() ?? '';
              final startTime = data['startTime']?.toString() ?? '';
              final endTime = data['endTime']?.toString() ?? '';
              final room = data['room']?.toString() ?? '';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE8EEF8),
                    child: Icon(Icons.menu_book_outlined, color: timetableBlue),
                  ),
                  title: Text(
                    subject,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '$day • $startTime - $endTime\n'
                      'Room: ${room.isEmpty ? 'Not specified' : room}',
                    ),
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    tooltip: 'Delete class',
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _deleteClass(doc.reference),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
