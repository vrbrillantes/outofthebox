import 'util.firebase.dart';
import 'dart:async';
import 'util.login.dart';
class NotificationPresenter {
  static StreamSubscription stream;
  static void getNotificationList(void onData(ListNotification notifList)) {
    LoginFunctions.getUserName((String userID) {
      FirebaseMethods.getNotificationListByUsername(userID, (data) {
        onData(ListNotification.fromJson(data));
      }).then((StreamSubscription s) => stream = s);
    });
  }

  static void getOrderNotificationList(String orderID, void onData(ListNotification notifList)) {
    FirebaseMethods.getNotificationListByOrderID(orderID, (data) {
      onData(ListNotification.fromJson(data));
    });
  }

  static void setNotificationAsRead(String notificationID) {
    FirebaseMethods.updateNotificationRead(notificationID);
  }
}

class ItemNotification {
  final String key;
  String message;
  String date;
  String orderID;
  String orderKey;
  String screen;
  bool unread;
  String status;

  ItemNotification.fromJson(this.key, Map data) {
    message = data['Message'];
    screen = data['Screen'];
    unread = data['Unread'];
    status = data['Status'];
    orderID = data['Order ID'];
    orderKey = data['Order Key'];
  }
}

class ListNotification {
  List<ItemNotification> notificationList = <ItemNotification>[];

  void removeNotification(String key) {
    NotificationPresenter.setNotificationAsRead(key);
  }

  ListNotification.empty();

  ListNotification.fromJson(Map data) {
    if (data != null) {
      data.forEach((key, value) {
        notificationList.add(ItemNotification.fromJson(key, value));
      });
    }
  }
}
