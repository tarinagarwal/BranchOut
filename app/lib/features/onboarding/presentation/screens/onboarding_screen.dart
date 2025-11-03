import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form data
  String? _bio;
  String? _location;
  String? _timezone;
  String _experience = 'Mid';
  List<String> _techStack = [];
  List<String> _lookingFor = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Profile (${_currentPage + 1}/4)'),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (page) => setState(() => _currentPage = page),
        children: [
          _buildBasicInfoPage(),
          _buildTechStackPage(),
          _buildGoalsPage(),
          _buildProjectsPage(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (_currentPage > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  child: const Text('Back'),
                ),
              ),
            if (_currentPage > 0) const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _currentPage == 3 ? _completeOnboarding : _nextPage,
                child: Text(_currentPage == 3 ? 'Complete' : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tell us about yourself',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Bio',
              hintText: 'Tell others about yourself...',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            maxLength: AppConstants.maxBioLength,
            onChanged: (value) => _bio = value,
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Location',
              hintText: 'e.g., San Francisco, CA',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => _location = value,
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Timezone',
              hintText: 'e.g., PST, EST, UTC+5',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => _timezone = value,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _experience,
            decoration: const InputDecoration(
              labelText: 'Experience Level',
              border: OutlineInputBorder(),
            ),
            items: AppConstants.experienceLevels
                .map((level) => DropdownMenuItem(
                      value: level,
                      child: Text(level),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _experience = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildTechStackPage() {
    final commonTech = [
      'JavaScript', 'TypeScript', 'Python', 'Java', 'Go', 'Rust',
      'React', 'Vue', 'Angular', 'Flutter', 'React Native',
      'Node.js', 'Django', 'Spring', 'Express',
      'MongoDB', 'PostgreSQL', 'MySQL', 'Redis',
      'AWS', 'Docker', 'Kubernetes', 'Git'
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select your tech stack',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Choose technologies you work with'),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: commonTech.map((tech) {
              final isSelected = _techStack.contains(tech);
              return FilterChip(
                label: Text(tech),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _techStack.add(tech);
                    } else {
                      _techStack.remove(tech);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What are you looking for?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Select all that apply'),
          const SizedBox(height: 24),
          ...AppConstants.lookingForOptions.map((option) {
            final isSelected = _lookingFor.contains(option);
            return CheckboxListTile(
              title: Text(option),
              value: isSelected,
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
        ],
      ),
    );
  }

  Widget _buildProjectsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add your projects (Optional)',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Showcase your best work'),
          const SizedBox(height: 24),
          const Text('You can add projects later from your profile'),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Navigate to add project screen
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Project'),
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() async {
    // TODO: Save profile data to backend
    // For now, just navigate to main screen
    if (mounted) {
      context.go('/');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
