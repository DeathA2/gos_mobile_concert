import 'package:url_launcher/url_launcher.dart';

class UrlUtils {
  static void checkLaunchUrl(String? url) async {
    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
