import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:rink_now/scoped_models/main_model.dart';

import 'package:rink_now/widgets/hamburger_menu.dart';

import '../Other/post_displayer.dart';

//import '../posts.dart';

//this is the main page to scroll through posts
class PostListPage extends StatefulWidget {
  String newValue;

  final MainModel model;
  PostListPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return PostListPageState();
  }
}

class PostListPageState extends State<PostListPage> {
  String _selectedType = "Date";

//CHANGE THESE
  List _selectedCities;
  String _myActivitiesResult;

  TextEditingController controller = new TextEditingController();
  String searchFilter;
  String optionFilter = "None";
  String sortBy = "Date";
  @override
  void initState() {
    _selectedCities = [];
    controller.addListener(() {
      setState(() {
        searchFilter = controller.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget dropDownSort() {
    IconData _selectedIcon;
    final Map<String, IconData> _data = Map.fromIterables(
        ['Date', 'Price', 'City'],
        [Icons.date_range, Icons.monetization_on, Icons.location_city]);
    List<DropdownMenuItem<String>> itms = _data.keys.map((String val) {
      return DropdownMenuItem<String>(
        value: val,
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(_data[val]),
            ),
            Text(val),
          ],
        ),
      );
    }).toList();

    return Theme(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                value: _selectedType,
                items: itms,
                hint: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Icon(_selectedIcon ?? _data.values.toList()[0]),
                    ),
                    Text(_selectedType ?? _data.keys.toList()[0]),
                  ],
                ),
                onChanged: (String val) {
                  setState(() {
                    _selectedType = val;
                    _selectedIcon = _data[val];
                    sortBy = val;
                  });
                }),
          ),
        ),
        data: new ThemeData.dark());
  }

  Widget dropDownCitySelect() {
    return MultiSelectFormField(
      autovalidate: false,
      titleText: 'Filter By City',
      dataSource: [
        {
          "display": "Toronto",
          "value": "Toronto",
        },
        {
          "display": "Oakville",
          "value": "Oakville",
        },
        {
          "display": "Etobicoke",
          "value": "Etobicoke",
        },
        {
          "display": "Vaughn",
          "value": "Vaughn",
        },
        {
          "display": "Mississauga",
          "value": "Mississauga",
        },
        {
          "display": "Oshawa",
          "value": "Oshawa",
        },
        {
          "display": "North York",
          "value": "North York",
        },
      ],
      textField: 'display',
      valueField: 'value',
      okButtonLabel: 'OK',
      cancelButtonLabel: 'CANCEL',
      // required: true,
      hintText: '',
      value: _selectedCities,
      onSaved: (selects) {
        print(selects);
        if (selects == null) return;
        setState(() {
          _selectedCities = selects;
        });
      },
    );
  }

  Widget refreshButton() {
    return IconButton(
      icon: Icon(
        Icons.refresh,
        color: Colors.white,
      ),
      onPressed: () {
        widget.model.fetchPosts(sortBy);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.model.fetchPosts(sortBy);
    return Scaffold(
      drawer: HamburgerMenu("anything here rn"),
      appBar: AppBar(
          //leading: refreshButton(),
          actions: <Widget>[refreshButton(), dropDownSort()],
          title: Row(children: <Widget>[
            Text('Postings'),
          ])),
      body: Column(children: [
        Container(
            child: TextField(
          /* style:
                  TextStyle(fontSize: 20.0, height: 0.1, color: Colors.black), */
          decoration: InputDecoration(
            labelText: "",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
            ),
          ),
          controller: controller,
        )),
        dropDownCitySelect(),
        Expanded(child: PostDisplayer(searchFilter, _selectedCities))
      ]),
    );
  }
}
