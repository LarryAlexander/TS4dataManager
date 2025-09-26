import 'package:flutter/material.dart';
import 'services/profile_service.dart';
import 'models/profile.dart';
import 'platform/sims4_discovery.dart';
import 'platform/path_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TS4 Data Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TS4 Data Manager'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1; // Start on Profiles tab
  final ProfileService _profileService = ProfileService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About TS4 Data Manager',
            onPressed: () => _showAboutDialog(context),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.history),
                label: Text('History'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Profiles'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.import_export),
                label: Text('Export/Import'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                const HistoryPage(),
                ProfilesPage(profileService: _profileService),
                const ExportImportPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'TS4 Data Manager',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.folder_special, size: 64),
      children: [
        const Text(
          'A git-style data manager for The Sims 4 that coexists with mod managers.',
        ),
        const SizedBox(height: 16),
        const Text('Features:'),
        const Text('• Non-destructive backup and restore'),
        const Text('• Profile management with versioning'),
        const Text('• Export/import for sharing configurations'),
        const Text('• Privacy-focused (no telemetry by default)'),
      ],
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'History',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Create a profile to start tracking changes'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Snapshots and change history will appear here once you have an active profile.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilesPage extends StatefulWidget {
  final ProfileService profileService;

  const ProfilesPage({super.key, required this.profileService});

  @override
  State<ProfilesPage> createState() => _ProfilesPageState();
}

class _ProfilesPageState extends State<ProfilesPage> {
  List<Profile> _profiles = [];
  bool _isLoading = true;
  String? _discoveredSims4Path;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
    _discoverSims4Path();
  }

  Future<void> _loadProfiles() async {
    try {
      final profiles = widget.profileService.profiles;
      if (mounted) {
        setState(() {
          _profiles = profiles;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load profiles: $e')));
      }
    }
  }

  Future<void> _discoverSims4Path() async {
    try {
      final path = await Sims4Discovery.discoverSims4UserFolder();
      if (mounted) {
        setState(() {
          _discoveredSims4Path = path;
        });
      }
    } catch (e) {
      // Discovery failure is not critical
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Profiles',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showCreateProfileDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Create Profile'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_discoveredSims4Path != null) ...[
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Sims 4 folder detected'),
                          Text(
                            PathUtils.sanitizePathForDisplay(
                              _discoveredSims4Path!,
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _profiles.isEmpty
                ? _buildEmptyState()
                : _buildProfileGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'No profiles yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first profile to start managing your Sims 4 data',
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showCreateProfileDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Create Your First Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: _profiles.length,
      itemBuilder: (context, index) {
        final profile = _profiles[index];
        return Card(
          elevation: 2,
          child: InkWell(
            onTap: () => _selectProfile(profile),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          profile.label,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (action) =>
                            _handleProfileAction(action, profile),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 20),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 20, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Storage: ${PathUtils.sanitizePathForDisplay(profile.storagePath)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontFamily: 'monospace',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    'Created: ${_formatDate(profile.createdAt)}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _showCreateProfileDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) => CreateProfileDialog(
        profileService: widget.profileService,
        discoveredSims4Path: _discoveredSims4Path,
        onProfileCreated: () {
          _loadProfiles();
        },
      ),
    );
  }

  void _selectProfile(Profile profile) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected profile: ${profile.label}'),
        action: SnackBarAction(
          label: 'VIEW',
          onPressed: () {
            // TODO: Navigate to profile details
          },
        ),
      ),
    );
  }

  void _handleProfileAction(String action, Profile profile) {
    switch (action) {
      case 'edit':
        // TODO: Show edit dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Edit ${profile.label} (coming soon)')),
        );
        break;
      case 'delete':
        _confirmDeleteProfile(profile);
        break;
    }
  }

  Future<void> _confirmDeleteProfile(Profile profile) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile'),
        content: Text(
          'Are you sure you want to delete "${profile.label}"?\n\n'
          'This will remove the profile configuration but will not delete your Sims 4 data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await widget.profileService.deleteProfile(profile.id);
        _loadProfiles();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Deleted profile: ${profile.label}')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete profile: $e')),
          );
        }
      }
    }
  }
}

class CreateProfileDialog extends StatefulWidget {
  final ProfileService profileService;
  final String? discoveredSims4Path;
  final VoidCallback onProfileCreated;

  const CreateProfileDialog({
    super.key,
    required this.profileService,
    this.discoveredSims4Path,
    required this.onProfileCreated,
  });

  @override
  State<CreateProfileDialog> createState() => _CreateProfileDialogState();
}

class _CreateProfileDialogState extends State<CreateProfileDialog> {
  final _nameController = TextEditingController();
  final _sims4PathController = TextEditingController();
  final _storagePathController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isCreating = false;
  PathValidationResult? _sims4ValidationResult;
  PathValidationResult? _storageValidationResult;

