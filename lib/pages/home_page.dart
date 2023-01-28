import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_bmi/model/storage_service.dart';
import 'package:final_bmi/pages/bmi_page.dart';
import 'package:final_bmi/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/colors.dart';
import '../model/planner_model.dart';

class HomePage extends StatefulWidget {
  bool? isUpdated;
  HomePage({Key? key, this.isUpdated}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  Storage? storage;
  int _selectedIndex = 0;
  var isloading = false;
  final _notes = <PlannerModel>[];
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _calendarController = TextEditingController();
  var _selectedType = '';
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool isLoading = false;
  bool? created;

  Future _selectDate(DateTime date) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
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
    return picked;
  }


  @override
  void initState() {
    storage = Storage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.isUpdated != null){
      isLoading = widget.isUpdated!;
    }else{
      isLoading = created ?? true;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text("Planner",
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: const Icon(Icons.balance),
      ),
      body: isLoading
          ? _showDietaryPlan()
          : const Center(child: Text("No plans")),
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
    final CollectionReference planner =
    FirebaseFirestore.instance.collection('users').doc(_firebaseAuth.currentUser!.uid).collection('plannerHistory');
    return StreamBuilder(
        stream: planner.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
          if(streamSnapshot.hasData){
            return GridView.builder(
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot =
                streamSnapshot.data!.docs[index];
                Timestamp t = documentSnapshot['calendarOutput'];
                DateTime date = t.toDate();
                String formattedDate = DateFormat('E, d MMM yyyy, h:mm a').format(date);
                return Card(
                  color: noteColor[(index % noteColor.length).floor()],
                  elevation: 15,
                  child: InkWell(
                    onTap: () => _showEditNoteDialog(documentSnapshot, documentSnapshot.id),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            documentSnapshot['type'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            documentSnapshot['title'],
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            documentSnapshot['description'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            formattedDate,
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
              },
            );
          }{
            return const CircularProgressIndicator();
          }

        });
    // return Container(
    //   decoration: const BoxDecoration( // set the background color
    //   ),
    //   child: GridView.builder(
    //     gridDelegate:
    //     const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    //     itemCount: _notes.length,
    //     itemBuilder: (context, index) {
    //       return _buildNoteCard(_notes[index], index);
    //     },
    //   ),
    // );
  }

  //buildNoteCard
  // Widget _buildNoteCard(PlannerModel note, int index) {
  //   String formattedDate = DateFormat('E, d MMM yyyy, h:mm a').format(note.calendarOutput!);
  //   return Card(
  //     color: noteColor[(index % noteColor.length).floor()],
  //     elevation: 15,
  //     child: InkWell(
  //       onTap: () => _showEditNoteDialog(note),
  //       child: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: <Widget>[
  //             Text(
  //               note.type!,
  //               style: const TextStyle(
  //                 fontSize: 14,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             Text(
  //               note.title!,
  //               style: const TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.black),
  //             ),
  //             const SizedBox(
  //               height: 8,
  //             ),
  //             Text(
  //               note.description!,
  //               style: const TextStyle(
  //                 fontSize: 14,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             Text(
  //               formattedDate,
  //               style: const TextStyle(
  //                 fontSize: 14,
  //                 color: Colors.black,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  _showAddNoteDialog() {
    DateTime? addDate;
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
                        onTap: ()async{
                          DateTime d = DateTime.now();
                          addDate = await _selectDate(d);
                          String formattedDate = DateFormat('E, d MMM yyyy, h:mm a').format(addDate!);
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
                      setState(() {
                        isLoading = true;
                      });
                      storage!.addUserPlannerToDB(PlannerModel(
                          title: _titleController.text,
                          type: _selectedType.toString(),
                          description: _descController.text,
                          calendarOutput: addDate
                      ));

                      var note = PlannerModel(type: _selectedType.toString(),
                          title: _titleController.text,
                          description: _descController.text,
                          calendarOutput: addDate);
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

  void _showEditNoteDialog(DocumentSnapshot documentSnapshot, String docID) {
    bool isUpdated = false;
    DateTime? picked;
    final CollectionReference planner =
    FirebaseFirestore.instance.collection('users').doc(_firebaseAuth.currentUser!.uid).collection('plannerHistory');
    _titleController.text = documentSnapshot['title'];
    _descController.text = documentSnapshot['description']!;
    Timestamp t = documentSnapshot['calendarOutput'];
    DateTime date = t.toDate();
    String formattedDate = DateFormat('E, d MMM yyyy, h:mm a').format(date);
    _calendarController.text = formattedDate;
    _selectedType = documentSnapshot['type'];

    Future<void> deleteData(String plannerId) async {
      await planner.doc(plannerId).delete();
    }

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
                    readOnly: true,
                    controller: _calendarController,
                    decoration: InputDecoration(
                      labelText: 'Calendar',
                      prefixIcon: InkWell(
                        child: const Icon(Icons.calendar_today),
                        onTap: () {
                          setState(() async{
                            picked = await _selectDate(documentSnapshot['calendarOutput'].toDate());
                            isUpdated = true;
                            String formattedDate = DateFormat('E, d MMM yyyy, h:mm a').format(picked!);
                            _calendarController.text = formattedDate;
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
                      var date = isUpdated ? picked : documentSnapshot['calendarOutput'];
                      planner.doc(docID).update({
                        "title": _titleController.text,
                        "type": _selectedType.toString(),
                        "description": _descController.text,
                        "calendarOutput": date
                      });

                      // setState(() {
                      //   note.title = _titleController.text;
                      //   note.description = _descController.text;
                      //   note.calendarOutput = picked;
                      //   note.type = _selectedType.toString();
                      //   _titleController.clear();
                      //   _descController.clear();
                      //   _calendarController.clear();
                      // });
                      Navigator.pop(context);
                    }
                  }
                }),
            ElevatedButton(
                onPressed: (){
                  deleteData(documentSnapshot.id);
                  Navigator.pop(context);
                },
                child: const Text("Delete"))
          ],
        );
      },
    );
  }
}
