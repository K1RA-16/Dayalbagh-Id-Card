// import 'package:dayalbaghidregistration/data/satsangiData.dart';
// import 'package:floating_action_bubble/floating_action_bubble.dart';
// import 'package:flutter/material.dart';
// import 'package:velocity_x/velocity_x.dart';

// //List<SatsangiData> satsangiList = [];
// class ManageChildren extends StatefulWidget {
//   @override
//   State<ManageChildren> createState() => _ManageChildrenState();
// }

// class _ManageChildrenState extends State<ManageChildren> {
//   bool isLoading = false;
//   @override
//   void initState() {
//     // TODO: implement initState
//     getData();
//     super.initState();
//   }

//   Future<void> getData() async {
//     if (!isLoading) {
//       setState(() {
//         isLoading = true;
//       });
//       print(page);
//       await PostApi().getSatsangisList(widget.branchId, page, 50);
//       if (satsangiListData.satsangiList.isEmpty) {
//         childId = 1;
//       } else {
//         VxToast.show(context, msg: "no data present");
//       }
//       setState(() {
//         isLoading = false;
//         page++;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: "children registration".text.make()),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => {},
//         child: "add child".text.make(),
//       ),
//       body: ChildrenList(),
//     );
//   }
// }

// class ChildrenList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: sarsangiList.length,
//       itemBuilder: (context, index) {
//         final data = satsangiList[index];
//         //print(satsangiList[index]);
//         return ListInflate(data: data, index: index);
//       },
//     );
//   }
// }

// class ListInflate extends StatelessWidget {
//   final SatsangiData data;
//   final int index;

//   const ListInflate({Key? key, required this.data, required this.index})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return VxBox(
//       child: Row(
//         children: [
//           //CatalogImage(image: catalog.image),
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 InkWell(
//                   onTap: (() {
//                     satsangiListData.index = index;
//                     Navigator.pushNamed(context, "/menu");
//                   }),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       data.bioMetric_Status
//                           ? Icon(
//                               Icons.check,
//                               color: Colors.green,
//                             )
//                           : Icon(
//                               Icons.circle,
//                               color: Colors.orange,
//                             ),
//                       data.uid
//                           .toString()
//                           .text
//                           .black
//                           .bold
//                           .size(15)
//                           .make()
//                           .pOnly(left: 22),
//                       data.name
//                           .toString()
//                           .text
//                           .black
//                           .bold
//                           .size(15)
//                           .make()
//                           .pOnly(left: 22),
//                     ],
//                   ),
//                 )

//                 //catalog.name.text.bold.lg.make(),
//                 // TextFormField(
//                 //   decoration: InputDecoration(
//                 //       hintText: widget.data["value"].toString()),
//                 //   controller: _controller[_index],
//                 // ).pOnly(left: 22),
//               ],
//             ),
//           )
//         ],
//       ),
//     ).white.roundedSM.square(100).shadow2xl.make().py16();
//   }
// }
