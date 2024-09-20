import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AppBarButtonLink extends StatelessWidget {
  const AppBarButtonLink({Key? key, required this.linkUrl, required this.icon})
      : super(key: key);

  final String linkUrl;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: FaIcon(
        icon,
        size: 24,
      ),
      onPressed: () async {
        final websiteUrl = Uri.parse(linkUrl);
        // ignore: deprecated_member_use
        if (await canLaunch(websiteUrl.toString())) {
          // ignore: deprecated_member_use
          launch(websiteUrl.toString(), forceWebView: true);
        } else {
          if (kDebugMode) {
            print("can't launch $websiteUrl");
          }
        }
      },
    );
  }
}
