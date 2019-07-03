import 'package:flutter/material.dart';
import 'model.orders.dart';
import 'package:intl/intl.dart';
import 'ui.util.dart';

class OrderCard extends StatelessWidget {
  OrderCard({this.order}); // modified
  final ItemOrder order;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Container(
        height: 80.0,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 16.0,
              top: 16.0,
              child: Text(order.orderID, style: AppTextStyles.titleStyle),
            ),
            Positioned(
              right: 16.0,
              top: 16.0,
              child: Text(order.orderStatus.status, style: AppTextStyles.priceMini),
            ),
            Positioned(
              left: 16.0,
              bottom: 16.0,
              child: Text(order.orderDept, style: AppTextStyles.labelMini),
            ),
            Positioned(
              right: 16.0,
              bottom: 16.0,
              child: Text(NumberFormat.currency(symbol: "PhP ").format(order.orderPrices.total), style: AppTextStyles.priceRegular),
            ),
          ],
        ),
      ),
    );
  }
}
