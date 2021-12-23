import 'package:permission_handler/permission_handler.dart';

Future<bool> askPermission() async {
  bool isGivenPermission = true;
  Map<Permission, PermissionStatus> statuses = await [
    Permission.contacts,
    Permission.sms,
  ].request();

  for (var k in statuses.keys) {
    if (statuses[k] == PermissionStatus.denied) {
      isGivenPermission = false;
    }
  }
  return isGivenPermission;
}
