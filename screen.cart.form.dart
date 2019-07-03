import 'model.orderdetails.dart';
import 'package:flutter/material.dart';
import 'ui.util.dart';
import 'dialog.generic.dart';


class CartForm extends StatefulWidget {
  CartForm({this.cartDelivery, this.onSaved});

  final VoidCallback onSaved;
  final ItemDelivery cartDelivery;

  @override
  _ScreenCartFormBuild createState() => new _ScreenCartFormBuild(cartDelivery: cartDelivery, onSaved: onSaved);
}

class _ScreenCartFormBuild extends State<CartForm> {
  _ScreenCartFormBuild({this.cartDelivery, this.onSaved});

  static String stringPlaceHolder = "Please select your employee type";
  final VoidCallback onSaved;
  final ItemDelivery cartDelivery;
  Map deliveryDetails = {};
  List<String> employeeTypeList = <String>[stringPlaceHolder, 'Regular', 'Contractual', 'Consultant', 'Vendor'];
  String employeeTypeDropdown;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController firstNameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController idNumberController = new TextEditingController();
  final TextEditingController mobileNumberController = new TextEditingController();
  final TextEditingController representativeController = new TextEditingController();
  final TextEditingController officeAddressController = new TextEditingController();
  List<DropdownMenuItem<String>> employeeTypeItems = <DropdownMenuItem<String>>[];

  @override
  void initState() {
    super.initState();
    firstNameController.text = cartDelivery.first;
    lastNameController.text = cartDelivery.last;
    idNumberController.text = cartDelivery.id;
    mobileNumberController.text = cartDelivery.mobile;
    representativeController.text = cartDelivery.representative;
    officeAddressController.text = cartDelivery.office;
    employeeTypeDropdown = cartDelivery.emp == null ? stringPlaceHolder : cartDelivery.emp;
    if (cartDelivery.emp != null) employeeTypeList.remove(stringPlaceHolder);
  }

  void onSaveFill(String field, String value) {
    deliveryDetails[field] = value;
  }
  void showErrors(List<String> ss) {
    GenericDialogGenerator.incompleteDetails(context, s: ss.join(', '));
  }

  void saveDetails() {
    final FormState form = _formKey.currentState;
    form.save();
    deliveryDetails['Emp'] = employeeTypeDropdown;
    cartDelivery.submitDeliveryDetails(deliveryDetails, onSaved, showErrors);
  }

  void changedEmployeeType(String s) {
    setState(() {
      if (s != stringPlaceHolder) employeeTypeList.remove(stringPlaceHolder);
      employeeTypeDropdown = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    employeeTypeItems = UIUtils.createDropdownItems(employeeTypeList);
    return new Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(8.0), child: Text("Name", style: AppTextStyles.labelRegular)),
          StyledTextFormField(editingController: firstNameController, field: "First", action: onSaveFill, label: "First name"),
          StyledTextFormField(editingController: lastNameController, field: "Last", action: onSaveFill, label: "Last name"),
          Padding(padding: EdgeInsets.all(8.0), child: Text("Employee details", style: AppTextStyles.labelRegular)),
          StyledTextFormField(editingController: idNumberController, field: "ID", action: onSaveFill, label: "ID number"),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: DropdownButton(value: employeeTypeDropdown, items: employeeTypeItems, onChanged: changedEmployeeType),
          ),
          StyledTextFormField(editingController: mobileNumberController, field: "Mobile", action: onSaveFill, label: "Mobile number", numbersOnly: true),
          Padding(padding: EdgeInsets.all(8.0), child: Text("Delivery information", style: AppTextStyles.labelRegular)),
          StyledTextFormField(
              editingController: representativeController, field: "Representative", action: onSaveFill, label: "Authorized representative"),
          StyledTextFormField(maxLines: 5, editingController: officeAddressController, field: "Office", action: onSaveFill, label: "Complete office address"),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: RaisedButton(
              color: Colors.lightBlue,
              child: Text('Update details', style: AppTextStyles.labelWhite),
              onPressed: saveDetails,
            ),
          ),
        ],
      ),
    );
  }
}

class CartDetails extends StatelessWidget {
  CartDetails({this.cartDelivery, this.onPressed});

  final ItemDelivery cartDelivery;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
            title: Text(cartDelivery.last + ", " + cartDelivery.first, style: AppTextStyles.titleStyle),
            trailing: IconButton(icon: Icon(Icons.edit), onPressed: onPressed)),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            child: Text("ID number: " + cartDelivery.id, style: AppTextStyles.labelRegularLight)),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            child: Text("Employee type: " + cartDelivery.emp, style: AppTextStyles.labelRegularLight)),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            child: Text("Mobile number: " + cartDelivery.mobile.toString(), style: AppTextStyles.labelRegularLight)),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            child: Text("Authorized representative: " + cartDelivery.representative, style: AppTextStyles.labelRegularLight)),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            child: Text("Complete office address: " + cartDelivery.office, style: AppTextStyles.labelRegularLight)),
        SizedBox(height: 16.0),
      ],
    );
  }
}
