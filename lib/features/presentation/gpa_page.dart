import 'package:flutter/material.dart';

class GpaPage extends StatefulWidget {
  const GpaPage({super.key});

  @override
  State<GpaPage> createState() => _GpaPageState();
}

class _GpaPageState extends State<GpaPage> {
  final List<_SubjectGrade> _subjects = [_SubjectGrade()];

  double? _gpa;

  void _addSubject() {
    setState(() {
      _subjects.add(_SubjectGrade());
      _gpa = null;
    });
  }

  void _calculateGpa() {
    double weightedPoints = 0;
    double totalCredits = 0;

    for (final subject in _subjects) {
      final credits = double.tryParse(subject.credits.text.trim());

      if (credits == null || credits <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enter valid positive credits for every subject.'),
          ),
        );
        return;
      }

      weightedPoints += credits * subject.gradePoint;
      totalCredits += credits;
    }

    if (totalCredits == 0) return;

    setState(() {
      _gpa = weightedPoints / totalCredits;
    });
  }

  @override
  void dispose() {
    for (final subject in _subjects) {
      subject.credits.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Semester GPA Calculator')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Enter each subject’s credits and grade.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ...List.generate(_subjects.length, (index) {
            final subject = _subjects[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Subject ${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (_subjects.length > 1)
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _subjects.removeAt(index);
                                subject.credits.dispose();
                                _gpa = null;
                              });
                            },
                            icon: const Icon(Icons.delete_outline),
                          ),
                      ],
                    ),
                    TextField(
                      controller: subject.credits,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Credits',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: subject.grade,
                      decoration: const InputDecoration(
                        labelText: 'Grade',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'O', child: Text('O - 10')),
                        DropdownMenuItem(value: 'A+', child: Text('A+ - 9')),
                        DropdownMenuItem(value: 'A', child: Text('A - 8')),
                        DropdownMenuItem(value: 'B+', child: Text('B+ - 7')),
                        DropdownMenuItem(value: 'B', child: Text('B - 6')),
                        DropdownMenuItem(value: 'C', child: Text('C - 5')),
                        DropdownMenuItem(value: 'U', child: Text('U - 0')),
                      ],
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          subject.grade = value;
                          _gpa = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
          OutlinedButton.icon(
            onPressed: _addSubject,
            icon: const Icon(Icons.add),
            label: const Text('Add Subject'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _calculateGpa,
            child: const Text('Calculate GPA'),
          ),
          if (_gpa != null) ...[
            const SizedBox(height: 24),
            Card(
              color: const Color(0xFFE3EDFF),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text('Your Semester GPA'),
                    const SizedBox(height: 8),
                    Text(
                      _gpa!.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B3473),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SubjectGrade {
  final TextEditingController credits = TextEditingController();

  String grade = 'A';

  double get gradePoint {
    const points = {
      'O': 10.0,
      'A+': 9.0,
      'A': 8.0,
      'B+': 7.0,
      'B': 6.0,
      'C': 5.0,
      'U': 0.0,
    };

    return points[grade] ?? 0;
  }
}
