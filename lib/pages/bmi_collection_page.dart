// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';

class BmiCollection extends StatefulWidget {
  final dynamic height;
  final dynamic weight;
  final dynamic heightUnit;
  final dynamic weightUnit;

  const BmiCollection({
    this.height,
    this.weight,
    this.heightUnit,
    this.weightUnit,
    Key? key
  }) : super(key: key);

  @override
  State<BmiCollection> createState() => _BmiCollectionState();
}

class _BmiCollectionState extends State<BmiCollection> {

  Widget bmiPageItem(dynamic value){
    return ListTile(
      title: Text(value.toString()),
      leading: const Icon(Icons.flag_circle_outlined),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)
        ),
        title: const Text('BMI Details'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),
          bmiPageItem('Height: ${widget.height} ${widget.heightUnit}'),
          Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),
          bmiPageItem('Weight: ${widget.weight} ${widget.weightUnit}'),
          Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),
          bmiPageItem('BMI Result: '),
          Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),
        ],
      ),

    );
  }
}
























// import 'package:flutter/material.dart';
//
// class BmiCollection extends StatefulWidget {
//   final dynamic height;
//   final dynamic weight;
//   final dynamic heightUnit;
//   final dynamic weightUnit;
//
//   final dynamic data;
//
//   const BmiCollection({
//     this.height,
//     this.weight,
//     this.heightUnit,
//     this.weightUnit,
//
//     required this.data,
//     Key? key
//   }) : super(key: key);
//
//   @override
//   State<BmiCollection> createState() => _BmiCollectionState();
// }
//
// class _BmiCollectionState extends State<BmiCollection> {
//
//   Widget bmiPageItem(dynamic value){
//     return ListTile(
//       title: Text(value.toString()),
//       leading: const Icon(Icons.flag_circle_outlined),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.grey,
//         leading: IconButton(
//             onPressed: (){
//               Navigator.pop(context);
//             },
//             icon: const Icon(Icons.arrow_back)
//         ),
//         title: const Text('BMI Details'),
//       ),
//
//       body: ListView(
//         padding: const EdgeInsets.all(10.0),
//         children: [
//           Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),
//           bmiPageItem('Height: ${widget.height} ${widget.heightUnit}'),
//           Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),
//           bmiPageItem('Weight: ${widget.weight} ${widget.weightUnit}'),
//           Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),
//           bmiPageItem('BMI Result: '),
//           Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),
//
//
//           ListTile(
//             leading: const Icon(Icons.perm_identity),
//             title: Text.rich(
//               TextSpan(
//                 text: 'Full Name: ',
//                 children: <TextSpan>[
//                   TextSpan(
//                     text: '${widget.data['fullName']}',
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.indigoAccent
//                     ),
//                   )
//                 ]
//               )
//             ),
//           ),
//
//           Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),
//
//           ListTile(
//             leading: const Icon(Icons.confirmation_num_outlined),
//             title: Text.rich(
//                 TextSpan(
//                     text: 'Membership ID: ',
//                     children: <TextSpan>[
//                       TextSpan(
//                         text: '${widget.data['membershipID']}',
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.indigoAccent
//                         ),
//                       )
//                     ]
//                 )
//             ),
//           ),
//
//           Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),
//
//           ListTile(
//             leading: const Icon(Icons.onetwothree_outlined),
//             title: Text.rich(
//                 TextSpan(
//                     text: 'Age: ',
//                     children: <TextSpan>[
//                       TextSpan(
//                         text: '${widget.data['age']}',
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.indigoAccent
//                         ),
//                       )
//                     ]
//                 )
//             ),
//           ),
//
//           Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),
//
//           ListTile(
//             leading: const Icon(Icons.cake_outlined),
//             title: Text.rich(
//                 TextSpan(
//                     text: 'BirthDate: ',
//                     children: <TextSpan>[
//                       TextSpan(
//                         text: '${widget.data['birthdate']}',
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.indigoAccent
//                         ),
//                       )
//                     ]
//                 )
//             ),
//           ),
//
//           Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),
//
//           ListTile(
//             leading: const Icon(Icons.people_alt_outlined),
//             title: Text.rich(
//                 TextSpan(
//                     text: 'Gender: ',
//                     children: <TextSpan>[
//                       TextSpan(
//                         text: '${widget.data['gender']}',
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.indigoAccent
//                         ),
//                       )
//                     ]
//                 )
//             ),
//           ),
//
//           Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),
//
//           ListTile(
//             leading: const Icon(Icons.email_outlined),
//             title: Text.rich(
//                 TextSpan(
//                     text: 'Email Address: ',
//                     children: <TextSpan>[
//                       TextSpan(
//                         text: '${widget.data['email']}',
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.indigoAccent
//                         ),
//                       )
//                     ]
//                 )
//             ),
//           ),
//
//           Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),
//
//           ListTile(
//             leading: const Icon(Icons.phone),
//             title: Text.rich(
//                 TextSpan(
//                     text: 'Phone Number: ',
//                     children: <TextSpan>[
//                       TextSpan(
//                         text: '${widget.data['phoneNum']}',
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.indigoAccent
//                         ),
//                       )
//                     ]
//                 )
//             ),
//           ),
//
//           Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),
//
//           ListTile(
//             leading: const Icon(Icons.pin_drop_outlined),
//             title: Text.rich(
//                 TextSpan(
//                     text: 'Address: ',
//                     children: <TextSpan>[
//                       TextSpan(
//                         text: '${widget.data['address']}',
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.indigoAccent
//                         ),
//                       )
//                     ]
//                 )
//             ),
//           ),
//
//           Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),
//         ],
//       ),
//
//     );
//   }
// }







//NOTE: USE THIS CODE FOR THE 2ND OPTION ONLY
