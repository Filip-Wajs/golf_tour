import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'utils.dart';
import 'tournaments.dart';

class CustomData extends StatefulWidget {
  const CustomData({super.key});
  @override
  State<CustomData> createState() => _CustomDataState();
}

class _CustomDataState extends State<CustomData> {

 DatabaseReference _userRef = FirebaseDatabase.instance.ref("aa/users");

  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();

 @override
 void dispose() {
   emailController.dispose();
   nameController.dispose();
   surnameController.dispose();
   super.dispose();
 }

   @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                      onPressed:(){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>Tournaments()));},
                      icon: Icon(Icons.add_reaction_sharp, size: 32,),
                      label: Text(
                        'Turnieje', style: TextStyle(fontSize: 24),)),
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
                  SizedBox(height: 4),
                  TextFormField(
                    controller: emailController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(labelText: 'E-mail'),
                    autovalidateMode: AutovalidateMode.always,
                    validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Wprowadź poprawny e-mail'
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
                              title: Row(
                                children: [
                                  Text(snapshot
                                      .child('name')
                                      .value
                                      .toString()),
                                  Text('  '),
                                  Text(snapshot
                                      .child('surname')
                                      .value
                                      .toString())
                                ],
                              ),
                              subtitle: Column(
                                children: [
                                  Text(snapshot
                                      .child('email')
                                      .value
                                      .toString()),
                                  // Text(snapshot
                                  //     .child('userId')
                                  //     .value
                                  //     .toString()),
                                ],
                              ),
                              trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(onPressed: () {
                                    ResetUser(snapshot);}
                                      ,icon: Icon(Icons.recycling_sharp)),
                                  IconButton(onPressed: () {
                                    DeleteUser(snapshot);}
                                      ,icon: Icon(Icons.delete)),
                                                                ],
                              ),
                            ),
                          );
                        }),
                  ),


                ])
        ),
      );}


  Future AddUser() async {
    final newPostKey = FirebaseDatabase.instance.ref().child('aa/users').push().key;
    await _userRef.update({
      '$newPostKey/name': nameController.text.trim(),
      '$newPostKey/surname': surnameController.text.trim(),
      '$newPostKey/email': emailController.text.trim(),
      '$newPostKey/password': '123456',
      '$newPostKey/userId': newPostKey,
    });
    nameController.clear();
    surnameController.clear();
    emailController.clear();
    Utils.showSnackBar('Nowy użytkownik dodany.');
  }

  Future DeleteUser(snapshot) async {
    await _userRef.child(snapshot.key).remove();
    Utils.showSnackBar('Użytkownik został usunięty.');
  }

 Future ResetUser(snapshot) async {
   await _userRef.child(snapshot.key).update({'password': '123456'});
   Utils.showSnackBar('Zresetowano hasło użytkownika.');
 }

}