  @override
  void initState() {
    super.initState();
    if (widget.discoveredSims4Path != null) {
      _sims4PathController.text = widget.discoveredSims4Path!;
      _validateSims4Path();
    }
    _storagePathController.text = PathUtils.getDefaultStoragePath();
    _validateStoragePath();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sims4PathController.dispose();
    _storagePathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Profile'),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Profile Name',
                  hintText: 'My Sims Profile',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a profile name';
                  }
                  return null;
                },
                autofocus: true,
              ),
              const SizedBox(height: 16),
              _buildPathField(
                controller: _sims4PathController,
                label: 'Sims 4 User Folder',
                hint: 'Path to your Sims 4 user data folder',
                validationResult: _sims4ValidationResult,
                onValidate: _validateSims4Path,
                onBrowse: _browseSims4Path,
              ),
              const SizedBox(height: 16),
              _buildPathField(
                controller: _storagePathController,
                label: 'Profile Storage Path',
                hint: 'Where to store profile data',
                validationResult: _storageValidationResult,
                onValidate: _validateStoragePath,
                onBrowse: _browseStoragePath,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isCreating ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _canCreate() ? _createProfile : null,
          child: _isCreating
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }

  Widget _buildPathField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required PathValidationResult? validationResult,
    required VoidCallback onValidate,
    required VoidCallback onBrowse,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  hintText: hint,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: onValidate,
                        tooltip: 'Validate path',
                      ),
                      IconButton(
                        icon: const Icon(Icons.folder_open),
                        onPressed: onBrowse,
                        tooltip: 'Browse',
                      ),
                    ],
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a path';
                  }
                  if (validationResult != null && !validationResult.isValid) {
                    return validationResult.issues.first;
                  }
                  return null;
                },
                onChanged: (_) => onValidate(),
              ),
            ),
          ],
        ),
        if (validationResult != null) ...[
          const SizedBox(height: 4),
          ..._buildValidationMessages(validationResult),
        ],
      ],
    );
  }

  List<Widget> _buildValidationMessages(PathValidationResult result) {
    final widgets = <Widget>[];

    if (result.isValid && result.warnings.isEmpty) {
      widgets.add(
        Row(
          children: [
            Icon(Icons.check_circle, size: 16, color: Colors.green.shade700),
            const SizedBox(width: 4),
            Text(
              'Valid path',
              style: TextStyle(fontSize: 12, color: Colors.green.shade700),
            ),
          ],
        ),
      );
    }

    for (final warning in result.warnings) {
      widgets.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.warning, size: 16, color: Colors.orange.shade700),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                warning,
                style: TextStyle(fontSize: 12, color: Colors.orange.shade700),
              ),
            ),
          ],
        ),
      );
    }

    for (final issue in result.issues) {
      widgets.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.error, size: 16, color: Colors.red.shade700),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                issue,
                style: TextStyle(fontSize: 12, color: Colors.red.shade700),
              ),
            ),
          ],
        ),
      );
    }

    return widgets;
  }

  Future<void> _validateSims4Path() async {
    final path = _sims4PathController.text.trim();
    if (path.isEmpty) {
      setState(() {
        _sims4ValidationResult = null;
      });
      return;
    }

    try {
      final isValid = await Sims4Discovery.isValidSims4Directory(path);
      setState(() {
        _sims4ValidationResult = PathValidationResult(
          isValid: isValid,
          issues: isValid ? [] : ['Not a valid Sims 4 directory'],
          warnings: [],
        );
      });
    } catch (e) {
      setState(() {
        _sims4ValidationResult = PathValidationResult(
          isValid: false,
          issues: ['Error validating path: $e'],
          warnings: [],
        );
      });
    }
  }

  Future<void> _validateStoragePath() async {
    final path = _storagePathController.text.trim();
    if (path.isEmpty) {
      setState(() {
        _storageValidationResult = null;
      });
      return;
    }

    try {
      final result = await PathUtils.validateProfileStoragePath(path);
      setState(() {
        _storageValidationResult = result;
      });
    } catch (e) {
      setState(() {
        _storageValidationResult = PathValidationResult(
          isValid: false,
          issues: ['Error validating path: $e'],
          warnings: [],
        );
      });
    }
  }

  void _browseSims4Path() {
    // TODO: Implement file picker for Sims 4 path
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File picker coming soon - please enter path manually'),
      ),
    );
  }

  void _browseStoragePath() {
    // TODO: Implement file picker for storage path
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File picker coming soon - please enter path manually'),
      ),
    );
  }

  bool _canCreate() {
    return !_isCreating &&
        _nameController.text.trim().isNotEmpty &&
        _sims4PathController.text.trim().isNotEmpty &&
        _storagePathController.text.trim().isNotEmpty &&
        (_sims4ValidationResult?.isValid ?? false) &&
        (_storageValidationResult?.isValid ?? false);
  }

  Future<void> _createProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      await widget.profileService.createProfile(
        label: _nameController.text.trim(),
        storagePath: _storagePathController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop();
        widget.onProfileCreated();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Created profile: ${_nameController.text.trim()}'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to create profile: $e')));
      }
    }
  }
}

class ExportImportPage extends StatelessWidget {
  const ExportImportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Export/Import',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Create a profile to enable export/import'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Export and import functionality will be available once you have an active profile.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
