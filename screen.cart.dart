import 'model.cart.dart';
import 'model.items.dart';
import 'package:flutter/material.dart';
import 'ui.list.product.dart';
import 'ui.util.dart';
import 'package:intl/intl.dart';
import 'screen.cart.form.dart';
import 'dialog.generic.dart';

class ScreenCart extends StatelessWidget {
  ScreenCart({this.cart});

  final ItemCart cart;

  @override
  Widget build(BuildContext context) {
    return new ScreenCartState(cart: cart);
  }
}

class ScreenCartState extends StatefulWidget {
  ScreenCartState({this.cart});

  final ItemCart cart;

  @override
  _ScreenCartBuild createState() => new _ScreenCartBuild(cart: cart);
}

class _ScreenCartBuild extends State<ScreenCartState> {
  _ScreenCartBuild({this.cart});

  List<DropdownMenuItem<String>> deliveryLocationItems = <DropdownMenuItem<String>>[];
  String deliveryLocationDropdown;
  Map deliveryDetails = {};
  List<String> deliveryLocationList = <String>[stringPlaceHolder, 'TGT', 'NCR', 'Luzon', 'Visayas', 'Mindanao'];

  bool isEditing;
  final ItemCart cart;

  bool canOrder = true;
  String orderLabel = "Checkout";
  static String stringPlaceHolder = "Please select your delivery location";

  @override
  void initState() {
    super.initState();
    cart.cartDelivery.isComplete == true ? isEditing = false : isEditing = true;
    cart.getItemDeliveryPrefs(doneEditing);
    deliveryLocationDropdown = stringPlaceHolder;
  }

  void editDetails() {
    setState(() {
      isEditing = true;
    });
  }

  void doneEditing() {
    setState(() {
      isEditing = false;
    });
  }

  void changeOrderButton(String s) {
    setState(() {
      orderLabel = s;
    });
  }

  void failedOrder(Map<String, ItemProduct> oosPL) {
    GenericDialogGenerator.failedOrder(context, (){
      setState(() {
        cart.refactorCart();
        canOrder = true;
        orderLabel = "Retry";
      });
    });
  }

  void initOrder() {
    if (isEditing) {
      GenericDialogGenerator.incompleteDetails(context);
    } else if (deliveryLocationDropdown != stringPlaceHolder) {
      setState(() {
        canOrder = false;
      });
      cart.cartDelivery.delivery = deliveryLocationDropdown;
      cart.checkoutCart(orderComplete, failedOrder, changeOrderButton);
    } else {
      GenericDialogGenerator.noDeliveryDetails(context);
    }
  }

  void orderComplete() {
    GenericDialogGenerator.completeOrder(context, () {
      Navigator.pop(context, true);
    });
  }

  void changedDeliveryLocation(String s) {
    setState(() {
      deliveryLocationDropdown = s;
      if (s != stringPlaceHolder) deliveryLocationList.remove(stringPlaceHolder);
    });
  }

  @override
  Widget build(BuildContext context) {
    deliveryLocationItems = UIUtils.createDropdownItems(deliveryLocationList);
    return new Theme(
      data: new ThemeData(),
      child: new Scaffold(
        body: new CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            title: Text(cart.cartDept),
          ),
          SliverList(
            delegate: new SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                switch (index) {
                  case 0:
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                      margin: EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        child: isEditing
                            ? CartForm(cartDelivery: cart.cartDelivery, onSaved: doneEditing)
                            : CartDetails(cartDelivery: cart.cartDelivery, onPressed: editDetails),
                      ),
                    );
                    break;
                  case 1:
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                      margin: EdgeInsets.only(bottom: 16.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                        ListTile(title: Text("Delivery location", style: AppTextStyles.titleStyle)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                          child: DropdownButton(value: deliveryLocationDropdown, items: deliveryLocationItems, onChanged: changedDeliveryLocation),
                        ),
                      ]),
                    );
                    break;
                }
              },
              childCount: 2,
            ),
          ),
          SliverListProduct(itemProducts: cart.cartProducts.productList),
        ]),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  child: Row(children: <Widget>[
                    Expanded(
                      child: Text("Total: ", style: AppTextStyles.labelRegular),
                    ),
                    Text(NumberFormat.currency(symbol: "PhP ").format(cart.cartPrices.total), style: AppTextStyles.priceRegular),
                  ]),
                ),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                color: Colors.lightBlue,
                child: Text(orderLabel, style: AppTextStyles.labelWhite),
                onPressed: canOrder ? initOrder : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
