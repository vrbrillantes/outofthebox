import 'package:flutter/material.dart';
import 'model.notification.dart';

class ExpandedButton extends StatelessWidget {
  ExpandedButton({this.action, this.label});

  final VoidCallback action;
  final String label;

  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new Container(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: new RaisedButton(
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
          padding: EdgeInsets.all(16.0),
          color: AppColors.appColorThinkBlue,
          child: new Text(label, style: AppTextStyles.labelWhite),
          onPressed: action,
        ),
      ),
    );
  }
}

class UIUtils {
  static List<DropdownMenuItem<String>> createDropdownItems(List<String> choices) {
    return choices.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  static List<PopupMenuItem<String>> createNotificationsItems(ListNotification notifs) {
    List<PopupMenuItem<String>> popupList = <PopupMenuItem<String>>[];
    notifs.notificationList.forEach((ItemNotification inot) {
      popupList.add(PopupMenuItem<String>(
        value: inot.key,
        child: Text(inot.message, style: AppTextStyles.labelRegularLight),
      ));
    });
    return popupList;
  }
}

class StyledTextFormField extends StatelessWidget {
  StyledTextFormField({this.field, this.editingController, this.value, this.action, this.label, this.maxLines, this.numbersOnly = false});

  final void Function(String, String) action;
  final String field;
  final String label;
  final bool numbersOnly;
  final int maxLines;
  final String value;

  final TextEditingController editingController;

  void onSavedAction(String s) {
    action(field, s);
  }

  @override
  Widget build(BuildContext context) {
    editingController.text = value;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: TextFormField(
        keyboardType: numbersOnly ? TextInputType.phone : TextInputType.text,
        maxLines: maxLines == null ? 1 : maxLines,
        controller: editingController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12.0),
          hintText: label,
          border: OutlineInputBorder(),
        ),
        onSaved: onSavedAction,
      ),
    );
  }
}
class AppColors {
  static Color appColorLight = Color.fromARGB(255, 154, 154, 154);
  static Color appColorLightPlus = Color.fromARGB(255, 172, 172, 172);
  static Color appColorRed = Color.fromARGB(255, 208, 0, 0);
  static Color appColorWhite = Colors.white;
  static Color appColorThinkBlue = Color.fromARGB(255, 59, 138, 233);
}
class AppTextStyles {
  static TextStyle titleStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: AppColors.appColorLight,
  );
  static TextStyle titleStyleLight = TextStyle(
    fontSize: 18.0,
    color: AppColors.appColorLight,
  );
  static TextStyle titleStyleBlue = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: AppColors.appColorThinkBlue,
  );
  static TextStyle priceRegular = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 17.0,
    color: AppColors.appColorRed,
  );
  static TextStyle priceMini = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12.0,
    color: AppColors.appColorRed,
  );
  static TextStyle priceMiniLight = TextStyle(
    fontSize: 12.0,
    color: AppColors.appColorRed,
  );
  static TextStyle labelMiniBold = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12.0,
    color: AppColors.appColorLightPlus,
  );
  static TextStyle labelMiniDarkBold = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12.0,
    color: AppColors.appColorLight,
  );
  static TextStyle labelMini = TextStyle(
    fontSize: 12.0,
    color: AppColors.appColorLightPlus,
  );
  static TextStyle labelMiniDark = TextStyle(
    fontSize: 12.0,
    color: AppColors.appColorLight,
  );
  static TextStyle labelRegular = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: AppColors.appColorLight,
  );
  static TextStyle labelRegularLight = TextStyle(
    fontSize: 14.0,
    color: AppColors.appColorLight,
  );
  static TextStyle labelWhite = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: AppColors.appColorWhite,
  );
  static TextStyle labelWhiteMini = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
    color: AppColors.appColorWhite,
  );
}
