import 'util.firebase.dart';

class ListProduct {
  Map<String, ItemProduct> productList = {};

  ListProduct.newProduct();

  ListProduct.fromJson(Map data) {
    if (data != null) {
      data.forEach((key, value) {
        productList[key] = ItemProduct.newDeviceFromJson(key, value);
      });
    }
  }

  Map<String, dynamic> createProductsPayload() {
    Map<String, dynamic> payloadItems = {};
    productList.forEach((String key, ItemProduct ip) {
      payloadItems[key] = {'P': ip.productDevice.price, 'Q': ip.productDevice.quantity, 'I': ip.model};
    });
    return payloadItems;
  }

  Map<String, ItemProduct> getProducts(String dept) {
    Map<String, ItemProduct> deptProducts = {};
    productList.forEach((String key, ItemProduct ip) {
      print(ip.dept + " DEPTU " + dept);
      if (ip.dept == dept) {
        deptProducts[key] = ip;
      }
    });
    return deptProducts;
  }

  void removeProducts({String dept, String key}) {
    if (dept != null) {
      productList.forEach((String k, ItemProduct v) {
        if (v.dept == dept) {
          productList.remove(k);
        }
      });
    } else if (key != null) {
      productList.remove(key);
    } else {
      productList = {};
    }
  }

  void updateProduct(ItemProduct ip) {
    if (ip.productDevice.quantity == 0) {
      productList.remove(ip.key);
    } else {
      productList[ip.key] = ip;
    }
  }

  bool addProduct(ItemProduct ip) {
    if (!productList.containsKey(ip.key)) {
      productList[ip.key] = ip;
      return true;
    }
    return false;
  }
}

class ItemDevice {
  final String key;
  int price;
  int quantity;
  int total;
  String item;

  void editQuantity(int q) {
    quantity = q;
    total = quantity * price;
  }

  Map createCartPayload() {
    return {"I": item, "P": price, "Q": quantity};
  }

  ItemDevice.fromProduct(this.key, this.quantity, ItemProduct data) {
    price = data.price;
    item = data.model;
    total = quantity * price;
  }

  ItemDevice.fromJson(this.key, Map data) {
    if (data != null) {
      price = data['P'];
      quantity = data['Q'];
      item = data['I'];
      total = quantity * price;
    }
  }
}

class ProductPresenter {
  static void getItemStock(String itemID, void onData(ItemProduct ip), {int quantity = 1}) {
    FirebaseMethods.getItemByItemID(itemID, (data) {
      onData(ItemProduct.fromJson(itemID, quantity, data));
    });
  }
}

class ItemProduct {
  final String key;
  String brand;
  String condition;
  String dept;
  String image;
  String model;
  int price;
  bool inactive;
  ItemStock productStock;
  ItemDevice productDevice;

  ItemProduct.fromJson(this.key, int quantity, Map data) {
    updateProduct(data);
    productDevice = ItemDevice.fromProduct(key, quantity, this);
  }

  ItemProduct.newDeviceFromJson(this.key, Map data) {
    productDevice = ItemDevice.fromJson(key, data);
  }

  void setDevice(ItemDevice id) {
    productDevice = id;
  }

  void updateProduct(Map data) {
    brand = data['Brand'];
    condition = data['Condition'];
    model = data['Model'];
    price = data['Price'];
    dept = data['Dept'];
    image = data['Image'];
    inactive = data.containsKey('Inactive') ? (data['Inactive'] == "Inactive" ? true : false) : false;
    productStock = ItemStock.fromJson(data['Stock'], data['Orders']);
    if (productDevice != null && productDevice.quantity > productStock.remaining) {
      productDevice.quantity = productStock.remaining;
      productDevice.editQuantity(productStock.remaining);
    }
  }
}

class ItemStock {
  int stock;
  int remaining;

  ItemStock.fromJson(this.stock, Map data) {
    remaining = this.stock;
    if (data != null) {
      data.forEach((key, value) {
        remaining = remaining - value;
      });
    }
  }
}
