import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Please log in before accessing your profile.');
    }

    return user.uid;
  }

  DocumentReference<Map<String, dynamic>> get _studentDocument {
    return _firestore.collection('students').doc(_uid);
  }

  // Save or update student profile
  Future<void> saveStudentProfile({
    required String name,
    required String email,
    required String department,
    required String registerNumber,
    String phone = '',
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Please log in before saving your profile.');
    }

    await _firestore.collection('students').doc(user.uid).set({
      'name': name.trim(),
      'email': email.trim(),
      'department': department.trim(),
      'registerNumber': registerNumber.trim(),
      'phone': phone.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Retrieve student profile
  Future<Map<String, dynamic>?> getStudentProfile() async {
    final snapshot = await _studentDocument.get();

    if (!snapshot.exists) {
      return null;
    }

    return snapshot.data();
  }

  // Add an assignment
  Future<void> addAssignment({
    required String title,
    required DateTime dueDate,
  }) async {
    await _studentDocument.collection('assignments').add({
      'title': title.trim(),
      'dueDate': Timestamp.fromDate(dueDate),
      'completed': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Read assignments
  Stream<QuerySnapshot<Map<String, dynamic>>> getAssignments() {
    return _studentDocument
        .collection('assignments')
        .orderBy('dueDate')
        .snapshots();
  }

  // Update assignment status
  Future<void> updateAssignmentStatus({
    required String assignmentId,
    required bool completed,
  }) async {
    await _studentDocument.collection('assignments').doc(assignmentId).update({
      'completed': completed,
    });
  }

  // Delete assignment
  Future<void> deleteAssignment(String assignmentId) async {
    await _studentDocument.collection('assignments').doc(assignmentId).delete();
  }

  // Add study note
  Future<void> addNote({required String title, required String content}) async {
    await _studentDocument.collection('notes').add({
      'title': title.trim(),
      'content': content.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Read study notes
  Stream<QuerySnapshot<Map<String, dynamic>>> getNotes() {
    return _studentDocument
        .collection('notes')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Delete study note
  Future<void> deleteNote(String noteId) async {
    await _studentDocument.collection('notes').doc(noteId).delete();
  }
}
