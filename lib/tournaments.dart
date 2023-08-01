import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'utils.dart';
import 'dates.dart';

class Tournaments extends StatefulWidget {
const Tournaments({super.key});

  @override
  State<Tournaments> createState() => _TournamentsState();
}

class _TournamentsState extends State<Tournaments> {

DatabaseReference _userRef = FirebaseDatabase.instance.ref("aa/tournaments");
DateTime _dateTime = DateTime.now();

void _showDatePicker(){
  showDatePicker(context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050)
  ).then((value) {
    setState(() {
      _dateTime = value!;
    });
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
    Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(minimumSize: Size(150, 60) ,primary: Colors.green),
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>Tournaments()));},
                icon: Icon(Icons.accessibility, size: 32,),
                label: Text(
                  'Członkowie', style: TextStyle(fontSize: 24),)),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(minimumSize: Size(150, 60) ,primary: Colors.green),
                onPressed:(){
                  },
                icon: Icon(Icons.outlined_flag, size: 32,),
                label: Text(
                  'Inne', style: TextStyle(fontSize: 24),)),
          ],
        ),

        SizedBox(height: 40),
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
                onPressed:_showDatePicker,
                icon: Icon(Icons.calendar_month, size: 32,),
                label: Text(
                  'Wybierz datę:', style: TextStyle(fontSize: 24),)),
            SizedBox(width: 20,),
            Text(DateFormat('dd.MM.yyyy').format(_dateTime).toString(),style: TextStyle(fontSize: 20),),
          ],
        ),
        SizedBox(height: 24),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(primary: Colors.red),
            onPressed:AddTournament,
            icon: Icon(Icons.add, size: 32,),
            label: Text(
              'Dodaj turniej', style: TextStyle(fontSize: 24),)),
        SizedBox(height: 24),

        SizedBox(height: 400,
          child: FirebaseAnimatedList(query: _userRef,
              itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                return Card(
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(snapshot
                            .child('date')
                            .value
                            .toString()),
                        // Text('  '),
                        // Text(snapshot
                        //     .child('surname')
                        //     .value
                        //     .toString())
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        // Text(snapshot
                        //     .child('email')
                        //     .value
                        //     .toString()),
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
                     Navigator.push(context, MaterialPageRoute(builder: (_)=>
                         Dates(idpassed: snapshot.child('dateId').value.toString(),
                         datapassed: snapshot.child('date').value.toString(),)));
                          }
                            ,icon: Icon(Icons.edit)),
                        IconButton(onPressed: () {
                          DeleteTournament(snapshot);
                          }
                            ,icon: Icon(Icons.delete)),
                      ],
                    ),
                  ),
                );
              }),
        ),

      ],
    ));
  }

Future AddTournament() async {
  final newPostKey = FirebaseDatabase.instance.ref().child('aa/tournaments').push().key;
  await _userRef.update({
    '$newPostKey/date': DateFormat('dd.MM.yyyy').format(_dateTime).toString().trim(),
    '$newPostKey/dateId': newPostKey,
      });

  Utils.showSnackBar('Nowy turniej dodany.');
}

Future DeleteTournament(snapshot) async {
  await _userRef.child(snapshot.key).remove();
  Utils.showSnackBar('Turniej został usunięty.');
}

}
