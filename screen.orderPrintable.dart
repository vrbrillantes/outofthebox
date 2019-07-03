import 'model.orders.dart';
import 'model.items.dart';
import 'package:flutter/material.dart';
import 'ui.util.dart';
import 'package:intl/intl.dart';
import 'model.dept.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class ScreenOrderPrintable extends StatelessWidget {
  ScreenOrderPrintable({this.order, this.spiels});

  final ItemOrder order;
  final ItemSpiel spiels;

  @override
  Widget build(BuildContext context) {
    return new ScreenOrderPrintableState(order: order, spiels: spiels);
  }
}

class ScreenOrderPrintableState extends StatefulWidget {
  ScreenOrderPrintableState({this.order, this.spiels});

  final ItemOrder order;
  final ItemSpiel spiels;

  @override
  _ScreenOrderPrintableBuild createState() => new _ScreenOrderPrintableBuild(order: order, spiels: spiels);
}

class _ScreenOrderPrintableBuild extends State<ScreenOrderPrintableState> {
  _ScreenOrderPrintableBuild({this.order, this.spiels});

  final ItemOrder order;
  final ItemSpiel spiels;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> listProduct = order.orderProducts.productList.keys.toList();
    Map<String, ItemProduct> productList = order.orderProducts.productList;
    return new Theme(
      data: new ThemeData(),
      child: new Scaffold(
        body: new CustomScrollView(slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index == 0) {
                  return Container(
                    color: Colors.lightBlue,
                    height: 100.0,
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[Text(order.orderDept, style: AppTextStyles.labelWhite)]),
                  );
                } else if (index == 1) {
                  return Container(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Text('${order.orderStatus.status.toUpperCase()} ADVISE', style: AppTextStyles.labelRegular),
                          Text(
                            '${order.orderDelivery.last}, ${order.orderDelivery
                                .first} / ${order.orderDelivery.id}',
                            style: AppTextStyles.labelRegular,
                          ),
                          Text(
                            '${order.orderID}',
                            style: AppTextStyles.titleStyle,
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (index == productList.length + 2) {
                  return Container(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Table(
                        columnWidths: {1: FractionColumnWidth(.3)},
                        children: [
                          TableRow(children: [
                            Text('${order.orderDept} - All', style: AppTextStyles.labelRegular),
                            Text(NumberFormat.currency(symbol: "PhP ").format(order.orderPrices.sub),
                                textAlign: TextAlign.end, style: AppTextStyles.labelMiniDarkBold),
                          ]),
                          TableRow(children: [
                            Text("Delivery Fee", style: AppTextStyles.labelRegular),
                            Text(NumberFormat.currency(symbol: "PhP ").format(order.orderPrices.del),
                                textAlign: TextAlign.end, style: AppTextStyles.labelMiniDarkBold),
                          ]),
                          TableRow(children: [
                            Text("Overall Settlement Cost", style: AppTextStyles.labelRegular),
                            Text(NumberFormat.currency(symbol: "PhP ").format(order.orderPrices.total),
                                textAlign: TextAlign.end, style: AppTextStyles.priceMini),
                          ]),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                        title: Text(productList[listProduct[index - 2]].productDevice.item, style: AppTextStyles.labelRegular),
                        trailing: Text(NumberFormat.currency(symbol: "PhP ").format(productList[listProduct[index - 2]].productDevice.total),
                            style: AppTextStyles.labelRegularLight),
                        subtitle: Text(
                            "${productList[listProduct[index - 2]].productDevice.quantity} pc/s at ${NumberFormat.currency(symbol: "PhP ").format(
                                productList[listProduct[index - 2]].productDevice.price)} each",
                            style: AppTextStyles.labelMini),
                      ),
                    ],
                  );
                }
              },
              childCount: productList.length + 3,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  child: Html(data: spiels.spielContents[index]),
//                  child: Text(spiels.spielContents[index], style: AppTextStyles.labelRegularLight),
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                );
              },
              childCount: spiels.spielContents.length,
            ),
          ),
        ]),
      ),
    );
  }
}
