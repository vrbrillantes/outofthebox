import 'util.firebase.dart';
import 'model.items.dart';
import 'model.orders.dart';
import 'model.orderdetails.dart';
import 'util.util.dart';
import 'package:random_string/random_string.dart';

class CartPresenter {
  static void getMyCart(void onData(ListCart lc)) {
    FirebaseMethods.getCartListByUserID((data) {
      onData(ListCart.firebaseStoredCart(data));
    });
  }

  static void tryOrder(Map data, Map queueData, void done()) {
    FirebaseMethods.setOrderNew(data, queueData, done);
  }

  static void addToCart(String dept, String itemID, Map data, void done()) {
    FirebaseMethods.setCartItemNew(dept, itemID, data, done);
  }

  static void clearCart(String dept) {
    FirebaseMethods.deleteCart(dept);
  }

  static void removeFromCart(String dept, String itemID) {
    FirebaseMethods.deleteCartItem(dept, itemID);
  }
}

class ListCart {
  Map<String, ItemCart> dCartList = {};
  ListProduct itemPProducts = ListProduct.newProduct();

  void updateProduct(ItemProduct pp) {
    if (!dCartList.containsKey(pp.dept)) {
      dCartList[pp.dept] = ItemCart.init(pp.dept);
    }
    dCartList[pp.dept].addProduct(pp.productDevice.quantity, pp);
    CartPresenter.addToCart(pp.dept, pp.key, pp.productDevice.createCartPayload(), () {});
  }

  void refreshProducts(String dept) {
    print("DEPTU");
    dCartList[dept].cartProducts.productList = itemPProducts.getProducts(dept);
  }
  void remove(String dept) {
    dCartList.remove(dept);
    itemPProducts.removeProducts(dept: dept);
    CartPresenter.clearCart(dept);
  }

  void removeProduct(ItemProduct pp) {
    int totalRemaining = dCartList[pp.dept].removeProduct(pp);
    if (totalRemaining == 0) {
      dCartList.remove(pp.dept);
    }
    CartPresenter.removeFromCart(pp.dept, pp.key);
    itemPProducts.removeProducts(key: pp.key);
  }

  void getProducts(void addProduct(ItemProduct ip)) {
    dCartList.forEach((key, value) {
      value.cartProducts.productList.forEach((String kk, ItemProduct id) {
        dCartList[key].getProduct(kk, id.productDevice.quantity, (ItemProduct ip) {
          addProduct(ip);
        });
      });
    });
  }

  ListCart.empty();

  ListCart.firebaseStoredCart(data) {
    data.forEach((key, value) {
      dCartList[key] = ItemCart.firebaseStoredCartItem(key, value);
    });
  }
}

class ItemCart {
  final String cartDept;
  ItemPriceTotal cartPrices = ItemPriceTotal.newTotals();
  ListProduct cartProducts = ListProduct.newProduct();
  ItemDelivery cartDelivery = ItemDelivery.newDelivery();
  ListProduct outOfStock = ListProduct.newProduct();

  ItemCart.firebaseStoredCartItem(this.cartDept, data) {
    cartProducts = ListProduct.fromJson(data); //TODO RETURN
    cartPrices = ItemPriceTotal.firebaseStoredTotal(data);
  }

  ItemCart.init(this.cartDept);

  void getItemDeliveryPrefs(void done()) {
    cartDelivery.getFromPrefs(done);
  }

  void refactorCart() {
    outOfStock.productList.forEach((String pid, ItemProduct ip){
      cartPrices.editPrice(ip.key, (ip.price * ip.productStock.remaining));
      ip.productDevice.quantity = ip.productStock.remaining;
      cartProducts.updateProduct(ip);//TODO RETURN
    });
  }


  Map createCartPayload() {
    trySaveRetrieve();
    Map deliveryDetails = cartDelivery.deliveryDetailsMap();
    deliveryDetails['Orders'] = cartProducts.createProductsPayload();
    deliveryDetails['Price'] = cartPrices.createPricePayload();
    deliveryDetails['SLA'] = createSLAPayload();
    deliveryDetails['Dept'] = cartDept;
    deliveryDetails['OrderID'] = "GB" + DateUtil.getOrderIDDate() + randomAlphaNumeric(10).toUpperCase();
    return deliveryDetails;
  }

  Map createSLAPayload() {
    DateTime warning = DateUtil.getSLADate(3);
    DateTime cancellation = DateUtil.getSLADate(3, date: warning);
    return {'Cancellation': DateUtil.getDateSuperSimple(cancellation), 'Warning': DateUtil.getDateSuperSimple(warning)};
  }

  Map createQueuePayload() {
    return {'done': 'false', 'did': cartDept};
  }

  //TODO delete me
  void trySaveRetrieve() {
    cartDelivery.savePrefs(() {});
  }

  int removeProduct(ItemProduct ip) {
    cartPrices.editPrice(ip.key, 0);
    cartProducts.removeProducts(key: ip.key); //TODO RETURN
    return cartPrices.total;
  }

  void addProduct(int quantity, ItemProduct ip) {
//    print(ip.productDevice.quantity.toString() + " ADD PRODUCT");

    cartPrices.editPrice(ip.key, (ip.price * quantity));
    cartProducts.addProduct(ip);//TODO RETURN
  }

  void getProduct(String itemID, int quantity, void onData(ItemProduct ip)) {
    ProductPresenter.getItemStock(itemID, (ItemProduct product) {
      onData(product);
      cartProducts.productList[itemID] = product;//TODO RETURN
    }, quantity: quantity);
  }

  void checkoutCart(void done(), void failed(Map<String, ItemProduct> oosPL), void changeOrderButton(String s)) {
    outOfStock.removeProducts();
    changeOrderButton("Checking stock");
    getCartStock(() {
      if (outOfStock.productList.length > 0) {
        failed(outOfStock.productList);
        changeOrderButton("Out of stock");
      } else {
        changeOrderButton("Submitting order");
        submitOrder(() {
          done();
        });
      }
    });
  }

  void submitOrder(void done()) {
    CartPresenter.tryOrder(createCartPayload(), createQueuePayload(), done);
  }

  void getCartStock(void done()) {
    int checked = 0;

    cartProducts.productList.forEach((String k, ItemProduct ip) {
      ProductPresenter.getItemStock(ip.key, (ItemProduct rp) {
        checked++;
        if (rp.productStock.remaining < ip.productDevice.quantity) outOfStock.addProduct(rp);
        if (rp.inactive) outOfStock.addProduct(rp);
        if (checked == cartProducts.productList.length) {
          done();
        }
      });
    });
  }
}
