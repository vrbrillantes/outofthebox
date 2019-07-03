import 'package:flutter/material.dart';
import 'model.items.dart';
import 'package:intl/intl.dart';
import 'ui.util.dart';

class ProductCard extends StatelessWidget {
  ProductCard({this.item}); // modified
  final ItemProduct item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12.0),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              color: Colors.white,
              child: SizedBox(),
            ),
          ),
          Positioned.fill(
            bottom: 30.0,
            top: 8.0,
            child: Hero(tag: item.key, child: Image.network(item.image, fit: BoxFit.fitHeight)),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Opacity(
              opacity: 0.9,
              child: Container(
                padding: EdgeInsets.all(4.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(item.dept, style: AppTextStyles.labelMini),
                        Text(item.brand + " " + item.model, style: AppTextStyles.titleStyle),
                        Text(item.condition, style: AppTextStyles.labelRegular),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          NumberFormat.currency(symbol: "PhP ").format(item.price),
                          style: AppTextStyles.labelMiniDark,
                          textAlign: TextAlign.end,
                        ),
                        Text(NumberFormat.currency(symbol: "PhP ").format(item.productDevice.total), style: AppTextStyles.priceRegular),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class ProductCardFull extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

}
class ProductCardCart extends StatelessWidget {
  ProductCardCart({this.item}); // modified
  final ItemProduct item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0.0),
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0)),
      child: Container(
        height: 100.0,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 8.0,
              top: 8.0,
              left: 8.0,
              width: 100.0,
              child: Image.network(
                item.image,
//                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 8.0,
              left: 116.0,
              right: 8.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(item.brand + " " + item.model, style: AppTextStyles.titleStyle),
                  Text(item.condition, style: AppTextStyles.labelMini),
                ],
              ),
            ),
            Positioned(
              right: 16.0,
              bottom: 8.0,
              left: 96.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text("x " + item.productDevice.quantity.toString(), style: AppTextStyles.labelMiniDark),
                  Text(NumberFormat.currency(symbol: "PhP ").format(item.price), style: AppTextStyles.labelMiniDark),
                  Text(NumberFormat.currency(symbol: "PhP ").format(item.productDevice.total), style: AppTextStyles.priceMini),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCardCondensed extends StatelessWidget {
  ProductCardCondensed({this.item}); // modified
  final ItemDevice item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.0,
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 8.0,
            left: 8.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(item.item, style: AppTextStyles.titleStyle),
              ],
            ),
          ),
          Positioned(
            right: 16.0,
            bottom: 8.0,
            left: 96.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text("x " + item.quantity.toString(), style: AppTextStyles.labelMiniDark),
                Text(NumberFormat.currency(symbol: "PhP ").format(item.price), style: AppTextStyles.labelMiniDark),
                Text(NumberFormat.currency(symbol: "PhP ").format(item.total), style: AppTextStyles.priceMini),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
