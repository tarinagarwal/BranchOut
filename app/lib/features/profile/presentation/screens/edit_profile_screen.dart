import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/constants.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;
  late TextEditingController _timezoneController;
  late TextEditingController _githubController;
  
  String _experience = 'Mid';
  String _availability = 'Active';
  List<String> _techStack = [];
  List<String> _lookingFor = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authStateProvider).value;
    
    _nameController = TextEditingController(text: user?.name ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _locationController = TextEditingController(text: user?.location ?? '');
    _timezoneController = TextEditingController(text: user?.timezone ?? '');
    _githubController = TextEditingController(text: user?.githubUsername ?? '');
    
    _experience = user?.experience ?? 'Mid';
    _availability = user?.availability ?? 'Active';
    _techStack = List.from(user?.techStack ?? []);
    _lookingFor = List.from(user?.lookingFor ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveProfile,
              child: const Text('Save'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile Photo
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    child: const Icon(Icons.person, size: 60),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 20),
                        onPressed: _pickImage,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Bio
            TextFormField(
              controller: _bioController,
              decoration: const InputDecoration(
                labelText: 'Bio',
                hintText: 'Tell others about yourself...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              maxLength: AppConstants.maxBioLength,
            ),
            const SizedBox(height: 16),

            // Location
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'e.g., San Francisco, CA',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 16),

            // Timezone
            TextFormField(
              controller: _timezoneController,
              decoration: const InputDecoration(
                labelText: 'Timezone',
                hintText: 'e.g., PST, EST, UTC+5',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
              ),
            ),
            const SizedBox(height: 16),

            // Experience Level
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
            const SizedBox(height: 16),

            // Availability
            DropdownButtonFormField<String>(
              value: _availability,
              decoration: const InputDecoration(
                labelText: 'Availability',
                border: OutlineInputBorder(),
              ),
              items: AppConstants.availabilityOptions
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _availability = value!),
            ),
            const SizedBox(height: 16),

            // GitHub Username
            TextFormField(
              controller: _githubController,
              decoration: const InputDecoration(
                labelText: 'GitHub Username',
                hintText: 'username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.code),
              ),
            ),
            const SizedBox(height: 24),

            // Tech Stack Section
            const Text(
              'Tech Stack',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

            // Looking For Section
            const Text(
              'Looking For',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
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
            const SizedBox(height: 24),

            // Danger Zone
            const Divider(),
            const Text(
              'Danger Zone',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _deactivateAccount,
              icon: const Icon(Icons.pause_circle_outline),
              label: const Text('Deactivate Account'),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.orange),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _deleteAccount,
              icon: const Icon(Icons.delete_forever),
              label: const Text('Delete Account'),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        ),
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
      'AWS', 'Azure', 'GCP', 'Docker', 'Kubernetes', 'Git', 'CI/CD'
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

  void _pickImage() {
    // TODO: Implement image picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image upload coming soon')),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(profileProvider.notifier).updateProfile({
        'name': _nameController.text,
        'bio': _bioController.text,
        'location': _locationController.text,
        'timezone': _timezoneController.text,
        'experience': _experience,
        'availability': _availability,
        'techStack': _techStack,
        'lookingFor': _lookingFor,
        'githubUsername': _githubController.text,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _deactivateAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate Account?'),
        content: const Text(
          'Your profile will be hidden and you won\'t receive matches. You can reactivate anytime.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement deactivate
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(profileProvider.notifier).deleteAccount();
                if (mounted) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete Forever'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _timezoneController.dispose();
    _githubController.dispose();
    super.dispose();
  }
}
