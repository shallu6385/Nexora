import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const Color attendanceBlue = Color(0xFF0B3473);

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final _subjectController = TextEditingController();

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _records => FirebaseFirestore
      .instance
      .collection('students')
      .doc(_uid)
      .collection('attendance');

  Future<void> _addSubject() async {
    final subject = _subjectController.text.trim();

    if (subject.isEmpty) return;

    await _records.add({
      'subject': subject,
      'attended': 0,
      'total': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });

    _subjectController.clear();
  }

  Future<void> _markAttendance(
    String id,
    Map<String, dynamic> data,
    bool present,
  ) async {
    final attended = (data['attended'] as num?)?.toInt() ?? 0;
    final total = (data['total'] as num?)?.toInt() ?? 0;

    await _records.doc(id).update({
      'attended': attended + (present ? 1 : 0),
      'total': total + 1,
    });
  }

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to view attendance.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Subject name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _addSubject,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _records.orderBy('subject').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Unable to load attendance.'),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final documents = snapshot.data!.docs;

                if (documents.isEmpty) {
                  return const Center(
                    child: Text('Add your first subject to begin.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final doc = documents[index];
                    final data = doc.data();

                    final attended = (data['attended'] as num?)?.toInt() ?? 0;
                    final total = (data['total'] as num?)?.toInt() ?? 0;

                    final percentage = total == 0
                        ? 0.0
                        : attended / total * 100;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['subject'] as String? ?? 'Subject',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              value: percentage / 100,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(8),
                              color: attendanceBlue,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$attended / $total classes attended'
                              ' • ${percentage.toStringAsFixed(1)}%',
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: [
                                ElevatedButton(
                                  onPressed: () =>
                                      _markAttendance(doc.id, data, true),
                                  child: const Text('Present'),
                                ),
                                OutlinedButton(
                                  onPressed: () =>
                                      _markAttendance(doc.id, data, false),
                                  child: const Text('Absent'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
