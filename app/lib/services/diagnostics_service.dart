import 'dart:io';
import 'dart:convert';
import '../models/user_settings.dart';
import '../models/profile.dart';

/// Service for manual diagnostic export per FR-024 and FR-027
class DiagnosticsService {
  static final DiagnosticsService _instance = DiagnosticsService._internal();
  factory DiagnosticsService() => _instance;
  DiagnosticsService._internal();

  /// Export diagnostic package as local GitHub issue draft per FR-027
  Future<String> exportDiagnosticPackage({
    required String exportPath,
    Profile? activeProfile,
    UserSettings? settings,
    String? userDescription,
    List<String>? logPaths,
  }) async {
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final packageDir = Directory('$exportPath/ts4dm-diagnostic-$timestamp');
    await packageDir.create(recursive: true);

    // Create GitHub issue draft
    final issueDraft = await _createIssueDraft(
      userDescription: userDescription,
      activeProfile: activeProfile,
      settings: settings,
    );

    final issueFile = File('${packageDir.path}/github-issue-draft.md');
    await issueFile.writeAsString(issueDraft);

    // Collect redacted logs
    await _collectLogs(packageDir.path, logPaths);

    // Create system info (redacted)
    await _createSystemInfo(packageDir.path);

    // Create README
    await _createDiagnosticReadme(packageDir.path);

    return packageDir.path;
  }

  Future<String> _createIssueDraft({
    String? userDescription,
    Profile? activeProfile,
    UserSettings? settings,
  }) async {
    final buffer = StringBuffer();

    buffer.writeln('## Issue Description');
    buffer.writeln(
      userDescription ?? 'Please describe the issue you encountered.',
    );
    buffer.writeln();

    buffer.writeln('## Environment');
    buffer.writeln(
      '- OS: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}',
    );
    buffer.writeln('- TS4DM Version: 1.0.0-dev');
    buffer.writeln('- Active Profile: ${activeProfile?.label ?? 'None'}');
    buffer.writeln(
      '- Tracked Areas: ${settings?.trackedAreas.join(', ') ?? 'Default'}',
    );
    buffer.writeln();

    buffer.writeln('## Steps to Reproduce');
    buffer.writeln('1. ');
    buffer.writeln('2. ');
    buffer.writeln('3. ');
    buffer.writeln();

    buffer.writeln('## Expected Behavior');
    buffer.writeln('[Describe what you expected to happen]');
    buffer.writeln();

    buffer.writeln('## Actual Behavior');
    buffer.writeln('[Describe what actually happened]');
    buffer.writeln();

    buffer.writeln('## Additional Context');
    buffer.writeln(
      'Diagnostic package attached. No automatic telemetry was sent.',
    );
    buffer.writeln();

    return buffer.toString();
  }

  Future<void> _collectLogs(String packagePath, List<String>? logPaths) async {
    if (logPaths == null || logPaths.isEmpty) return;

    final logsDir = Directory('$packagePath/logs');
    await logsDir.create();

    for (final logPath in logPaths) {
      try {
        final logFile = File(logPath);
        if (await logFile.exists()) {
          final content = await logFile.readAsString();
          final redactedContent = _redactSensitiveInfo(content);

          final fileName = logPath.split('/').last;
          final outputFile = File('${logsDir.path}/$fileName');
          await outputFile.writeAsString(redactedContent);
        }
      } catch (e) {
        // Skip inaccessible logs
        continue;
      }
    }
  }

  Future<void> _createSystemInfo(String packagePath) async {
    final systemInfo = {
      'platform': Platform.operatingSystem,
      'version': Platform.operatingSystemVersion,
      'dart_version': Platform.version,
      'locale': Platform.localeName,
      'timestamp': DateTime.now().toIso8601String(),
      'privacy_note': 'No personal data or file contents included',
    };

    final systemFile = File('$packagePath/system-info.json');
    await systemFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert(systemInfo),
    );
  }

  Future<void> _createDiagnosticReadme(String packagePath) async {
    const readme = '''
# TS4 Data Manager Diagnostic Package

This package contains diagnostic information for troubleshooting.

## Privacy
- No telemetry was automatically sent
- Personal file contents are not included
- Paths and sensitive information are redacted in logs
- This package was created manually at your request

## Contents
- `github-issue-draft.md`: Pre-filled issue template for GitHub
- `system-info.json`: Basic system information
- `logs/`: Application logs with sensitive information redacted

## Usage
1. Review all contents before sharing
2. Copy contents of `github-issue-draft.md` to create a new issue
3. Attach relevant log files if needed
4. Remove any remaining sensitive information

## Manual Submission
This package does NOT automatically submit any data.
You control what information is shared and when.
''';

    final readmeFile = File('$packagePath/README.md');
    await readmeFile.writeAsString(readme);
  }

  String _redactSensitiveInfo(String content) {
    // Redact common sensitive patterns
    String redacted = content;

    // Redact file paths (keep only relative structure)
    redacted = redacted.replaceAllMapped(
      RegExp(r'/Users/[^/\s]+|C:\\Users\\[^\\\s]+'),
      (match) => '[USER_HOME]',
    );

    // Redact other potentially sensitive patterns
    redacted = redacted.replaceAllMapped(
      RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'),
      (match) => '[EMAIL_REDACTED]',
    );

    return redacted;
  }
}
