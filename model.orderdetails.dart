import 'util.preferences.dart';

class ItemStatus {
  bool cancelled = false;
  bool complete = false;
  bool pending = false;
  bool processing = false;
  String status;
  String spiel;

  ItemStatus.fromJson(Map data) {
    if (data == null) {
      processing = true;
      status = "Processing";
    } else {
      if (data.containsKey('CANCELLED')) {
        cancelled = true;
        status = "Cancelled";
      } else if (data.containsKey('COMPLETE')) {
        complete = true;
        status = "Complete";
      } else {
        if (data.containsKey('FOR PICKUP')) {
          spiel = "FOR PICKUP";
          status = "For pick-up";
        } else if (data.containsKey('PAID')) {
          spiel = "PAID";
          status = "Paid";
        } else if (data.containsKey('FOR PAYMENT')) {
          spiel = "FOR PAYMENT";
          status = "For payment";
        } else {
          pending = true;
          status = "Pending";
        }
      }
    }
  }
}

class DeliveryPreferences {
  List<String> deliveryFields = <String>['Office', 'Representative', 'ID', 'Emp', 'First', 'Last', 'Mobile'];

  void getDelivery(void done(Map deliveryDetails)) {
    AppPreferences.getDelivery(deliveryFields, 'vcbrillantes', (Map details) {
      done(details);
    });
  }

  void saveDelivery(Map deliveryDetails, void done()) {
    AppPreferences.saveDelivery(deliveryDetails, done);
  }
}

class ItemDelivery {
  String office;
  String emp;
  String last;
  String first;
  String id;
  String delivery;
  String representative;
  String mobile;
  bool isComplete = false;
  DeliveryPreferences delPrefs = DeliveryPreferences();

  ItemDelivery.newDelivery();

  void getFromPrefs(void done()) {
    delPrefs.getDelivery((Map deliveryDetails) {
      mapDelivery(deliveryDetails);
      isComplete = true;
      done();
    });
  }

  Map deliveryDetailsMap() {
    Map deliveryDetails = {};
    deliveryDetails['Office'] = office;
    deliveryDetails['Delivery'] = delivery;
    deliveryDetails['Representative'] = representative;
    deliveryDetails['ID'] = id;
    deliveryDetails['Emp'] = emp;
    deliveryDetails['First'] = first;
    deliveryDetails['Last'] = last;
    deliveryDetails['Mobile'] = mobile;
    return deliveryDetails;
  }

  ItemDelivery.fromJson(Map data) {
    mapDelivery(data);
  }

  void submitDeliveryDetails(Map data, void noErrors(), void returnErrors(List<String> errors)) {
    List<String> errorString = <String>[];
    data.forEach((k, v) {
      if (v.toString().replaceAll(" ", "") == "" && k != "Representative") {
        switch (k) {
          case "Last":
            errorString.add("Last name is empty");
            break;
          case "First":
            errorString.add("First name is empty");
            break;
          case "Office":
            errorString.add("Complete office address is empty");
            break;
          case "Emp":
            errorString.add("Employee type is not selected");
            break;
          case "ID":
            errorString.add("ID number is empty");
            break;
          case "Mobile":
            errorString.add("Mobile number is empty");
            break;
        }
      } else {
        switch (k) {
          case "Mobile":
            if (RegExp(r'[^0-9]').hasMatch(v)) {
              errorString.add("Mobile number should only contain numbers");
            }
            break;
          case "Last":
            if (RegExp(r'[^A-Za-z\s]').hasMatch(v)) {
              errorString.add("Last name should only contain letters or spaces");
            }
            break;
          case "First":
            if (RegExp(r'[^0-9A-Za-z,.-\s]').hasMatch(v)) {
              errorString.add("First name should only contain letters or spaces");
            }
            break;
          case "ID":
            if (RegExp(r'[^0-9A-Za-z]').hasMatch(v)) {
              errorString.add("ID number should only contain alphanumeric characters");
            }
            break;
          default:
            if (RegExp(r'[^0-9A-Za-z,.\/-\s]').hasMatch(v)) {
              switch (k) {
                case "Office":
                  errorString.add("Complete office address should not contain illegal characters");
                  break;
              }
            }
            break;
        }
      }
    });
    if (errorString.length > 0) {
      returnErrors(errorString);
    } else {
      mapDelivery(data);
      savePrefs(() {});
      noErrors();
    }
  }

  void mapDelivery(Map data) {
    office = data['Office'];
    delivery = data['Delivery'];
    representative = data['Representative'];
    id = data['ID'];
    emp = data['Emp'];
    first = data['First'];
    last = data['Last'];
    mobile = data['Mobile'];
  }

  void savePrefs(void done()) {
    delPrefs.saveDelivery(deliveryDetailsMap(), done);
  }
}

class ItemPriceTotal {
  int sub = 0;
  int total = 0;
  int del = 0;
  Map<String, int> itemPrices = {};

  ItemPriceTotal.newTotals();

  void clear() {
    itemPrices = {};
    sub = 0;
    total = 0;
    del = 0;
  }

  void editPrice(String item, int price) {
    if (price == 0) {
      itemPrices.remove(item);
    } else {
      itemPrices[item] = price;
    }
    recompute();
  }

  Map createPricePayload() {
    return {'Sub': sub, 'Total': total, 'Del': del};
  }

  void recompute() {
    sub = 0;
    itemPrices.forEach((String key, int val) {
      sub += val;
    });
    total = del + sub;
  }

  ItemPriceTotal.fromJson(Map data) {
    if (data != null) {
      sub = data['Sub'];
      total = data['Total'];
      del = data['Del'];
    }
  }

  ItemPriceTotal.firebaseStoredTotal(Map data) {
    if (data != null) {
      sub = 0;
      data.forEach((key, value) {
        int thisItemPrice = value['Q'] * value['P'];
        editPrice(key, thisItemPrice);
      });
      recompute();
    }
  }
}
