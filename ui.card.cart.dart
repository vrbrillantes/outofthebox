import 'package:flutter/material.dart';
import 'model.orderdetails.dart';
import 'package:intl/intl.dart';
import 'ui.util.dart';

class CartCard extends StatelessWidget {
  CartCard({this.dept, this.cartPrices, this.onPressed}); // modified
  final VoidCallback onPressed;
  final String dept;
  final ItemPriceTotal cartPrices;

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
              child: Text(dept, style: AppTextStyles.titleStyle),
            ),
            Positioned(
              left: 16.0,
              bottom: 16.0,
              child: Text(NumberFormat.currency(symbol: "PhP ").format(cartPrices.total), style: AppTextStyles.priceMini),
            ),
            Positioned(
              bottom: 0.0,
              top: 0.0,
              right: 0.0,
              width: 80.0,
              child: InkWell(
                child: Container(
                  color: Colors.lightBlueAccent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Icon(Icons.shopping_cart, color: Colors.white), Text("Checkout", style: AppTextStyles.labelWhiteMini)],
                  ),
                ),
                onTap: onPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
