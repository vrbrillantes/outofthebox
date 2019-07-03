import 'model.items.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'ui.util.dart';
import 'dialog.generic.dart';

class ScreenProduct extends StatelessWidget {
  ScreenProduct({this.product});

  final ItemProduct product;

  @override
  Widget build(BuildContext context) {
    print(product.model);
    return new ScreenProductState(product: product);
  }
}

class ScreenProductState extends StatefulWidget {
  ScreenProductState({this.product});

  final ItemProduct product;

  @override
  _ScreenProductBuild createState() => new _ScreenProductBuild(product: product);
}

class _ScreenProductBuild extends State<ScreenProductState> {
  _ScreenProductBuild({this.product});

  double boxHeight = 100.0;
  bool didQuantityChange = false;
  int quantity = 1;
  int total;
  final ItemProduct product;
  List<int> quantityOptions = <int>[];

  @override
  void initState() {
    for (int i = 1; i <= product.productStock.remaining; i++) {
      quantityOptions.add(i);
    }
    super.initState();
  }

  void quantityChanged(int i) {
    didQuantityChange = true;
    setState(() {
      product.productDevice.editQuantity(i);
    });
  }

  Future<bool> cancelForm() {
    if (!didQuantityChange) {
      cancelItem(false);
    } else {
      GenericDialogGenerator.confirmProduct(context, () {
        cancelItem(false);
      });
    }
    return null;
  }

  void cancelItem(bool cancel) {
    if (cancel) {
      GenericDialogGenerator.cancelProduct(context, () {
        product.productDevice.quantity = 0;
        Navigator.pop(context, product);
      });
    } else {
      Navigator.pop(context, product);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Theme(
      data: new ThemeData(),
      child: new Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(product.model),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(32.0),
                  child: Hero(
                    tag: product.key,
                    child: Image.network(product.image, height: 300.0, fit: BoxFit.contain),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(product.dept, style: AppTextStyles.labelMini),
                          Text(product.brand + " " + product.model, style: AppTextStyles.titleStyle),
                          Text(product.condition, style: AppTextStyles.labelRegular),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            NumberFormat.currency(symbol: "PhP ").format(product.price),
                            style: AppTextStyles.labelMiniDark,
                            textAlign: TextAlign.end,
                          ),
                          Text(NumberFormat.currency(symbol: "PhP ").format(product.productDevice.total), style: AppTextStyles.priceRegular),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: <Widget>[
              quantityOptions.length > 0
                  ? Padding(
                      padding: EdgeInsets.all(1.0),
                      child: IconButton(
                        icon: Icon(Icons.cancel),
                        color: Colors.redAccent,
                        onPressed: () => cancelItem(true),
                      ),
                    )
                  : SizedBox(),
              Expanded(
                child: Form(
                  onWillPop: cancelForm,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: quantityOptions.length > 0
                        ? DropdownButton(
                            value: quantityOptions.length > product.productDevice.quantity ? product.productDevice.quantity : quantityOptions.length,
                            onChanged: quantityChanged,
                            items: quantityOptions.map((int i) {
                              return DropdownMenuItem<int>(
                                  value: i,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Quantity: " + i.toString(),
                                        textAlign: TextAlign.end,
                                      ),
                                    ],
                                  ));
                            }).toList(),
                          )
                        : Text(
                            "Out of stock",
                            style: AppTextStyles.priceRegular,
                          ),
                  ),
                ),
              ),
              quantityOptions.length > 0
                  ? Expanded(
                      child: FlatButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                        padding: EdgeInsets.all(16.0),
                        color: AppColors.appColorThinkBlue,
                        child: Text("Confirm", style: AppTextStyles.labelWhite),
                        onPressed: () => cancelItem(false),
                      ),
                    )
                  : Expanded(
                      child: FlatButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                        padding: EdgeInsets.all(16.0),
                        color: AppColors.appColorRed,
                        child: Text("Remove Item", style: AppTextStyles.labelWhite),
                        onPressed: () => cancelItem(true),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
