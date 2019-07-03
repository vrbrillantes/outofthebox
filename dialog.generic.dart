import 'package:flutter/material.dart';
import 'ui.util.dart';

class GenericDialogGenerator {
  static String duplicateProductString = "This item is already in your cart";
  static String confirmProductString = "Confirm change in quantity?";
  static String failedLoginString = "Please login using your Globe GMail";
  static String cancelProductString = "Cancel item?";
  static String cancelOrderString = "Cancel order?";
  static String completeOrderString = "Order submitted";
  static String failedOrderString = "Some items in your shopping cart are out of stock. Adjust cart?";
  static String noDeliveryDetailsString = "Please choose your preferred delivery location";
  static String incompleteDeliveryString = "Please complete your contact information";
  static String incompleteDetailsString = "Please review the following information: ";
  static String hasPendingOrderString = "You have pending orders";
  static String appNotUpdatedString = "App not updated";
  static String logOutString = "Log out of Out of the Box?";

  static void failedOrder(BuildContext context, VoidCallback onComplete) {
    choiceDialog(context, failedOrderString, onYes: onComplete);
  }

  static void failedLogin(BuildContext context, VoidCallback onYes) {
    confirmDialog(context, failedLoginString, onYes: onYes);
  }

  static void incompleteDetails(BuildContext context, {String s}) {
    confirmDialog(context, s == null ? incompleteDeliveryString : incompleteDetailsString + s);
  }


  static void appNotUpdated(BuildContext context) {
    confirmDialog(context, appNotUpdatedString);
  }
  static void noDeliveryDetails(BuildContext context) {
    confirmDialog(context, noDeliveryDetailsString);
  }

  static void completeOrder(BuildContext context, VoidCallback onComplete) {
    confirmDialog(context, completeOrderString, onYes: onComplete);
  }

  static void hasPendingOrder(BuildContext context) {
    confirmDialog(context, hasPendingOrderString);
  }

  static void duplicateProduct(BuildContext context) {
    confirmDialog(context, duplicateProductString);
  }

  static void confirmProduct(BuildContext context, VoidCallback onPressed) {
    choiceDialog(context, confirmProductString, onYes: onPressed);
  }

  static void cancelProduct(BuildContext context, VoidCallback onPressed) {
    choiceDialog(context, cancelProductString, onYes: onPressed);
  }
  static void cancelOrder(BuildContext context, VoidCallback onPressed) {
    choiceDialog(context, cancelOrderString, onYes: onPressed);
  }

  static void logOut(BuildContext context, VoidCallback onPressed) {
    choiceDialog(context, logOutString, onYes: onPressed);
  }

  static void confirmDialog(BuildContext context, String message, {VoidCallback onYes}) {
    void onPressed() {
      Navigator.pop(context);
      onYes();
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return GenericDialog(context, message, onPressed);
      },
    );
  }

  static void choiceDialog(BuildContext context, String message, {VoidCallback onYes, VoidCallback onNo}) {
    void onPressed(bool b) {
      Navigator.pop(context);
      b ? onYes() : onNo();
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return GenericChoiceDialog(context, message, onPressed);
      },
    );
  }
}

class GenericDialog extends StatelessWidget {
  GenericDialog(this.context, this.message, this.onPressed);

  final BuildContext context;
  final String message;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message, style: AppTextStyles.labelRegular),
      actions: <Widget>[
        FlatButton(onPressed: onPressed, color: Colors.lightBlueAccent, child: Text('OK', style: AppTextStyles.labelWhite)),
      ],
    );
  }
}

class GenericChoiceDialog extends StatelessWidget {
  GenericChoiceDialog(this.context, this.message, this.onPressed);

  final void Function(bool) onPressed;
  final BuildContext context;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message, style: AppTextStyles.labelRegular),
      actions: <Widget>[
        FlatButton(
          onPressed: () => onPressed(false),
          color: Colors.lightBlueAccent,
          child: Text('No', style: AppTextStyles.labelWhite),
        ),
        FlatButton(
          onPressed: () => onPressed(true),
          color: Colors.lightBlueAccent,
          child: Text('Yes', style: AppTextStyles.labelWhite),
        ),
      ],
    );
  }
}
