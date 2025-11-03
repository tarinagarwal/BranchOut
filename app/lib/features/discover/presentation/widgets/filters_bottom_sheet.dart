import 'package:flutter/material.dart';
import '../../../../app/constants.dart';

class FiltersBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onApply;

  const FiltersBottomSheet({
    super.key,
    required this.currentFilters,
    required this.onApply,
  });

  @override
  State<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<FiltersBottomSheet> {
  String? _experience;
  List<String> _techStack = [];
  List<String> _lookingFor = [];
  String? _location;

  @override
  void initState() {
    super.initState();
    _experience = widget.currentFilters['experience'];
    _techStack = List<String>.from(widget.currentFilters['techStack'] ?? []);
    _lookingFor = List<String>.from(widget.currentFilters['lookingFor'] ?? []);
    _location = widget.currentFilters['location'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: _clearFilters,
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Experience Level
                  const Text(
                    'Experience Level',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: AppConstants.experienceLevels.map((level) {
                      return FilterChip(
                        label: Text(level),
                        selected: _experience == level,
                        onSelected: (selected) {
                          setState(() {
                            _experience = selected ? level : null;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Tech Stack
                  const Text(
                    'Tech Stack',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _buildTechStackChips(),
                  ),
                  TextButton.icon(
                    onPressed: _showTechStackDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Technology'),
                  ),
                  const SizedBox(height: 24),

                  // Looking For
                  const Text(
                    'Looking For',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...AppConstants.lookingForOptions.map((option) {
                    return CheckboxListTile(
                      title: Text(option),
                      value: _lookingFor.contains(option),
                      onChanged: (selected) {
                        setState(() {
                          if (selected!) {
                            _lookingFor.add(option);
                          } else {
                            _lookingFor.remove(option);
                          }
                        });
                      },
                    );
                  }),
                  const SizedBox(height: 16),

                  // Location
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      hintText: 'e.g., San Francisco',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    controller: TextEditingController(text: _location),
                    onChanged: (value) => _location = value,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyFilters,
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTechStackChips() {
    return _techStack.map((tech) {
      return Chip(
        label: Text(tech),
        onDeleted: () {
          setState(() => _techStack.remove(tech));
        },
      );
    }).toList();
  }

  void _showTechStackDialog() {
    final commonTech = [
      'JavaScript', 'TypeScript', 'Python', 'Java', 'Go', 'Rust', 'C++', 'C#',
      'React', 'Vue', 'Angular', 'Flutter', 'React Native', 'Swift', 'Kotlin',
      'Node.js', 'Django', 'Spring', 'Express', 'FastAPI', 'Laravel',
      'MongoDB', 'PostgreSQL', 'MySQL', 'Redis', 'Firebase',
      'AWS', 'Azure', 'GCP', 'Docker', 'Kubernetes', 'Git'
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Technologies'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: commonTech.map((tech) {
              final isSelected = _techStack.contains(tech);
              return CheckboxListTile(
                title: Text(tech),
                value: isSelected,
                onChanged: (selected) {
                  setState(() {
                    if (selected!) {
                      if (!_techStack.contains(tech)) {
                        _techStack.add(tech);
                      }
                    } else {
                      _techStack.remove(tech);
                    }
                  });
                  Navigator.pop(context);
                  _showTechStackDialog();
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _experience = null;
      _techStack = [];
      _lookingFor = [];
      _location = null;
    });
  }

  void _applyFilters() {
    widget.onApply({
      'experience': _experience,
      'techStack': _techStack,
      'lookingFor': _lookingFor,
      'location': _location,
    });
    Navigator.pop(context);
  }
}
