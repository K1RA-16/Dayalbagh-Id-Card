// import 'package:flutter/material.dart';
// import 'package:velocity_x/velocity_x.dart'; 
// class ViewSatsangi extends StatelessWidget {
//  @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: "Registration".text.make(),
//         actions: [
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               elevation: 5,
//               primary: Colors.black,
//             ),
//             onPressed: () {
//               //VxToast.show(context, msg: "Details Updated");
//               print(iso);
//               print(fingerprints);
//               if (fingerprints.length == 4 &&
//                   iso.length == 4 &&
//                   faceImage != "") {
//                 updateData();
//                 VxToast.show(context, msg: "details updated");
//               } else {
//                 VxToast.show(context,
//                     msg: "error updating (try again after resetting data)");
//               }
//             },
//             child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     'Done',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15),
//                   ),
//                   5.widthBox,
//                   Icon(Icons.forward, color: Colors.green),
//                 ]),
//           ).p(5),
//         ],
//       ),
//       // floatingActionButton: FloatingActionBubble(
//       //   items: <Bubble>[
//       //     Bubble(
//       //       title: "Add Image",
//       //       iconColor: Colors.black,
//       //       bubbleColor: Colors.orange,
//       //       icon: Icons.add_photo_alternate,
//       //       titleStyle: TextStyle(fontSize: 16, color: Colors.black),
//       //       onPress: () {
//       //         initialiseCamera();
//       //       },
//       //     ),
//       //     Bubble(
//       //       title: "Add fingerprint",
//       //       iconColor: Colors.black,
//       //       bubbleColor: Colors.orange,
//       //       icon: Icons.fingerprint,
//       //       titleStyle: TextStyle(fontSize: 16, color: Colors.black),
//       //       onPress: () {
//       //         showDialog(
//       //             context: context,
//       //             builder: (BuildContext context) =>
//       //                 _buildPopupShowFingers(context));
//       //       },
//       //     ),
//       //   ],
//       //   animation: _animation,

//       //   // On pressed change animation state
//       //   onPress: () => _animationController.isCompleted
//       //       ? _animationController.reverse()
//       //       : _animationController.forward(),

//       //   // Floating Action button Icon color
//       //   iconColor: Colors.black,

