import 'package:notifications_test/services/local_notification_service.dart';
import 'package:workmanager/workmanager.dart';

class WorkManagerService {
  void registerMyTask() async {
    await Workmanager().registerPeriodicTask(
      'id1',
      'show daily notification',
      frequency: const Duration(minutes: 15),
    );
  }

  Future<void> init() async {
    await Workmanager().initialize(actionTask, isInDebugMode: true);
    registerMyTask();
  }

  void cancelTask() {
    Workmanager().cancelAll();
  }
}

@pragma('vm-entry-point')
void actionTask() {
  Workmanager().executeTask((taskName, inputData) {
    LocalNotificationService.showDailySchduledNotification();
    return Future.value(true);
  });
}
