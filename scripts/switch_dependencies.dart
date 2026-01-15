#!/usr/bin/env dart
// ignore_for_file: avoid_print

/// Switches dependencies between local paths and git URLs.
///
/// Usage:
///   dart scripts/switch_dependencies.dart local   # Switch to local paths
///   dart scripts/switch_dependencies.dart remote  # Switch to git URLs
///
/// Configuration is defined in scripts/dependencies.yaml

import 'dart:io';

import 'package:yaml/yaml.dart';

/// Dependency configuration for switching between local and remote
class DependencyConfig {
  final String package;
  final String localPath;
  final String gitUrl;
  final String? gitRef;
  final String? gitPath;

  DependencyConfig({
    required this.package,
    required this.localPath,
    required this.gitUrl,
    this.gitRef,
    this.gitPath,
  });

  factory DependencyConfig.fromYaml(Map<dynamic, dynamic> yaml) {
    return DependencyConfig(
      package: yaml['package'] as String,
      localPath: yaml['local_path'] as String,
      gitUrl: yaml['git_url'] as String,
      gitRef: yaml['git_ref'] as String?,
      gitPath: yaml['git_path'] as String?,
    );
  }

  /// Generate the local dependency YAML string (with trailing newline)
  String toLocalYaml() {
    return '  $package:\n    path: $localPath\n';
  }

  /// Generate the remote (git) dependency YAML string (with trailing newline)
  String toRemoteYaml() {
    final StringBuffer buffer = StringBuffer();
    buffer.writeln('  $package:');
    buffer.writeln('    git:');
    buffer.write('      url: $gitUrl\n');
    if (gitRef != null) {
      buffer.write('      ref: $gitRef\n');
    }
    if (gitPath != null) {
      buffer.write('      path: $gitPath\n');
    }
    return buffer.toString();
  }
}

/// Target pubspec file configuration
class PubspecTarget {
  final String path;
  final List<String> dependencies;

  PubspecTarget({
    required this.path,
    required this.dependencies,
  });

  factory PubspecTarget.fromYaml(Map<dynamic, dynamic> yaml) {
    return PubspecTarget(
      path: yaml['path'] as String,
      dependencies: (yaml['dependencies'] as List<dynamic>).cast<String>(),
    );
  }
}

void main(List<String> args) {
  if (args.isEmpty || !['local', 'remote'].contains(args[0])) {
    print('Usage: dart scripts/switch_dependencies.dart <local|remote>');
    print('');
    print('  local   - Switch to local path dependencies (for development)');
    print('  remote  - Switch to git URL dependencies (for CI/deployment)');
    exit(1);
  }

  final String mode = args[0];
  final bool useLocal = mode == 'local';

  // Find the root directory (where this script lives)
  final String scriptPath = Platform.script.toFilePath();
  final Directory scriptDir = File(scriptPath).parent;
  final Directory rootDir = scriptDir.parent;

  // Load configuration
  final File configFile = File('${scriptDir.path}/dependencies.yaml');
  if (!configFile.existsSync()) {
    print('Error: Configuration file not found: ${configFile.path}');
    exit(1);
  }

  final String configContent = configFile.readAsStringSync();
  final YamlMap config = loadYaml(configContent) as YamlMap;

  // Parse dependency configurations
  final List<DependencyConfig> dependencies = (config['dependencies'] as YamlList)
      .map((dynamic e) => DependencyConfig.fromYaml(e as Map<dynamic, dynamic>))
      .toList();

  // Parse pubspec targets
  final List<PubspecTarget> targets = (config['pubspec_files'] as YamlList)
      .map((dynamic e) => PubspecTarget.fromYaml(e as Map<dynamic, dynamic>))
      .toList();

  // Create a map for quick lookup
  final Map<String, DependencyConfig> depMap = {
    for (final DependencyConfig dep in dependencies) dep.package: dep,
  };

  print('Switching dependencies to ${useLocal ? "LOCAL" : "REMOTE"} mode...');
  print('');

  // Process each pubspec file
  for (final PubspecTarget target in targets) {
    final String pubspecPath = '${rootDir.path}/${target.path}';
    final File pubspecFile = File(pubspecPath);

    if (!pubspecFile.existsSync()) {
      print('Warning: Pubspec not found: $pubspecPath');
      continue;
    }

    print('Processing: ${target.path}');

    String content = pubspecFile.readAsStringSync();

    // Process each dependency for this pubspec
    for (final String depName in target.dependencies) {
      final DependencyConfig? dep = depMap[depName];
      if (dep == null) {
        print('  Warning: Dependency config not found for: $depName');
        continue;
      }

      // Create regex patterns to match both local and remote dependency formats
      // Both patterns include the trailing newline for consistent replacement
      final RegExp localPattern = RegExp(
        r'^  ' + RegExp.escape(depName) + r':\s*\n    path: [^\n]+\n',
        multiLine: true,
      );

      final RegExp remotePattern = RegExp(
        r'^  ' + RegExp.escape(depName) + r':\s*\n    git:\s*\n(?:      [^\n]+\n)+',
        multiLine: true,
      );

      final String replacement = useLocal ? dep.toLocalYaml() : dep.toRemoteYaml();

      // Try to replace local pattern first, then remote
      if (localPattern.hasMatch(content)) {
        content = content.replaceFirst(localPattern, replacement);
        print('  - $depName: switched from local to ${useLocal ? "local" : "remote"}');
      } else if (remotePattern.hasMatch(content)) {
        content = content.replaceFirst(remotePattern, replacement);
        print('  - $depName: switched from remote to ${useLocal ? "local" : "remote"}');
      } else {
        print('  - $depName: dependency not found in pubspec (skipped)');
      }
    }

    // Write the updated content
    pubspecFile.writeAsStringSync(content);
    print('');
  }

  print('Done! Dependencies switched to ${useLocal ? "LOCAL" : "REMOTE"} mode.');
}
