import 'package:flutter/material.dart';
import 'model.orders.dart';
import 'ui.card.order.dart';
import 'ui.util.dart';
import 'screen.order.dart';

class SliverListOrder extends StatelessWidget {
  SliverListOrder({this.listOrder, this.label, this.refreshOrders}); // modified
  final List<ItemOrder> listOrder;
  final VoidCallback refreshOrders;
  final String label;

  void onOrderClicked(ItemOrder thisOrder, BuildContext context) async {
    bool cancelled = await Navigator.push(context, MaterialPageRoute(builder: (context) => new ScreenOrder(order: thisOrder)));
    refreshOrders();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: new SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index == 0) {
            return ListTile(
              title: Text(
                label,
                style: AppTextStyles.titleStyleBlue,
              ),
              trailing: IconButton(icon: Icon(Icons.refresh), onPressed: refreshOrders),
//              padding: EdgeInsets.all(16.0),
            );
          } else {
            return InkWell(
              onTap: () => onOrderClicked(listOrder[index - 1], context),
              child: Hero(
                tag: listOrder[index - 1].key,
                child: OrderCard(order: listOrder[index - 1]),
              ),
            );
//            return OrderCard(order: listOrder[index - 1]);
          }
        },
        childCount: listOrder.length + 1,
      ),
    );
  }
}
