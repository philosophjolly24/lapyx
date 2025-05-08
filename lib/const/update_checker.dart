import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icarus/const/settings.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl;

class UpdateChecker {
  // Your current app version stored as an int.
  static const int appVersionNumber = Settings.versionNumber;
  // URL to your remote version file.
  static bool hasPrompted = false;
  static const String versionInfoUrl =
      'https://sunkenintime.github.io/icarus/version.json';

  /// Fetches the version info from the remote server.
  static Future<Map<String, dynamic>?> fetchVersionInfo() async {
    try {
      final response = await http.get(Uri.parse(versionInfoUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        debugPrint('Failed to load version info: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching version info: $e');
      return null;
    }
  }

  /// Compares the current app version with the remote version.
  static Future<void> checkForUpdate(BuildContext context) async {
    if (hasPrompted) return;
    final versionInfo = await fetchVersionInfo();
    if (versionInfo == null) return;

    // Convert the current_version_number from remote to int.
    final String remoteVersionNumberString =
        versionInfo['current_version_number'];
    final int? remoteVersionNumber = int.tryParse(remoteVersionNumberString);

    // If conversion fails, stop here.
    if (remoteVersionNumber == null) {
      debugPrint('Invalid remote version number');
      return;
    }

    // Compare versions: if the remote version is greater than the app's version.
    if (remoteVersionNumber > appVersionNumber) {
      // Prompt the user to update.
      if (!context.mounted) return;
      hasPrompted = true;
      _showUpdateDialog(context, versionInfo);
    }
  }

  /// Shows a simple update dialog.
  static void _showUpdateDialog(
      BuildContext context, Map<String, dynamic> versionInfo) {
    final String remoteVersion = versionInfo['current_version'];
    final String releaseNotes = versionInfo['release_notes'];

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Update Available'),
        content: Text(
          'A new version ($remoteVersion) is available.\n\n'
          'Release Notes: $releaseNotes',
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Dismiss the dialog.
              Navigator.of(context).pop();
            },
            child: const Text('Later'),
          ),
          TextButton(
            onPressed: () async {
              // Here you can redirect the user to your download page or the store.
              // For instance, you might use:
              await launchUrl(
                  Uri.parse("ms-windows-store://pdp/?productid=9PBWHHZRQFW6"));
              if (!context.mounted) return;

              Navigator.of(context).pop();
            },
            child: const Text('Update Now'),
          ),
        ],
      ),
    );
  }
}
