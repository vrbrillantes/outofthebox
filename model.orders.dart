import 'util.firebase.dart';
import 'model.items.dart';
import 'model.orderdetails.dart';

class OrdersPresenter {
  static void getMyOrders(void onData(ListOrder lo)) {
    FirebaseMethods.getOrderListByUsername((data) {
      onData(ListOrder.parseData(data));
    });
  }
  static void deleteOrder(String key, void done()) {
    FirebaseMethods.deleteOrder(key, done);
  }
  static void cancelOrder(String key, void done()) {
    FirebaseMethods.updateOrderCancel(key, done);
  }
}

class ListOrder {
  List<ItemOrder> orderList;
  List<ItemOrder> cancelledOrderList;
  List<ItemOrder> completeOrderList;
  List<ItemOrder> pendingOrderList;
  Map<String, List<ItemOrder>> departmentOrderList = {};


  bool canOrder(String dept) {
    bool hasOrder = false;
    pendingOrderList.forEach((ItemOrder io) {
      if (io.orderDept == dept) {
        hasOrder = true;
      }
    });
    return hasOrder ? false : true;
  }

  ListOrder.newListOrder() {
    completeOrderList = <ItemOrder>[];
    pendingOrderList = <ItemOrder>[];
  }
  ListOrder.parseData(data) {
    orderList = <ItemOrder>[];
    cancelledOrderList = <ItemOrder>[];
    completeOrderList = <ItemOrder>[];
    pendingOrderList = <ItemOrder>[];

    data.forEach((key, value) {
      ItemOrder thisItemOrder = ItemOrder.firebaseOrder(key, value);
      orderList.add(thisItemOrder);
      if (thisItemOrder.orderStatus.cancelled)
        cancelledOrderList.add(thisItemOrder);
      else if (thisItemOrder.orderStatus.complete)
        completeOrderList.add(thisItemOrder);
      else
        pendingOrderList.add(thisItemOrder);

      List<ItemOrder> deptOrder = <ItemOrder>[];
      if (departmentOrderList.containsKey(thisItemOrder.orderDept)) deptOrder = departmentOrderList[thisItemOrder.orderDept];
      deptOrder.add(thisItemOrder);
      departmentOrderList[thisItemOrder.orderDept] = deptOrder;
    });
  }
}

class ItemOrder {
  final String key;
  String orderID;
  ItemDelivery orderDelivery;
  ItemStatus orderStatus;
  ItemPriceTotal orderPrices;
  ListProduct orderProducts;
  String orderDept;

  void cancelOrder(void done()) {
    OrdersPresenter.cancelOrder(key, done);
  }
  ItemOrder.firebaseOrder(this.key, Map data) {
    data.containsKey('OrderID') ? orderID = data['OrderID'] : orderID = key;
    orderDept = data['Dept'];
    orderProducts = ListProduct.fromJson(data['Orders']);
    orderDelivery = ItemDelivery.fromJson(data);
    orderStatus = ItemStatus.fromJson(data['Status']);
    orderPrices = ItemPriceTotal.fromJson(data['Price']);
  }
}
