import 'package:final_bmi/model/bmi_model.dart';
import 'package:final_bmi/pages/home_page.dart';
import 'package:final_bmi/pages/profile_page.dart';
import 'package:final_bmi/provider/db_provider.dart';
import 'package:flutter/material.dart';

class BMIPage extends StatefulWidget {
  const BMIPage({Key? key}) : super(key: key);

  @override
  State<BMIPage> createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> {
  DBProvider? dbProvider;
  DateTime dateNow = DateTime.now();

  var height = TextEditingController();
  var weight = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var heightUnit;
  var weightUnit;
  var heightValue, weightValue;
  var result, color, label;
  var isStatus = false;

  showResult(double height, double weight) {
    double heightSquared = height * height;
    double bmi = weight / heightSquared;

    return bmi;
  }

  @override
  void initState() {
    dbProvider = DBProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
            children: [
              TextFormField(
                controller: height,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Height",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Pleas Enter Height";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                  hint: const Text("Height Unit"),
                  decoration: const InputDecoration(
                      labelText: "Height Unit", border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(
                      value: "ft",
                      child: Text("feet"),
                    ),
                    DropdownMenuItem(
                      value: "meter",
                      child: Text("meter"),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Pleas Select Height Unit";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      heightUnit = value;
                    });
                  }),
              const SizedBox(height: 10),
              TextFormField(
                controller: weight,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Weight",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Pleas Enter Weight";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                  hint: const Text("Weight Unit"),
                  decoration: const InputDecoration(
                      labelText: "Weight Unit", border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(
                      value: "kilogram",
                      child: Text("kg"),
                    ),
                    DropdownMenuItem(
                      value: "pound",
                      child: Text("lbs"),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Pleas Select Weight Unit";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      weightUnit = value;
                    });
                  }),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        const snackBar = SnackBar(
                          content:
                              Text('Successfully added BMI result to history!'),
                        );

                        if (formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          if (heightUnit == "ft") {
                            double fromHeight = double.parse(height.text);
                            double toMeter = fromHeight * 0.3048;
                            setState(() {
                              heightValue = toMeter;
                            });
                          } else {
                            setState(() {
                              heightValue = double.parse(height.text);
                            });
                          }
                          if (weightUnit == "pound") {
                            double fromWeight = double.parse(weight.text);
                            double toKilo = fromWeight * 0.454;
                            setState(() {
                              weightValue = toKilo;
                            });
                          } else {
                            setState(() {
                              weightValue = double.parse(weight.text);
                            });
                          }

                          var receivedResult =
                              await showResult(heightValue, weightValue);
                          var formattedResult =
                              num.parse(receivedResult.toStringAsFixed(2));

                          if (formattedResult <= 18.5) {
                            setState(() {
                              result = formattedResult;
                              color = Colors.red;
                              label = "Under weight";
                            });
                          } else if (formattedResult > 18.5 &&
                              formattedResult <= 24.9) {
                            setState(() {
                              result = formattedResult;
                              color = Colors.green;
                              label = "Normal weight";
                            });
                          } else if (formattedResult > 24.9 &&
                              formattedResult <= 29.9) {
                            setState(() {
                              result = formattedResult;
                              color = Colors.orange;
                              label = "Over weight";
                            });
                          } else if (formattedResult > 29.9) {
                            setState(() {
                              result = formattedResult;
                              color = Colors.red;
                              label = "Obese";
                            });
                          }else{
                            return;
                          }

                          dbProvider!.createData(BmiModel(
                            height: double.parse(height.text),
                            weight: double.parse(weight.text),
                            result: formattedResult.toDouble(),
                            age: 21,
                            weightClass: label,
                            bmiDate: dateNow
                          ));

                          dbProvider!.insertBMI(BmiModel(
                            height: double.parse(height.text),
                            weight: double.parse(weight.text),
                            result: formattedResult.toDouble(),
                            age: 21,
                            weightClass: label,
                          ));

                        } else {
                          return;
                        }
                      },
                      child: const Text("Calculate")),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          formKey.currentState!.reset();
                          height.clear();
                          weight.clear();
                          heightUnit = null;
                          weightUnit = null;
                          heightValue = null;
                          weightValue = null;
                          result = "";
                          label = "";
                          color = Colors.grey;
                        });
                      },
                      child: const Text("Clear"))
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                    height: 40,
                    color: color ?? Colors.grey,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text("BMI Result: ${result ?? ""}",
                            style: const TextStyle(color: Colors.white)))),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                    height: 70,
                    color: color ?? Colors.grey,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text("Weight Class: ${label ?? ""}",
                            style: const TextStyle(color: Colors.white)))),
              ),
            ],
          )),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        currentIndex: 1,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                },
                icon: const Icon(Icons.home)),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.balance),
            label: 'BMI',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage(
                                selectedIndex: 2,
                              )));
                },
                icon: const Icon(Icons.account_circle)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
