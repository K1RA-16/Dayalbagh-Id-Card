import 'package:dayalbaghidregistration/apiAccess/postApis.dart';
import 'package:dayalbaghidregistration/data/downloadLink.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:url_launcher/link.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();

  TextEditingController password = TextEditingController();
  bool obscure = true;
  bool loginInitiated = false;
  @override
  void initState() {
    loginInitiated = false;
  }

  login() async {
    setState(() {
      loginInitiated = true;
    });
    int code = await PostApi().login(username.text, password.text, context);
    print(code);
//login check double
    setState(() {
      loginInitiated = false;
    });
    if (code == 400) {
      showDialog(
          context: context,
          builder: (BuildContext context) => _buildPopUp(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              20.heightBox,
              Image.asset(
                "assets/splashScreen.png",
                width: 100,
                height: 100,
              ),
              20.heightBox,
              "Login".text.size(20).bold.make(),
              50.heightBox,
              TextField(
                controller: username,
                maxLength: 20,
                inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                decoration: InputDecoration(
                    label: Text("User Id"),
                    labelStyle: TextStyle(color: Colors.white),
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blueGrey, width: 1.0),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blueGrey, width: 1.0),
                      borderRadius: BorderRadius.circular(15.0),
                    )),
              ).p(20),
              20.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: TextField(
                      inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                      controller: password,
                      obscureText: obscure,
                      maxLength: 20,
                      decoration: InputDecoration(
                          label: Text("Password"),
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
                    ).pOnly(left: 20, right: 10).expand(),
                  ),
                  Center(
                      child: InkWell(
                    onTap: () {
                      obscure = !obscure;
                      setState(() {});
                    },
                    child:
                        Icon(Icons.remove_red_eye).pOnly(bottom: 20, right: 10),
                  )),
                ],
              ),
              50.heightBox,
              InkWell(
                onTap: () {
                  if (!loginInitiated) login();
                },
                child: Icon(
                  Icons.arrow_circle_right,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopUp(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        backgroundColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("Please download new version"),
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
                    setState(() {});
                    if (!await launch(DownloadLink.link))
                      throw 'Could not launch ${DownloadLink.link}';
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Download',
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
