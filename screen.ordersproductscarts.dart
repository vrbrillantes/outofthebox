import 'package:flutter/material.dart';
import 'model.cart.dart';
import 'model.items.dart';
import 'model.orders.dart';
import 'model.notification.dart';
import 'ui.list.product.dart';
import 'ui.list.order.dart';
import 'ui.list.cart.dart';
import 'package:qr_reader/qr_reader.dart';
import 'dialog.generic.dart';
import 'screen.cart.dart';
import 'ui.util.dart';
import 'util.preferences.dart';

class ScreenOrdersProductsCarts extends StatelessWidget {
  ScreenOrdersProductsCarts({this.onLogOut});

  final VoidCallback onLogOut;

  @override
  Widget build(BuildContext context) {
    return new ScreenOrdersProductsCartsState(onLogOut: onLogOut);
  }
}

class ScreenOrdersProductsCartsState extends StatefulWidget {
  ScreenOrdersProductsCartsState({this.onLogOut});

  final VoidCallback onLogOut;

  @override
  _ScreenOrdersProductsCartsBuild createState() => new _ScreenOrdersProductsCartsBuild(onLogOut: onLogOut);
}

class _ScreenOrdersProductsCartsBuild extends State<ScreenOrdersProductsCartsState> with SingleTickerProviderStateMixin {
  _ScreenOrdersProductsCartsBuild({this.onLogOut});

  final VoidCallback onLogOut;
  ListOrder myOrders = ListOrder.newListOrder();
  ListCart myCart = ListCart.empty();
  bool isLoggedIn = false;
  ListNotification notifications = ListNotification.empty();
  bool isUpdated = false;

  @override
  void initState() {
    super.initState();
    getCartContents();
    refreshOrders();
    AppPreferences.checkVersion((bool s) {
      isUpdated = s;
    });
  }

  void getCartContents() {
    CartPresenter.getMyCart((ListCart lc) {
      setState(() {
        myCart = lc;
        myCart.getProducts((ItemProduct ip) {
          setState(() {
            myCart.itemPProducts.addProduct(ip);
          });
        });
      });
    });
  }

  void refreshOrders() {
    OrdersPresenter.getMyOrders((ListOrder lo) {
      setState(() {
        myOrders = lo;// TODO RETURN
      });
    });
  }

  void scanQR() async {
    String scanResult = await QRCodeReader()
        .setAutoFocusIntervalInMs(200) // default 5000
        .setForceAutoFocus(true) // default false
        .setTorchEnabled(true) // default false
        .setHandlePermissions(true) // default true
        .setExecuteAfterPermissionGranted(true) // default true
        .scan();
    ProductPresenter.getItemStock(scanResult, (ItemProduct product) {
      setState(() {
        if (myCart.itemPProducts.addProduct(product)) {
          myCart.updateProduct(product);
        } else {
          GenericDialogGenerator.duplicateProduct(context);
        }
      });
    });
  }

  void updateProduct(ItemProduct m) {
    setState(() {
      myCart.updateProduct(m);
    });
  }

  void itemCancelled(ItemProduct ip) {
    setState(() {
      myCart.removeProduct(ip);
    });
  }

  void showCheckout() {
    isUpdated
        ? showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return SliverListCart2(listTotal: myCart, onPressed: onCheckout);
            })
        : GenericDialogGenerator.appNotUpdated(context);
  }

  void onCheckout(String dept) {
    myOrders.canOrder(dept) ? gotoCart(dept) : GenericDialogGenerator.hasPendingOrder(context);
  }

  void gotoCart(String dept) async {
    myCart.refreshProducts(dept);
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) => new ScreenCart(cart: myCart.dCartList[dept])));
    Navigator.pop(context);
    if (result != null) {
      setState(() {
        myCart.remove(dept);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        Scaffold(
          body: new CustomScrollView(slivers: <Widget>[
            SliverAppBar(
              title: Row(
                children: <Widget>[
                  Image.asset('images/headerlogo.png', height: 20.0),
                ],
              ),
              floating: true,
              pinned: true,
            ),
            SliverGridProduct(
              itemProducts: myCart.itemPProducts.productList,
              onChanged: updateProduct,
              onCancelled: itemCancelled,
            ),
            SliverListOrder(
              listOrder: myOrders.pendingOrderList,
              label: "Pending Orders",
              refreshOrders: refreshOrders,
            ),
            SliverListOrder(
              listOrder: myOrders.completeOrderList,
              label: "Completed Orders",
            ),
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: scanQR,
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: OOBBottomBar(
            showCheckout: showCheckout,
            onLogOut: onLogOut,
          ),
        ),
      ],
    );
  }
}

class OOBBottomBar extends StatefulWidget {
  OOBBottomBar({this.showCheckout, this.onLogOut});

  final VoidCallback showCheckout;
  final VoidCallback onLogOut;

  @override
  _OOBBottomBarState createState() => _OOBBottomBarState(showCheckout: showCheckout, onLogOut: onLogOut);
}

class _OOBBottomBarState extends State<OOBBottomBar> {
  _OOBBottomBarState({this.showCheckout, this.onLogOut});

  final VoidCallback showCheckout;
  final VoidCallback onLogOut;
  ListNotification notifs = ListNotification.empty();

  void dismissNotification(String key) {
    notifs.removeNotification(key);
  }

  void getNotifications() {
    NotificationPresenter.getNotificationList((ListNotification lnot) {
      setState(() {
        notifs = lnot;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.lightBlue,
      shape: CircularNotchedRectangle(),
      child: Row(
        children: <Widget>[
          IconButton(
            color: Colors.white,
            icon: Icon(
              Icons.shopping_cart,
              semanticLabel: 'Check out',
            ),
            onPressed: showCheckout,
          ),
          FlatButton(
            child: Text(
              "Checkout",
              style: AppTextStyles.labelWhite,
            ),
            onPressed: showCheckout,
          ),
          Expanded(child: SizedBox()),
          NotificationBadge(notifications: notifs, dismissNotification: dismissNotification),
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.exit_to_app),
            onPressed: onLogOut,
          ),
        ],
      ),
    );
  }
}

class NotificationBadge extends StatefulWidget {
  NotificationBadge({this.dismissNotification, this.notifications});

  final ListNotification notifications;
  final void Function(String) dismissNotification;

  @override
  _NotificationBadgeState createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends State<NotificationBadge> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            child: PopupMenuButton<String>(
          itemBuilder: (BuildContext context) => UIUtils.createNotificationsItems(widget.notifications),
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          onSelected: widget.dismissNotification,
        )),
        widget.notifications.notificationList.length > 0
            ? Positioned(
                // draw a red marble
                top: 15.0,
                right: 10.0,
                child: new Icon(Icons.brightness_1, size: 8.0, color: Colors.redAccent),
              )
            : SizedBox(),
      ],
    );
  }
}

