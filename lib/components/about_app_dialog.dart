import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pra_frente_app/themes/theme_colors.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutAppDialog extends StatelessWidget {
  const AboutAppDialog({Key? key}) : super(key: key);

  final String gitHubURL = "https://github.com/Chufretalas/em_frente";

  Future<void> _openGithub() async {
    bool isLaunchable = await canLaunchUrlString(gitHubURL);
    if (isLaunchable) {
      await launchUrlString(gitHubURL, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Em Frente V0.3.2"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text("Developer: Chufretalas"),
          ),
          ElevatedButton(
            onPressed: _openGithub,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.code,
                  color: ThemeColors.white,
                ),
                Text(
                  "Github",
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            ),
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text("Ok")),
      ],
    );
  }
}
