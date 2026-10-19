import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const Color assignmentBlue = Color(0xFF0B3473);

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({super.key});

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool isSaving = false;

  // Add assignment to Firebase Firestore
  Future<void> addAssignment() async {
    if (isSaving) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      showMessage('Please log in first.');
      return;
    }

    final title = titleController.text.trim();
    final subject = subjectController.text.trim();

    if (title.isEmpty || subject.isEmpty) {
      showMessage('Please enter assignment title and subject.');
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await firestore.collection('assignments').add({
        'uid': user.uid,
        'title': title,
        'subject': subject,
        'completed': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      // Close the dialog only after Firestore confirms the save.
      Navigator.of(context).pop();

      showMessage('Assignment saved successfully!');
    } on FirebaseException catch (e) {
      if (!mounted) return;

      showMessage(
        'Firebase error (${e.code}): ${e.message ?? 'Unknown error'}',
      );
    } catch (e) {
      if (!mounted) return;

      showMessage('Unable to save assignment: $e');
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  // Display success and error messages
  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  // Open add assignment dialog
  void showAddAssignmentDialog() {
    titleController.clear();
    subjectController.clear();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Add Assignment',
                style: TextStyle(
                  color: assignmentBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Assignment Title',
                        hintText: 'Enter assignment title',
                        prefixIcon: Icon(Icons.assignment_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: subjectController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        hintText: 'Enter subject name',
                        prefixIcon: Icon(Icons.menu_book_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () {
                          Navigator.of(dialogContext).pop();
                        },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          setDialogState(() {});
                          await addAssignment();

                          if (mounted && isSaving) {
                            setDialogState(() {});
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: assignmentBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: isSaving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
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

  // Mark assignment completed or incomplete
  Future<void> updateCompletion(String documentId, bool completed) async {
    try {
      await firestore.collection('assignments').doc(documentId).update({
        'completed': completed,
      });
    } on FirebaseException catch (e) {
      showMessage('Update failed (${e.code}): ${e.message ?? ''}');
    } catch (e) {
      showMessage('Unable to update assignment: $e');
    }
  }

  // Delete assignment
  Future<void> deleteAssignment(String documentId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Assignment?'),
          content: const Text(
            'Are you sure you want to delete this assignment?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await firestore.collection('assignments').doc(documentId).delete();

      showMessage('Assignment deleted successfully.');
    } on FirebaseException catch (e) {
      showMessage('Delete failed (${e.code}): ${e.message ?? ''}');
    } catch (e) {
      showMessage('Unable to delete assignment: $e');
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Assignments',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: assignmentBlue,
        foregroundColor: Colors.white,
      ),
      body: user == null
          ? const Center(child: Text('Please log in to view your assignments.'))
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: firestore
                  .collection('assignments')
                  .where('uid', isEqualTo: user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Unable to load assignments.\n'
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: assignmentBlue),
                  );
                }

                final assignments = snapshot.data?.docs ?? [];

                if (assignments.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.assignment_outlined,
                            size: 76,
                            color: Colors.blueGrey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No Assignments Yet',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Tap the + button to add your first assignment.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: showAddAssignmentDialog,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Assignment'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: assignments.length,
                  itemBuilder: (context, index) {
                    final document = assignments[index];
                    final data = document.data();

                    final title =
                        data['title']?.toString() ?? 'Untitled Assignment';
                    final subject = data['subject']?.toString() ?? 'No Subject';
                    final completed = data['completed'] == true;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        leading: Checkbox(
                          value: completed,
                          activeColor: assignmentBlue,
                          onChanged: (value) {
                            updateCompletion(document.id, value ?? false);
                          },
                        ),
                        title: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            decoration: completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text('Subject: $subject'),
                        ),
                        trailing: IconButton(
                          tooltip: 'Delete assignment',
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => deleteAssignment(document.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showAddAssignmentDialog,
        backgroundColor: assignmentBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Assignment'),
      ),
    );
  }
}
