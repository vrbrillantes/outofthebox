import 'model.orders.dart';
import 'model.dept.dart';
import 'package:flutter/material.dart';
import 'ui.list.product.dart';
import 'ui.util.dart';
import 'package:intl/intl.dart';
import 'dialog.generic.dart';
import 'ui.card.order.dart';
import 'screen.orderPrintable.dart';

class ScreenOrder extends StatelessWidget {
  ScreenOrder({this.order});

  final ItemOrder order;

  @override
  Widget build(BuildContext context) {
    return new ScreenOrderState(order: order);
  }
}

class ScreenOrderState extends StatefulWidget {
  ScreenOrderState({this.order});

  final ItemOrder order;

  @override
  _ScreenOrderBuild createState() => new _ScreenOrderBuild(order: order);
}

class _ScreenOrderBuild extends State<ScreenOrderState> {
  _ScreenOrderBuild({this.order});

  final ItemOrder order;

  bool isNotBusy = true;

  @override
  void initState() {
    super.initState();
  }

  RaisedButton newRaisedButton(String label, VoidCallback action) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
      padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
      color: Colors.lightBlue,
      child: Text(label, style: AppTextStyles.labelWhite),
      onPressed: action,
    );
  }

  Expanded actionLabel(String label) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Text(label, style: AppTextStyles.labelRegular),
      ),
    );
  }

  void showPrintableForm() {
    SpielPresenter.getSpielByStatusAndDeptID(order.orderDept, order.orderStatus.spiel, (ItemSpiel isp) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScreenOrderPrintable(
                    order: order,
                    spiels: isp,
                  )));
    });
  }

  void cancelOrder() {
    setState(() {
      isNotBusy = false;
    });
    GenericDialogGenerator.cancelOrder(context, () {
      order.cancelOrder(() {
        Navigator.pop(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = <Widget>[];
    if (order.orderStatus.pending) {
      widgetList.add(actionLabel("This order is cancellable"));
      widgetList.add(newRaisedButton("Cancel", isNotBusy ? cancelOrder : null));
    } else if (order.orderStatus.processing) {
      widgetList.add(actionLabel("This order is ${order.orderStatus.status}"));
    } else {
      widgetList.add(actionLabel("This order is ${order.orderStatus.status}"));
      if (!order.orderStatus.complete && !order.orderStatus.cancelled) {
        widgetList.add(newRaisedButton("Show email", showPrintableForm));
      }
    }

    return new Theme(
      data: new ThemeData(),
      child: new Scaffold(
        body: new CustomScrollView(slivers: <Widget>[
          SliverAppBar(pinned: true, title: Text(order.orderID)),
          SliverList(
            delegate: new SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Hero(tag: order.key, child: OrderCard(order: order),);
              },
              childCount: 1,
            ),
          ),
          SliverListOrderProduct(itemProducts: order.orderProducts.productList),
        ]),
        bottomNavigationBar: BottomAppBar(
          child: Row(children: widgetList),
        ),
      ),
    );
  }
}
