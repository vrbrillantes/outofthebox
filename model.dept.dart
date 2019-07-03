import 'util.firebase.dart';

class SpielPresenter {
  static void getSpielByStatusAndDeptID(String deptID, String status, void onData(ItemSpiel ls)) {
    FirebaseMethods.getSpielByStatusAndDeptID(deptID, status, (data) {
      onData(ItemSpiel.fromJson(status, data));
    });
  }
}

//class ListSpiel {
//  Map<String, ItemSpiel> spielList = {};
//
//  ListSpiel.fromJson(Map data) {
//    if (data != null) {
//      data.forEach((key, value) {
//        spielList[key] = ItemSpiel.fromJson(key, value);
//      });
//    }
//  }
//}

class ItemSpiel {
  final String status;
  List<String> spielContents = <String>[];

  ItemSpiel.fromJson(this.status, List<dynamic> data) {
    if (data != null) {
      data.forEach((v) {
        spielContents.add(v);
      });
    }
  }
}
