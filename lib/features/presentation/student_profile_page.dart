import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/student_service.dart';

const Color profileBlue = Color(0xFF0B3473);

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  final StudentService _service = StudentService();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _departmentController = TextEditingController();
  final _registerController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _loading = true;
  bool _saving = false;

  String get _email => FirebaseAuth.instance.currentUser?.email ?? '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _service.getStudentProfile();

      if (!mounted) return;

      _nameController.text = profile?['name'] as String? ?? '';
      _departmentController.text = profile?['department'] as String? ?? '';
      _registerController.text = profile?['registerNumber'] as String? ?? '';
      _phoneController.text = profile?['phone'] as String? ?? '';
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to load profile: $e')));
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      await _service.saveStudentProfile(
        name: _nameController.text.trim(),
        email: _email,
        department: _departmentController.text.trim(),
        registerNumber: _registerController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to save profile: $e')));
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    IconData icon = Icons.edit_outlined,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: profileBlue),
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Enter $label.';
          }

          if (label == 'Phone number' &&
              !RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
            return 'Enter a valid 10-digit phone number.';
          }

          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _departmentController.dispose();
    _registerController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Profile')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 46,
                      backgroundColor: Color(0xFFE3EDFF),
                      child: Icon(Icons.person, size: 54, color: profileBlue),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 28),
                    _field(
                      'Full name',
                      _nameController,
                      icon: Icons.person_outline,
                    ),
                    _field(
                      'Department',
                      _departmentController,
                      icon: Icons.school_outlined,
                    ),
                    _field(
                      'Register number',
                      _registerController,
                      icon: Icons.badge_outlined,
                    ),
                    _field(
                      'Phone number',
                      _phoneController,
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _saving ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: profileBlue,
                          foregroundColor: Colors.white,
                        ),
                        child: _saving
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Save Profile'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
