import 'package:flutter/material.dart';
import 'ui.card.product.dart';
import 'screen.product.dart';
import 'model.items.dart';
import 'model.orders.dart';

class SliverGridProduct extends StatelessWidget {
  SliverGridProduct({this.itemProducts, this.scanQR, this.onChanged, this.onCancelled}); // modified
  final VoidCallback scanQR;
  final void Function(ItemProduct) onCancelled;
  final void Function(ItemProduct) onChanged;
  final Map<String, ItemProduct> itemProducts;

  void onProductClick(ItemProduct ip, BuildContext context) async {
    ItemProduct cancelled = await Navigator.push(context, MaterialPageRoute(builder: (context) => new ScreenProduct(product: ip)));
    if (cancelled.productDevice.quantity == 0) {
      onCancelled(cancelled);
    } else {
      onChanged(cancelled);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> listProduct = itemProducts.keys.toList();
    return SliverGrid(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 0.0,
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 0.0,
      ),
      delegate: new SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return InkWell(
            onTap: () => onProductClick(itemProducts[listProduct[index]], context),
            child: ProductCard(
              item: itemProducts[listProduct[index]],
            ),
          );
        },
        childCount: listProduct.length,
      ),
    );
  }
}

class SliverListProduct extends StatelessWidget {
  SliverListProduct({this.itemProducts}); // modified
  final Map<String, ItemProduct> itemProducts;

  @override
  Widget build(BuildContext context) {
    List<String> listProduct = itemProducts.keys.toList();
    return SliverList(
      delegate: new SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return ProductCardCart(item: itemProducts[listProduct[index]]);
        },
        childCount: itemProducts.length,
      ),
    );
  }
}

class SliverListOrderProduct extends StatelessWidget {
  SliverListOrderProduct({this.itemProducts}); // modified
  final Map<String, ItemProduct> itemProducts;

  @override
  Widget build(BuildContext context) {
    List<String> listProduct = itemProducts.keys.toList();
    return SliverList(
      delegate: new SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return ProductCardCondensed(item: itemProducts[listProduct[index]].productDevice);
        },
        childCount: itemProducts.length,
      ),
    );
  }
}
