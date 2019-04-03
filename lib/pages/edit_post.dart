import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rink_now/scoped_models/main_model.dart';

import '../types/post.dart';

class PostEditPage extends StatefulWidget {
  final String postID;
  final MainModel model;

  PostEditPage(this.postID, this.model);

  @override
  State<StatefulWidget> createState() {
    return _PostEditPageState();
  }
}

List<String> rinks = ["Canlan", "Port Credit", "Scotia", null];

class _PostEditPageState extends State<PostEditPage> {
  DateTime newDate;
  Post currPost;
  String currCity;
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

  final Map<String, dynamic> _formData = {
    "city": null,
    "date": DateTime.now(),
    "description": null,
    "selectedRink": null,
    "price": null,
  };
  @override
  void initState() {
    currPost = widget.model.selectedPost;
    _formData["price"] = currPost.price;
    _formData["city"] = currPost.city;
    _formData["selectedRink"] = currPost.selectedRink;
    _formData["description"] = currPost.description;
    _formData["date"] = currPost.date;
    currCity = currPost.city;
    super.initState();
  }

  double _currentPrice = 100;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //METHOD need this to delete current post and return to edit page
  _showWarningDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('This action cannot be undone!'),
            actions: <Widget>[
              FlatButton(
                child: Text('DISCARD'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('CONTINUE'),
                onPressed: () {
                  widget.model.deletePost(currPost.id);
                  widget.model.fetchPosts("Date");
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        });
  }

//METHOD
  void _submitForm(Function updatePost) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    print(_formData);
    updatePost(_formData['city'], _formData['description'],
        _formData['selectedRink'], _formData["date"], _formData['price']);
    widget.model.fetchPosts("Date");
    Navigator.pop(context);
  }

//WIDGET
  Widget _buildSubmitButton() {
    return RaisedButton(
      child: Text('Save'),
      color: Theme.of(context).primaryColorDark,
      textColor: Colors.white,
      onPressed: () {
        _submitForm(widget.model.updatePost);
      },
    );
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
    return WillPopScope(onWillPop: () {
      print('Back button pressed!');
      Navigator.pop(context, false);
      //return Future.value(false);
    }, child: Container(child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
          appBar: AppBar(
            title: Text(currPost.city),
          ),
          body: Container(
            margin: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    initialValue: currPost.selectedRink,
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
                    initialValue: currPost.description,
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
                    initialValue: currPost.price.toString(),
                    decoration: new InputDecoration(labelText: "Enter Price"),
                    keyboardType: TextInputType.number,
                    onSaved: (String value) {
                      _formData["price"] = double.parse(value);
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    children: <Widget>[
                      Text("Select City: "),
                      DropdownButton<String>(
                        isExpanded: false,
                        value: currCity,
                        items: cityOptions,
                        onChanged: (String newValue) {
                          setState(() {
                            currCity = newValue;
                            _formData["city"] = newValue;
                          });
                        },
                      ),
                      //data: new ThemeData.dark()),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Select Date'),
                        /* DateFormat.MMMd().format(_formData[
                                'date']) + //how to get this to update when date is selected, might need to make a new widget
                            ", " +
                            DateFormat.jm().format(_formData['date'])) */
                        color: Theme.of(context).primaryColorDark,
                        textColor: Colors.white,
                        onPressed: () {
                          print(_formData["date"].toString() + "DATTTEEEE");
                          showDatePicker(
                                  firstDate:
                                      DateTime.now().add(Duration(days: -60)),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 60)),
                                  initialDate: DateTime.now(),
                                  context: context)
                              .then((DateTime selectedDate) {
                            showTimePicker(
                              initialTime: TimeOfDay(hour: 18, minute: 0),
                              context: context,
                            ).then((TimeOfDay selectedTime) {
                              print(selectedTime);
                              newDate = selectedDate.add(Duration(
                                  hours: selectedTime.hour,
                                  minutes: selectedTime.minute));
                              setState(() {
                                _formData["date"] = newDate;
                              });
                            });
                          });
                        },
                      ),
                      Container(),
                      Container(
                          child: Text(
                        DateFormat.MMMd().format(_formData[
                                'date']) + //how to get this to update when date is selected, might need to make a new widget
                            ", " +
                            DateFormat.jm().format(_formData['date']),
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(child: _buildSubmitButton()),
                  SizedBox(
                    height: 10.0,
                  ),
                  RaisedButton(
                    child: Text('DELETE POST'),
                    onPressed: () => _showWarningDialog(context),
                  ),
                ],
              ),
            ),
          ));
    })));
  }
}
