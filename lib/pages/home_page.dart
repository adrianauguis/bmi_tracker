import 'package:final_bmi/model/bmi_model.dart';
import 'package:final_bmi/pages/bmi_page.dart';
import 'package:final_bmi/pages/profile_page.dart';
import 'package:final_bmi/provider/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/colors.dart';
import '../model/planner_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  PlannerModel? note;
  DBProvider? dbProvider;
  late Future<List<BmiModel>> dataList;
  int _selectedIndex = 0;
  var isloading = false;
  final _notes = <PlannerModel>[];
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _calendarController = TextEditingController();
  var _selectedType = '';

  Future<DateTime> _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2025));
    if (picked != null) {
      final TimeOfDay? time =
      await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (time != null) {
        return DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        );
      }
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text("Planner",
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: const Icon(Icons.balance),
      ),
      body: _showDietaryPlan(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddNoteDialog();
          _titleController.clear();
          _descController.clear();
          _calendarController.clear();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        currentIndex: _selectedIndex,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const BMIPage()));
                },
                icon: const Icon(Icons.assessment)),
            label: 'Calculate BMI',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const ProfilePage(
                            selectedIndex: 2,
                          )));
                },
                icon: const Icon(Icons.account_circle)),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  _showDietaryPlan() {
    return Container(
      decoration: const BoxDecoration( // set the background color
      ),
      child: GridView.builder(
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          return _buildNoteCard(_notes[index], index);
        },
      ),
    );
  }

  Widget _buildNoteCard(PlannerModel note, int index) {
    return Card(
      color: noteColor[(index % noteColor.length).floor()],
      elevation: 15,
      child: InkWell(
        onTap: () => _showEditNoteDialog(note),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                note.type!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              Text(
                note.title!,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                note.description!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              Text(
                note.calendarOutput.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showAddNoteDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add your dietary plan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(children: [
                  DropdownButtonFormField(
                      hint: const Text('Type (Meal/Exercise)'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Meal Plan',
                          child: Text('Meal Plan'),
                        ),
                        DropdownMenuItem(
                          value: 'Exercise Plan',
                          child: Text('Exercise Plan'),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Pleas Select a Type";
                        }
                        return null;
                      },
                      onChanged: (gender) {
                        _selectedType = gender.toString();
                      }),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      return (value == '') ? 'Please enter a title' : null;
                    },
                  ),
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      return (value == '')
                          ? 'Please enter a description'
                          : null;
                    },
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: _calendarController,
                    decoration: InputDecoration(
                      labelText: 'Calendar',
                      prefixIcon: InkWell(
                        child: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final picked = await _selectDate();
                          String formattedDate = DateFormat('E, d MMM yyyy, h:mm a').format(picked);
                          _calendarController.text = formattedDate;
                        },
                      ),
                    ),
                    validator: (value) {
                      return (value == '')
                          ? 'Please enter a date and time'
                          : null;
                    },
                  ),
                ]),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                }),
            ElevatedButton(
                child: const Text("Add"),
                onPressed: () {
                  {
                    if (_formKey.currentState!.validate()) {
                      var note = PlannerModel(type: _selectedType.toString(),
                          title: _titleController.text,
                          description: _descController.text,
                          calendarOutput: _calendarController.text);
                      setState(() {
                        _notes.add(note);
                      });
                      Navigator.pop(context);
                    }
                  }
                }),
          ],
        );
      },
    );
  }

  void _showEditNoteDialog(PlannerModel note) {
    _titleController.text = note.title!;
    _descController.text = note.description!;
    _calendarController.text = note.calendarOutput!;
    _selectedType = note.type!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit your dietary plan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(children: [
                  DropdownButtonFormField(
                      value: _selectedType,
                      items: const [
                        DropdownMenuItem(
                          value: 'Meal Plan',
                          child: Text('Meal Plan'),
                        ),
                        DropdownMenuItem(
                          value: 'Exercise Plan',
                          child: Text('Exercise Plan'),
                        ),
                      ],
                      onChanged: (gender) {
                        _selectedType = gender.toString();
                      }),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      return (value == '') ? 'Please enter a title' : null;
                    },
                  ),
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      return (value == '')
                          ? 'Please enter a description'
                          : null;
                    },
                  ),
                  TextFormField(
                    controller: _calendarController,
                    decoration: InputDecoration(
                      labelText: 'Calendar',
                      prefixIcon: InkWell(
                        child: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final picked = await _selectDate();
                          setState(() {
                            _calendarController.text = picked.toString();
                          });
                        },
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                }),
            ElevatedButton(
                child: const Text("Save"),
                onPressed: () {
                  {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        note.title = _titleController.text;
                        note.description = _descController.text;
                        note.calendarOutput = _calendarController.text;
                        note.type = _selectedType.toString();
                        _titleController.clear();
                        _descController.clear();
                        _calendarController.clear();
                      });
                      Navigator.pop(context);
                    }
                  }
                }),
          ],
        );
      },
    );
  }
}