//       //   // Flaoting Action button Icon
//       //   iconData: Icons.add,
//       //   backGroundColor: Colors.orange,
//       // ),
//       backgroundColor: Colors.black,
//       body: SingleChildScrollView(
//         child: Column(children: [
//           20.heightBox,
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   elevation: 5,
//                   primary: Colors.orange,
//                 ),
//                 onPressed: () {
//                   //VxToast.show(context, msg: "Details Updated");
//                   resetData();
//                 },
//                 child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text(
//                         'Reset all info',
//                         style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15),
//                       ),
//                       5.widthBox,
//                       Icon(Icons.restore, color: Colors.green),
//                     ]),
//               ).p(5),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   elevation: 5,
//                   primary: Colors.orange,
//                 ),
//                 onPressed: () {
//                   //VxToast.show(context, msg: "Details Updated");
//                   showDialog(
//                       context: context,
//                       builder: (BuildContext context) =>
//                           _buildPopupImage(context));
//                 },
//                 child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text(
//                         'Update Info',
//                         style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15),
//                       ),
//                       5.widthBox,
//                       Icon(Icons.update, color: Colors.green),
//                     ]),
//               ).p(5),
//             ],
//           ),
//           10.heightBox,
//           if (imageFile != null)
//             CircleAvatar(
//               radius: 100,
//               backgroundImage: FileImage(imageFile!),
//             ),
//           if (imageFile == null)
//             InkWell(
//               onTap: () {
//                 initialiseCamera();
//               },
//               child: CircleAvatar(
//                 radius: 100,
//                 child: Image.asset("assets/addPhoto.png"),
//               ),
//             ),
//           5.heightBox,
//           if (finger1 || finger2) "Left hand finger prints".text.make(),
//           5.heightBox,
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (finger1)
//                 Card(
//                   color: Colors.white,
//                   child: Column(
//                     children: [
//                       "left index finger".text.black.make(),
//                       5.heightBox,
//                       Image.memory(
//                         fingerData1,
//                         width: 100,
//                         height: 100,
//                         fit: BoxFit.contain,
//                       ),
//                     ],
//                   ).p(5),
//                 ),
//               if (finger3)
//                 Card(
//                   color: Colors.white,
//                   child: Column(
//                     children: [
//                       "left middle finger".text.black.make(),
//                       5.heightBox,
//                       Image.memory(
//                         fingerData3,
//                         width: 100,
//                         height: 100,
//                         fit: BoxFit.contain,
//                       ),
//                     ],
//                   ).p(5),
//                 ),
//             ],
//           ),
//           5.heightBox,
//           if (finger3 || finger4) "Right hand finger prints".text.make(),
//           5.heightBox,
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (finger2)
//                 Card(
//                   color: Colors.white,
//                   child: Column(
//                     children: [
//                       "right index finger".text.black.make(),
//                       5.heightBox,
//                       Image.memory(
//                         fingerData2,
//                         width: 100,
//                         height: 100,
//                         fit: BoxFit.contain,
//                       ),
//                     ],
//                   ).p(5),
//                 ),
//               if (finger4)
//                 Card(
//                   color: Colors.white,
//                   child: Column(
//                     children: [
//                       "Right middle finger".text.black.make(),
//                       5.heightBox,
//                       Image.memory(
//                         fingerData4,
//                         width: 100,
//                         height: 100,
//                         fit: BoxFit.contain,
//                       ),
//                     ],
//                   ).p(5),
//                 ),
//             ],
//           ),
//           if (finger5 || finger6) "Ring finger prints".text.make(),
//           5.heightBox,
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (finger5)
//                 Card(
//                   color: Colors.white,
//                   child: Column(
//                     children: [
//                       "left ring finger".text.black.make(),
//                       5.heightBox,
//                       Image.memory(
//                         fingerData5,
//                         width: 100,
//                         height: 100,
//                         fit: BoxFit.contain,
//                       ),
//                     ],
//                   ).p(5),
//                 ),
//               if (finger6)
//                 Card(
//                   color: Colors.white,
//                   child: Column(
//                     children: [
//                       "Right ring finger".text.black.make(),
//                       5.heightBox,
//                       Image.memory(
//                         fingerData6,
//                         width: 100,
//                         height: 100,
//                         fit: BoxFit.contain,
//                       ),
//                     ],
//                   ).p(5),
//                 ),
//             ],
//           ),
//           20.heightBox,
//           TextField(
//             readOnly: true,
//             controller: uidController,
//             decoration: InputDecoration(
//                 label: Text("UID"),
//                 labelStyle: TextStyle(color: Colors.white),
//                 fillColor: Colors.white,
//                 enabledBorder: OutlineInputBorder(
//                   borderSide:
//                       const BorderSide(color: Colors.blueGrey, width: 1.0),
//                   borderRadius: BorderRadius.circular(15.0),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide:
//                       const BorderSide(color: Colors.blueGrey, width: 1.0),
//                   borderRadius: BorderRadius.circular(15.0),
//                 )),
//           ),
//           20.heightBox,
//           TextField(
//             readOnly: true,
//             controller: nameController,
//             decoration: InputDecoration(
//                 label: Text("Name"),
//                 labelStyle: TextStyle(color: Colors.white),
//                 fillColor: Colors.white,
//                 enabledBorder: OutlineInputBorder(
//                   borderSide:
//                       const BorderSide(color: Colors.blueGrey, width: 1.0),
//                   borderRadius: BorderRadius.circular(15.0),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide:
//                       const BorderSide(color: Colors.blueGrey, width: 1.0),
//                   borderRadius: BorderRadius.circular(15.0),
//                 )),
//           ),
//           20.heightBox,
//           TextField(
//             readOnly: true,
//             controller: mobileController,
//             decoration: InputDecoration(
//                 label: Text("Mobile Number"),
//                 labelStyle: TextStyle(color: Colors.white),
//                 fillColor: Colors.white,
//                 enabledBorder: OutlineInputBorder(
//                   borderSide:
//                       const BorderSide(color: Colors.blueGrey, width: 1.0),
//                   borderRadius: BorderRadius.circular(15.0),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide:
//                       const BorderSide(color: Colors.blueGrey, width: 1.0),
//                   borderRadius: BorderRadius.circular(15.0),
//                 )),
//           ),
//           20.heightBox,
//           TextField(
//             readOnly: true,
//             controller: fatherNameController,
//             decoration: InputDecoration(
//                 label: Text("Father / Husband Name"),
//                 labelStyle: TextStyle(color: Colors.white),
//                 fillColor: Colors.white,
//                 enabledBorder: OutlineInputBorder(
//                   borderSide:
//                       const BorderSide(color: Colors.blueGrey, width: 1.0),
//                   borderRadius: BorderRadius.circular(15.0),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide:
//                       const BorderSide(color: Colors.blueGrey, width: 1.0),
//                   borderRadius: BorderRadius.circular(15.0),
//                 )),
//           ),
//           20.heightBox,
//           TextField(
//             readOnly: true,
//             controller: dobController,
//             decoration: InputDecoration(
//                 label: Text("Date Of Birth"),
//                 labelStyle: TextStyle(color: Colors.white),
//                 fillColor: Colors.white,
//                 enabledBorder: OutlineInputBorder(
//                   borderSide:
//                       const BorderSide(color: Colors.blueGrey, width: 1.0),
//                   borderRadius: BorderRadius.circular(15.0),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide:
//                       const BorderSide(color: Colors.blueGrey, width: 1.0),
//                   borderRadius: BorderRadius.circular(15.0),
//                 )),
//           ),
//           20.heightBox,
//           TextField(
//             readOnly: true,
//             controller: doi1Controller,
//             decoration: InputDecoration(
//                 label: Text("Date Of First Initiation"),
//                 labelStyle: TextStyle(color: Colors.white),
//                 fillColor: Colors.white,
//                 enabledBorder: OutlineInputBorder(
//                   borderSide:
//                       const BorderSide(color: Colors.blueGrey, width: 1.0),
//                   borderRadius: BorderRadius.circular(15.0),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide:
//                       const BorderSide(color: Colors.blueGrey, width: 1.0),
//                   borderRadius: BorderRadius.circular(15.0),
//                 )),
//           ),
//           20.heightBox,
//           TextField(
//             readOnly: true,
//             controller: doi2Controller,
//             decoration: InputDecoration(
//                 label: Text("Date Of First Initiation"),
//                 labelStyle: TextStyle(color: Colors.white),
//                 fillColor: Colors.white,
//                 enabledBorder: OutlineInputBorder(
//                   borderSide:
//                       const BorderSide(color: Colors.blueGrey, width: 1.0),
//                   borderRadius: BorderRadius.circular(15.0),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide:
//                       const BorderSide(color: Colors.blueGrey, width: 1.0),
//                   borderRadius: BorderRadius.circular(15.0),
//                 )),
//           ),
//           20.heightBox,
//         ]).p(10),
//       ),
//     );
//   }
// }