import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rink_now/scoped_models/main_model.dart';

import '../types/post.dart';

class PostCreatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PostCreatePageState();
  }
}

List<String> rinks = ["Canlan", "Port Credit", "Scotia", null];

class _PostCreatePageState extends State<PostCreatePage> {
  double _currentPrice = 100;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //List<String> rinks = ["Canlan", "Port Credit", "Scotia"];
  final Map<String, dynamic> _formData = {
    "city": null,
    "date": DateTime.now(),
    "day": DateTime.now(),
    "time": TimeOfDay(hour: 18, minute: 0),
    "description": null,
    "selectedRink": null,
    "price": null,
  };

//METHOD
  void _submitForm(Function addPost) {
    _formData["date"] = _formData["day"];
    print(_formData["time"].hour);
    _formData["date"].add(Duration(
        hours: _formData["time"].hour, minutes: _formData["time"].minute));
    print(_formData["date"]);
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    addPost(_formData['city'], _formData['description'],
        _formData['selectedRink'], _formData["date"], _formData['price']);
    Navigator.pushReplacementNamed(context, '/posts');
  }

//WIDGET
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

  //BUILD METHOD
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
              decoration: InputDecoration(labelText: 'Post City'),
              validator: (String value) {
                if (value.trim().length <= 0) {
                  return 'City is required';
                }
              },
              onSaved: (String value) {
                _formData["city"] = value;
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
              keyboardType: TextInputType.number,
              onSaved: (String value) {
                _formData["price"] = double.parse(value);
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            Center(child: Container(child: Text(_formData['date'].toString()))),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              child: Text('Select Date'),
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              onPressed: () {
                showDatePicker(
                        firstDate: DateTime.now().add(new Duration(days: -60)),
                        lastDate: DateTime.now().add(new Duration(days: 60)),
                        initialDate: DateTime.now(),
                        context: context)
                    .then((DateTime result) {
                  _formData["day"] = result;
                });
              },
            ),
            RaisedButton(
              child: Text('Select Time'),
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              onPressed: () {
                showTimePicker(
                  initialTime: TimeOfDay(hour: 18, minute: 0),
                  context: context,
                ).then((TimeOfDay result) {
                  print(result);
                  _formData["time"] = result;
                });
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }
}
