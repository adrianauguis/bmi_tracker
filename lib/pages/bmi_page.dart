import 'package:final_bmi/pages/home_page.dart';
import 'package:final_bmi/pages/profile_page.dart';
import 'package:flutter/material.dart';


class BMIPage extends StatefulWidget {
  const BMIPage({Key? key}) : super(key: key);

  @override
  State<BMIPage> createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> {
  final height = TextEditingController();
  final weight = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var heightUnit;
  var weightUnit;
  var num1,num2;
  var isStatus = false;

  showResult(double height, double weight){
    print(height);
    print(weight);
    double h1 = height*height;
    double qoutient = weight/h1;
    print(qoutient);

    return Container(
      color: Colors.green,
      height: 40,
      child: Text("Your BMI: $qoutient"),
    );
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
                  if (value!.isEmpty) {
                    return "Pleas Enter Height";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 7),
              DropdownButtonFormField(
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
                  onChanged: (value) {
                      setState(() {
                        heightUnit = value;
                      });
                  }),
              const SizedBox(height: 7),
              TextFormField(
                controller: weight,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Weight",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Pleas Enter Weight";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 7),
              DropdownButtonFormField(
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
                  onChanged: (value) {
                      setState(() {
                        weightUnit = value;
                      });
                  }),
              const SizedBox(height: 7),
              ElevatedButton(
                  onPressed: ()async{
                    print(heightUnit);
                    print(weightUnit);
                    if(formKey.currentState!.validate()){
                      if(heightUnit == "ft"){
                        double hght = double.parse(height.text);
                        double product = hght*0.3048;
                        setState(() {
                          num1 = product;
                        });
                      }
                      if(weightUnit == "pound"){
                        double wght = double.parse(weight.text);
                        double product = wght*0.454;
                        setState(() {
                          num2 = product;
                        });
                      }
                      await showResult(num1, num2);
                    }else{

                    }
                  }, child: const Text("Calculate")),
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
