import 'package:firebase_database/firebase_database.dart';
import 'util.login.dart';
import 'dart:async';

final dbOrders = FirebaseDatabase.instance.reference().child('OOB/Orders');
final dbOrderQueue = FirebaseDatabase.instance.reference().child('OOB/Order Queue');
final dbItems = FirebaseDatabase.instance.reference().child('OOB/Items');
final dbCart = FirebaseDatabase.instance.reference().child('OOB/Cart');
final dbNotifications = FirebaseDatabase.instance.reference().child('OOB/Notifications');
final dbVars = FirebaseDatabase.instance.reference().child('OOB/Variables');
final dbSpiels = FirebaseDatabase.instance.reference().child('OOB');

class FirebaseMethods {
  static void getOrderListByUsername(void onData(Map data)) {
    LoginFunctions.getUserName((String userID) {
      dbOrders.orderByChild('User').equalTo(userID).once().then((DataSnapshot snapshot) {
        onData(snapshot.value);
      });
//      dbOrders.limitToLast(100).once().then((DataSnapshot snapshot) {
//        onData(snapshot.value);
//      });
    });
  }

  static Future<StreamSubscription<Event>> getNotificationListByUsername(String userID, void onData(Map data)) async {
    StreamSubscription<Event> subscription = dbNotifications.child(userID).orderByChild('Unread').equalTo(true).onValue.listen((Event event) {
      onData(event.snapshot.value);
    });
    return subscription;
  }
//  static void getNotificationListByUsername(void onData(Map data)) {
//    LoginFunctions.getUserName((String userID) {
//      dbNotifications.child(userID).orderByChild('Unread').equalTo(true).once().then((DataSnapshot snapshot) {
//        onData(snapshot.value);
//      });
//    });
//  }

  static void getAppVersion(void onData(String s)) {
    dbVars.child('Version').once().then((DataSnapshot snapshot) {
      onData(snapshot.value);
    });
  }
  static void getNotificationListByOrderID(String orderID, void onData(Map data)) {
    LoginFunctions.getUserName((String userID) {
      dbNotifications.child(userID).orderByChild('Order ID').equalTo(orderID).once().then((DataSnapshot snapshot) {
        onData(snapshot.value);
      });
    });
  }

  static void updateNotificationRead(String key) {
    LoginFunctions.getUserName((String userID) {
      dbNotifications.child(userID).child(key).child('Unread').set(false);
    });

  }


  static void setCartItemNew(String dept, String itemID, Map data, void done()) {
    LoginFunctions.getUserName((String userID) {
      dbCart.child(userID).child(dept).child(itemID).set(data).then((_) {
        done();
      });
    });
  }


  static void deleteCart(String dept) {
    LoginFunctions.getUserName((String userID) {
      dbCart.child(userID).child(dept).set(null);
    });
  }
  static void deleteCartItem(String dept, String itemID) {
    LoginFunctions.getUserName((String userID) {
      dbCart.child(userID).child(dept).child(itemID).set(null);
    });
  }

  static void getSpielListByDeptID(String deptID, void onData(Map data)) {
    dbSpiels.child(deptID).child('Spiels').once().then((DataSnapshot snapshot) {
      onData(snapshot.value);
    });
  }

  static void getSpielByStatusAndDeptID(String deptID, String status, void onData(List<dynamic> data)) {
    dbSpiels.child(deptID).child('Spiels').child(status).once().then((DataSnapshot snapshot) {
      onData(snapshot.value);
    });
  }

  static void updateOrderCancel(String orderID, void done()) {
    dbOrders.child(orderID).child('Status').child('CANCELLED').set("true").then((_) {
      done();
    });
  }

  static void deleteOrder(String key, void done()) {
    dbOrders.child(key).set(null).then((_) {
      done();
    });
  }

  static void setOrderNew(Map data, Map queueData, void done()) async {
    LoginFunctions.getUserName((String username) {
      LoginPreferences.getToken((String token) {
        String key = dbOrders.push().key;
        data['User'] = username;
        data['FCMToken'] = token;
        queueData['oid'] = key;
        queueData['uid'] = username;
        dbOrders.child(key).set(data).then((_) {
          dbOrderQueue.push().set(queueData).then((_) {
            done();
          });
        });
      });
    });
  }

  static void getItemByItemID(String itemID, void onData(Map data)) {
    dbItems.child(itemID).once().then((DataSnapshot snapshot) {
      onData(snapshot.value);
    });
  }

  static void getCartListByUserID(void onData(Map data)) {
    LoginFunctions.getUserName((String userID) {
      dbCart.child(userID).once().then((DataSnapshot snapshot) {
        onData(snapshot.value);
      });
    });
  }
}
