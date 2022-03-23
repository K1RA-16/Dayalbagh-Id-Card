import 'package:dayalbaghidregistration/apiAccess/postApis.dart';
import 'package:dayalbaghidregistration/data/childListData.dart';
import 'package:dayalbaghidregistration/pages/addChild.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

bool progress = false;

class ListChildren extends StatefulWidget {
  @override
  State<ListChildren> createState() => _ListChildrenState();
}

class _ListChildrenState extends State<ListChildren> {
  bool childExist = false;
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState

    checkChildExist();
    super.initState();
  }

  checkChildExist() {
    if (ChildList.childList[0].id == 0) {
      ChildList.childrenNo = 0;
      childExist = false;
      loading = false;
      setState(() {});
    } else {
      ChildList.childrenNo = ChildList.childList.length;
      setState(() {
        childExist = true;
        loading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (progress) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: "Children".text.make(),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.orange,
          onPressed: (() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ManageChildren(action: "new")));
          }),
        ),
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            20.heightBox,
            if (!childExist && !loading)
              Container(
                child: "No child exists... Please click on add"
                    .text
                    .bold
                    .size(20)
                    .make(),
              ).p(20),
            if (!childExist && loading)
              Center(child: CircularProgressIndicator()),
            if (childExist && loading) ChildListBuilder().p(20).expand(),
          ],
        ),
      ),
    );
  }
}

class ChildListBuilder extends StatefulWidget {
  @override
  State<ChildListBuilder> createState() => _ChildListBuilderState();
}

class _ChildListBuilderState extends State<ChildListBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: ChildList.childList.length,
      itemBuilder: (context, index) {
        final data = ChildList.childList[index];
        //print(satsangiList[index]);
        return ListInflate(data: data, index: index);
      },
    );
  }
}

class ListInflate extends StatefulWidget {
  final ChildListData data;
  final int index;

  const ListInflate({Key? key, required this.data, required this.index})
      : super(key: key);

  @override
  State<ListInflate> createState() => _ListInflateState();
}

class _ListInflateState extends State<ListInflate> {
  @override
  Widget build(BuildContext context) {
    return VxBox(
      child: Row(
        children: [
          //CatalogImage(image: catalog.image),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: (() {
                    ChildList.index = widget.index;
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopUp(context));
                  }),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          "UID-"
                              .text
                              .bold
                              .black
                              .size(15)
                              .make()
                              .pOnly(left: 10),
                          widget.data.uid
                              .toString()
                              .text
                              .black
                              .bold
                              .size(15)
                              .make()
                              .p(10),
                        ],
                      ),
                      Row(
                        children: [
                          "Name-"
                              .text
                              .bold
                              .black
                              .size(10)
                              .make()
                              .pOnly(left: 10),
                          widget.data.name
                              .toString()
                              .text
                              .black
                              .bold
                              .size(10)
                              .make()
                              .p(10),
                        ],
                      ),
                      Row(
                        children: [
                          "Parent Name-"
                              .text
                              .bold
                              .black
                              .size(15)
                              .make()
                              .pOnly(left: 10),
                          widget.data.father_name
                              .toString()
                              .text
                              .black
                              .bold
                              .size(15)
                              .make()
                              .p(10),
                        ],
                      ),
                    ],
                  ),
                )

                //catalog.name.text.bold.lg.make(),
                // TextFormField(
                //   decoration: InputDecoration(
                //       hintText: widget.data["value"].toString()),
                //   controller: _controller[_index],
                // ).pOnly(left: 22),
              ],
            ),
          )
        ],
      ),
    ).white.roundedSM.square(150).shadow2xl.make().py16();
  }

  Widget _buildPopUp(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (progress)
          return false;
        else
          return true;
      },
      child: AlertDialog(
        backgroundColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("Please choose the function to perform"),
        titleTextStyle: TextStyle(fontSize: 18),
        actions: <Widget>[
          Column(
            children: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    primary: Colors.orange,
                  ),
                  onPressed: () async {
                    if (!progress) {
                      progress = true;
                      setState(() {});
                      bool code = await PostApi().getChildInfo(context);
                      if (code) {
                        Navigator.pushNamed(context, "/viewChildren")
                            .then((value) => progress = false);
                      } else {
                        Navigator.pop(context);
                        setState(() {
                          progress = false;
                        });
                        VxToast.show(context, msg: "child data not available");
                      }
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'View Data',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    primary: Colors.orange,
                  ),
                  onPressed: () {
                    if (!progress)
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ManageChildren(action: "update")));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Update Biometrics',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
