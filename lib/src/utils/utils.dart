import 'package:url_launcher/url_launcher.dart';
import 'package:qrreaderapp/src/services/db_service.dart';

launchScan(ScanModel scan) async {
  if (scan.type == 'http') {
    if (await canLaunch(scan.value)) {
      await launch(scan.value);
    } else {
      throw 'Could not launch ${scan.value}';
    }
  } else {}
}
