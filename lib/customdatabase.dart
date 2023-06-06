import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class CustomData extends StatefulWidget {
  @override
  State<CustomData> createState() => _CustomDataState();
}

class _CustomDataState extends State<CustomData> {

 DatabaseReference _userRef = FirebaseDatabase.instance.ref("aa/users");

  final nameController = TextEditingController();
  final surnameController = TextEditingController();

   @override
  Widget build(BuildContext context) =>
      SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(height: 40),
                TextFormField(
                  controller: nameController,
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Imię'),
                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) =>
                  value != null && value.length < 2
                      ? 'Wprowadź poprawne imię'
                      : null,
                ),
                SizedBox(height: 4),
                TextFormField(
                  controller: surnameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Nazwisko'),
                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) =>
                  value != null && value.length < 2
                      ? 'Wpisz poprawne nazwisko'
                      : null,
                ),

                SizedBox(height: 20),

                ElevatedButton.icon(onPressed: AddUser,
                    icon: Icon(Icons.add_reaction_sharp, size: 32,),
                    label: Text(
                      'Dodaj użytkowika', style: TextStyle(fontSize: 24),)),

                SizedBox(height: 24),

                SizedBox(height: 400,
                  child: FirebaseAnimatedList(query: _userRef,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                        return Card(
                          child: ListTile(
                            title: Text(snapshot
                                .child('name')
                                .value
                                .toString()),
                            subtitle: Column(
                              children: [
                                Text(snapshot
                                    .child('surname')
                                    .value
                                    .toString()),
                                Text(snapshot
                                    .child('userId')
                                    .value
                                    .toString()),
                              ],
                            ),
                            trailing: IconButton(onPressed: () {
                              DeleteUser(snapshot);}
                                ,icon: Icon(Icons.delete)),
                          ),
                        );
                      }),
                ),


              ])
      );



  Future AddUser() async {
    // DatabaseReference ref = FirebaseDatabase.instance.ref("aa/users");
    final newPostKey = FirebaseDatabase.instance.ref().child('aa/users').push().key;
    await _userRef.update({
      '$newPostKey/name': nameController.text.trim(),
      '$newPostKey/surname': surnameController.text.trim(),
      '$newPostKey/userId': newPostKey,
    });
    nameController.clear();
    surnameController.clear();
  }

  Future DeleteUser(snapshot) async {
    // DatabaseReference ref = FirebaseDatabase.instance.ref("aa/users");

    await _userRef.child(snapshot.key).remove();

  }

}
