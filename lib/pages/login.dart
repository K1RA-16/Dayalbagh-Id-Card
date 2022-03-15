import 'package:dayalbaghidregistration/apiAccess/postApis.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginPage extends StatelessWidget {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: "Dayalbagh Id Manager".text.make()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            50.heightBox,
            "Login".text.size(20).bold.make(),
            50.heightBox,
            TextField(
              controller: username,
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
            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                  label: Text("Password"),
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
            ).pOnly(left: 20, right: 20),
            50.heightBox,
            InkWell(
              onTap: () {
                PostApi().login(username.text, password.text, context);
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
    );
  }
}
