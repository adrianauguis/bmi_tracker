import 'package:flutter/material.dart';

import '../model/bmi_model.dart';
import '../model/storage_service.dart';
import 'home_page.dart';
import 'profile_page.dart';

class BMIPage extends StatefulWidget {
  const BMIPage({Key? key}) : super(key: key);

  @override
  State<BMIPage> createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> {
  Storage? storage;
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
    storage = Storage();
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
                    return "Please Enter Weight";
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
                              label = "Obese weight";
                            });
                          }else{
                            return;
                          }

                          storage!.createBmiData(BmiModel(
                            height: double.parse(height.text),
                            weight: double.parse(weight.text),
                            bmiResult: formattedResult.toDouble(),
                            weightClass: label,
                            bmiDate: dateNow
                          ));

                          // dbProvider!.insertBMI(BmiModel(
                          //   height: double.parse(height.text),
                          //   weight: double.parse(weight.text),
                          //   result: formattedResult.toDouble(),
                          //   age: 21,
                          //   weightClass: label,
                          // ));

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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF00FFDE),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  icon: const Icon(Icons.home)),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const BMIPage()));
                  },
                  icon: const Icon(Icons.scale_outlined)),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const ProfilePage()));
                  },
                  icon: const Icon(Icons.person)),

            ],
          ),
        ),
      ),
    );
  }
}
