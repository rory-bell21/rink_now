import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rink_now/scoped_models/main_model.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

import '../types/post.dart';

class PostCreatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PostCreatePageState();
  }
}

List<String> rinks = ["Canlan", "Port Credit", "Scotia", null];

class _PostCreatePageState extends State<PostCreatePage> {
  DateTime newDate;
  String selectedCity = "Other";
  List<DropdownMenuItem<String>> cityOptions = [
    DropdownMenuItem<String>(value: "Other", child: Text("Other")),
    DropdownMenuItem<String>(value: "Oakville", child: Text("Oakville")),
    DropdownMenuItem<String>(value: "Toronto", child: Text("Toronto")),
    DropdownMenuItem<String>(value: "Etobicoke", child: Text("Etobicoke")),
    DropdownMenuItem<String>(value: "Vaughn", child: Text("Vaughn")),
    DropdownMenuItem<String>(value: "Mississauga", child: Text("Mississauga")),
    DropdownMenuItem<String>(value: "Oshawa", child: Text("Oshawa")),
    DropdownMenuItem<String>(value: "North York", child: Text("North York")),
  ];

  double _currentPrice = 100;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //List<String> rinks = ["Canlan", "Port Credit", "Scotia"];
  final Map<String, dynamic> _formData = {
    "city": "Other",
    "date": DateTime.now(),
    "description": null,
    "selectedRink": null,
    "price": null,
  };

//METHOD
  void _submitForm(Function addPost) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    addPost(_formData['city'], _formData['description'],
        _formData['selectedRink'], _formData["date"], _formData['price']);
    Navigator.pushReplacementNamed(context, '/posts');
  }

//WIDGE
  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return RaisedButton(
        child: Text('Save'),
        color: Theme.of(context).primaryColorDark,
        textColor: Colors.white,
        onPressed: () {
          _submitForm(model.addPost);
        },
      );
    });
  }

  void _showDialog() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new NumberPickerDialog.decimal(
            minValue: 10,
            maxValue: 500,
            title: new Text("Pick a new price"),
            initialDoubleValue: 100.0,
          );
        }).then((int value) {
      if (value != null) {
        setState(() => _currentPrice = value / 1);
      }
    });
  }

  //BUILD METHO
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Rink'),
              validator: (String value) {
                if (value.trim().length <= 0) {
                  return 'Rink is required';
                }
              },
              onSaved: (String value) {
                _formData["selectedRink"] = value;
              },
            ),
            TextFormField(
              maxLines: 4,
              decoration: InputDecoration(labelText: 'Post Description'),
              validator: (String value) {
                if (value.trim().length <= 0) {
                  return 'Description is required';
                }
              },
              onSaved: (String value) {
                _formData["description"] = value;
              },
            ),
            TextFormField(
              decoration: new InputDecoration(labelText: "Enter Price"),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (String value) {
                if (value.trim().length <= 0) {
                  return 'Price is required';
                }
              },
              onSaved: (String value) {
                _formData["price"] = double.parse(value);
              },
            ),
            SizedBox(
              height: 30.0,
            ),
            Column(
              children: <Widget>[
                Text(
                  "Select City: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Theme(
                    isMaterialAppTheme: true,
                    data: ThemeData.fallback(),
                    child: DropdownButton<String>(
                      isExpanded: false,
                      value: selectedCity,
                      items: cityOptions,
                      onChanged: (String newValue) {
                        setState(() {
                          selectedCity = newValue;
                          _formData["city"] = newValue;
                        });
                      },
                    )),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Center(child: Text('Select Date')),
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  onPressed: () {
                    showDatePicker(
                            firstDate: DateTime.now().add(Duration(days: -60)),
                            lastDate: DateTime.now().add(Duration(days: 60)),
                            initialDate: DateTime.now(),
                            context: context)
                        .then((DateTime selectedDate) {
                      showTimePicker(
                        initialTime: TimeOfDay(hour: 18, minute: 0),
                        context: context,
                      ).then((TimeOfDay selectedTime) {
                        setState(() {
                          _formData["date"] = selectedDate.add(Duration(
                              hours: selectedTime.hour,
                              minutes: selectedTime.minute));
                        });
                      });
                    });
                  },
                ),
                Container(),
                Container(
                    child: Center(
                        child: Text(
                  "              " +
                      DateFormat.MMMd().format(_formData[
                          'date']) + //how to get this to update when date is selected, might need to make a new widget
                      ", " +
                      DateFormat.jm().format(_formData['date']),
                )))
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(child: _buildSubmitButton()),
          ],
        ),
      ),
    );
  }
}
