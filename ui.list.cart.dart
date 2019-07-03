import 'package:flutter/material.dart';
import 'model.cart.dart';
import 'ui.card.cart.dart';
import 'ui.util.dart';

class SliverListCart extends StatelessWidget {
  SliverListCart({this.listTotal, this.onPressed}); // modified
  final void Function(String) onPressed;
  final ListCart listTotal;

  @override
  Widget build(BuildContext context) {
    List<String> keys = listTotal.dCartList.keys.toList();
    return SliverList(
      delegate: new SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index == 0) {
            return Container(
              child: Text("Shopping Cart", style: AppTextStyles.titleStyleBlue),
              padding: EdgeInsets.all(16.0),
            );
          } else {
            return CartCard(
                dept: keys[index - 1], onPressed: () => onPressed(keys[index - 1]), cartPrices: listTotal.dCartList[keys[index - 1]].cartPrices);
          }
        },
        childCount: listTotal.dCartList.length + 1,
      ),
    );
  }
}

class SliverListCart2 extends StatelessWidget {
  SliverListCart2({this.listTotal, this.onPressed}); // modified
  final void Function(String) onPressed;
  final ListCart listTotal;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: listTotal.dCartList.values.map((ItemCart ic) {
        return CartCard(dept: ic.cartDept, cartPrices: ic.cartPrices, onPressed: () => onPressed(ic.cartDept));
      }).toList(),
    );
  }
}
//class SliverListCartCheckOut extends StatelessWidget {
//  SliverListCartCheckOut({this.total, this.onPressed}); // modified
//  final VoidCallback onPressed;
//  final ItemPriceTotal total;
//
//  @override
//  Widget build(BuildContext context) {
//    return SliverList(
//      delegate: new SliverChildBuilderDelegate(
//        (BuildContext context, int index) {
//          return CartCardCheckout(onPressed: onPressed, cartPrices: total);
//        },
//        childCount: 1,
//      ),
//    );
//  }
//}
