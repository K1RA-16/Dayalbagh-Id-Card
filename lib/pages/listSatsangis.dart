import 'package:dayalbaghidregistration/data/paginationData.dart';
import 'package:dayalbaghidregistration/data/satsangiData.dart';
import 'package:dayalbaghidregistration/pages/satsangiMenu.dart';
import 'package:dayalbaghidregistration/apiAccess/postApis.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:velocity_x/velocity_x.dart';

TextEditingController search = TextEditingController();
int page = 1;
bool finished = false;

List<SatsangiData> satsangiList = [];

class ListSatsangis extends StatefulWidget {
  final String branchId;

  ListSatsangis({
    Key? key,
    required this.branchId,
  }) : super(key: key);
  @override
  State<ListSatsangis> createState() => _ListSatsangisState();
}

class _ListSatsangisState extends State<ListSatsangis> {
  ScrollController _sc = new ScrollController();

  bool isLoading = false;
  bool progressIndicator = false;
  @override
  void initState() {
    super.initState();
    finished = false;
    progressIndicator = false;
    page = 1;
    setState(() {
      if (satsangiListData.satsangiList.isNotEmpty)
        satsangiList = satsangiListData.satsangiList;
      else
        VxToast.show(context, msg: "no data present");
    });
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        if (!finished && !isLoading) {
          setState(() {
            isLoading = true;
          });
          page++;
          _getMoreData();
        } else if (finished) {
          VxToast.show(context, msg: "all data shown");
        }
      }
    });
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  Future<void> _getMoreData() async {
    print("load");
    setState(() {
      progressIndicator = true;
    });
    print(page);
    await PostApi().getSatsangisList(widget.branchId, page, 50, context, 2);
    if (satsangiListData.newList.isNotEmpty) {
      print("loaded");
      satsangiList = satsangiListData.satsangiList;
    } else {
      finished = true;
      VxToast.show(context, msg: "no more data present");
    }
    setState(() {
      isLoading = false;
      progressIndicator = false;
    });
  }

  searchSatsangi() async {
    await PostApi().search(widget.branchId, search.text, context);
    if (satsangiListData.newList.isNotEmpty) {
      satsangiList = satsangiListData.satsangiList;
    } else {
      VxToast.show(context, msg: "no more data present");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: "Select Satsangi".text.make(),
        actions: [
          InkWell(
                  onTap: () {
                    finished = false;
                    isLoading = false;
                    setState(() {
                      progressIndicator = true;
                    });
                    page = 1;
                    satsangiListData.satsangiList.clear();
                    _getMoreData();
                  },
                  child: Icon(Icons.replay_rounded))
              .p(10),
        ],
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          20.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 150,
                child: TextField(
                  controller: search,
                  decoration: InputDecoration(
                      label: Text("Search Name"),
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.blueGrey, width: 1.0),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.blueGrey, width: 1.0),
                        borderRadius: BorderRadius.circular(15.0),
                      )),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (search.text.isNotEmpty) {
                      searchSatsangi();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 10,
                      primary: Colors.orange,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  child: "Go".text.size(20).white.make().p(13)),
            ],
          ),
          SatsangiList(
            sc: _sc,
          ).p(20).expand(),
          5.heightBox,
          if (progressIndicator) const CircularProgressIndicator(),
        ],
      ),
    );
  }
}

class SatsangiList extends StatelessWidget {
  final ScrollController sc;

  const SatsangiList({Key? key, required this.sc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: sc,
      shrinkWrap: true,
      itemCount: satsangiList.length,
      itemBuilder: (context, index) {
        final data = satsangiList[index];
        //print(satsangiList[index]);
        return ListInflate(data: data, index: index);
      },
    );
  }
}

class ListInflate extends StatefulWidget {
  final SatsangiData data;
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
                    satsangiListData.index = widget.index;
                    Navigator.pushNamed(context, "/menu");
                  }),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      widget.data.bioMetric_Status
                          ? Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.circle,
                              color: Colors.orange,
                            ),
                      Column(
                        children: [
                          10.heightBox,
                          Container(
                            width: MediaQuery.of(context).size.width - 150,
                            child: "${widget.data.uid.toString()}"
                                .text
                                .overflow(
                                  TextOverflow.ellipsis,
                                )
                                .black
                                .bold
                                .size(10)
                                .make()
                                .pOnly(left: 22),
                          ),
                          10.heightBox,
                          Container(
                            width: MediaQuery.of(context).size.width - 150,
                            child: "${widget.data.name.toString()}"
                                .text
                                .overflow(
                                  TextOverflow.ellipsis,
                                )
                                .black
                                .bold
                                .size(10)
                                .make()
                                .pOnly(left: 22),
                          ),
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
    ).white.roundedSM.square(100).shadow2xl.make().py16();
  }
}
