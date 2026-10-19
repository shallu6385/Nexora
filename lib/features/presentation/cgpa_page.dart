import 'package:flutter/material.dart';

class CgpaPage extends StatefulWidget {
  const CgpaPage({super.key});

  @override
  State<CgpaPage> createState() => _CgpaPageState();
}

class _CgpaPageState extends State<CgpaPage> {
  final List<_Semester> _semesters = [_Semester()];

  double? _cgpa;

  void _addSemester() {
    setState(() {
      _semesters.add(_Semester());
      _cgpa = null;
    });
  }

  void _calculate() {
    double weightedTotal = 0;
    double creditTotal = 0;

    for (final semester in _semesters) {
      final gpa = double.tryParse(semester.gpa.text.trim());
      final credits = double.tryParse(semester.credits.text.trim());

      if (gpa == null ||
          gpa < 0 ||
          gpa > 10 ||
          credits == null ||
          credits <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Enter a GPA from 0 to 10 and positive semester credits.',
            ),
          ),
        );
        return;
      }

      weightedTotal += gpa * credits;
      creditTotal += credits;
    }

    setState(() {
      _cgpa = creditTotal == 0 ? null : weightedTotal / creditTotal;
    });
  }

  @override
  void dispose() {
    for (final semester in _semesters) {
      semester.gpa.dispose();
      semester.credits.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CGPA Calculator')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Enter the GPA and total credits for each semester.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ...List.generate(_semesters.length, (index) {
            final semester = _semesters[index];

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
                            'Semester ${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (_semesters.length > 1)
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _semesters.removeAt(index);
                                semester.gpa.dispose();
                                semester.credits.dispose();
                                _cgpa = null;
                              });
                            },
                            icon: const Icon(Icons.delete_outline),
                          ),
                      ],
                    ),
                    TextField(
                      controller: semester.gpa,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Semester GPA',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: semester.credits,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Semester credits',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          OutlinedButton.icon(
            onPressed: _addSemester,
            icon: const Icon(Icons.add),
            label: const Text('Add Semester'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _calculate,
            child: const Text('Calculate CGPA'),
          ),
          if (_cgpa != null) ...[
            const SizedBox(height: 24),
            Card(
              color: const Color(0xFFE3EDFF),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text('Your CGPA'),
                    const SizedBox(height: 8),
                    Text(
                      _cgpa!.toStringAsFixed(2),
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

class _Semester {
  final TextEditingController gpa = TextEditingController();
  final TextEditingController credits = TextEditingController();
}
