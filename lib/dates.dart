import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'utils.dart';
import 'tournaments.dart';

class Dates extends StatefulWidget {
  final String idpassed;
  final String datapassed;
    const Dates({Key? key, required this.datapassed, required this.idpassed}) : super(key: key);
  @override
  State<Dates> createState() => _DatesState(datapassed: this.datapassed, idpassed: this.idpassed);
}

class _DatesState extends State<Dates> {

  String datapassed;
  String idpassed;
  _DatesState({required this.datapassed, required this.idpassed});
  DatabaseReference _userRef = FirebaseDatabase.instance.ref("aa/users");
  late DatabaseReference _tourRef = FirebaseDatabase.instance.ref("aa/tournaments/$idpassed");
  late DatabaseReference _flightRef = FirebaseDatabase.instance.ref("aa/tournaments/$idpassed/$_currentFlight");

  String flight='';
  num hole=0;
  String playerName='';
  String playerSurname='';
  String playerId='';
  String markerName='';
  String markerSurname='';
  String markerId='';

  List<String> flights = [];
  List<String> flightsId = [];
  String _currentFlight='null';
  List<String> holes = [];
  List<String> holesId = [];
  String _currentHole='null';

  final holenameController = TextEditingController();
  // String holeName = '';
  String holeNumb = '';
  final metersController = TextEditingController();
  // String meters = '';
  final holeparController = TextEditingController();
  // String holepar = '';
  final scoreController = TextEditingController();
  // String score = '';

  @override
  void initState(){
    ShowFlight();
      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        onPressed:(){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>Tournaments()));},
                        icon: Icon(Icons.wine_bar, size: 32,),
                        label: Text(
                          'Turnieje', style: TextStyle(fontSize: 24),)),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        onPressed:(){
                          ShowFlight();},
                        icon: Icon(Icons.accessibility, size: 32,),
                        label: Text(
                          'Członkowie', style: TextStyle(fontSize: 24),)),
                  ],
                ),

                SizedBox(height: 24),

                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text('Dołki dla Flighta $flight:',style: TextStyle(fontSize: 24),),
                        SizedBox(height: 4),
                        SizedBox(width: 200,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: holes.length,
                            itemBuilder: (context, index) => Card(
                              // elevation: 6,
                              //margin: const EdgeInsets.all(10),
                              child: ListTile(
                                title: Text(holes[index]),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(onPressed: () {
                                      setState(() {
                                        _currentHole=holesId[index];
                                        hole=index+1;
                                      });
                                      EditHole();
                                    }
                                        ,icon: Icon(Icons.edit)),
                                   if (index+1==holes.length)
                                    IconButton(onPressed: () {
                                      setState(() {
                                        _currentHole=holesId[index];
                                      });
                                      DeleteHole();
                                    }
                                        ,icon: Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                        children: [
                          Text('Dołek nr: $holeNumb', style: TextStyle(fontSize: 24),),
                          SizedBox(height: 4),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Nazwa dołka:'),
                              SizedBox(width: 20,),
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  controller: holenameController,
                                  cursorColor: Colors.black,
                                  textInputAction: TextInputAction.next,
                                  //initialValue: 'holeName',
                                ),

                              ),
                            ],
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Metry:'),
                              SizedBox(width: 20,),
                              SizedBox(
                                width: 200,
                                child: TextFormField(
                                  controller: metersController,
                                  cursorColor: Colors.black,
                                  textInputAction: TextInputAction.next,
                                  //initialValue: '$meters',
                                ),

                              ),
                            ],
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Par:'),
                              SizedBox(width: 20,),
                              SizedBox(
                                width: 200,
                                child: TextFormField(
                                  controller: holeparController,
                                  cursorColor: Colors.black,
                                  textInputAction: TextInputAction.next,
                                  // initialValue: holepar,
                                ),

                              ),
                            ],
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Wynik:'),
                              SizedBox(width: 20,),
                              SizedBox(
                                width: 200,
                                child: TextFormField(
                                  controller: scoreController,
                                  cursorColor: Colors.black,
                                  textInputAction: TextInputAction.next,
                                  //initialValue: score,
                                ),

                              ),
                            ],
                          ),
                         ]),
                    Column(
                      children: [
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                            onPressed: AddHole,
                            icon: Icon(Icons.add, size: 32,),
                            label: Text(
                              'Dodaj dołek', style: TextStyle(fontSize: 24),)),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(primary: Colors.red),
                            onPressed:(){
                              UpdateHole();},
                            icon: Icon(Icons.save, size: 32,),
                            label: Text(
                              'Aktualizuj dołek', style: TextStyle(fontSize: 24),)),
                      ],
                    ),
                  ],
                ),
SizedBox(height: 50,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text('Flighty turnieju: $datapassed:',style: TextStyle(fontSize: 24),),
                        SizedBox(height: 4),
                        SizedBox(height: 600, width: 250,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: flights.length,
                            itemBuilder: (context, index) => Card(
                              // elevation: 6,
                              // margin: const EdgeInsets.all(10),
                              child: ListTile(
                                title: Text(flights[index]),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(onPressed: () {
                                      setState(() {
                                        _currentFlight=flightsId[index];
                                        flight=(index+1).toString();
                                      });
                                      EditFlight();
                                      ShowHole();
                                    }
                                        ,icon: Icon(Icons.edit)),
                                    if (index+1==flights.length)
                                    IconButton(onPressed: () {
                                      setState(() {
                                       _currentFlight=flightsId[index];
                                      });
                                      DeleteFlight();
                                    }
                                        ,icon: Icon(Icons.delete)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(width: 50,),
                    SizedBox(height: 600,
                      child: Column(
                        children: [
                          Text('Flight: $flight',style: TextStyle(fontSize: 24),),
                          SizedBox(height: 4),
                          Text('Player: $playerName  $playerSurname'),
                          SizedBox(height: 4),
                          Text('Marker: $markerName  $markerSurname'),
                          SizedBox(height: 20),
                          ElevatedButton.icon(
                              onPressed: AddFlight,
                              icon: Icon(Icons.add, size: 32,),
                              label: Text(
                                'Dodaj flight', style: TextStyle(fontSize: 24),)),
                          SizedBox(height: 20,),
                          ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(primary: Colors.red),
                              onPressed:(){
                                UpdateFlight();},
                              icon: Icon(Icons.save, size: 32,),
                              label: Text(
                                'Aktualizuj Flight', style: TextStyle(fontSize: 24),)),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text('Wybierz playera i markera z listy:',style: TextStyle(fontSize: 24),),
                        SizedBox(height: 4),
                        SizedBox(height: 600, width: 500,
                          child: FirebaseAnimatedList(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              query: _userRef,
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
                                        Text('Player: '),
                                        IconButton(onPressed: () {
                                          setState(() {
                                            playerName=snapshot.child('name').value.toString();
                                            playerSurname=snapshot.child('surname').value.toString();
                                            playerId=snapshot.child('userId').value.toString();
                                          });

                                        }
                                            ,icon: Icon(Icons.play_arrow)),
                                        Text('Marker: '),
                                        IconButton(onPressed: () {
                                          setState(() {
                                            markerName=snapshot.child('name').value.toString();
                                            markerSurname=snapshot.child('surname').value.toString();
                                            markerId=snapshot.child('userId').value.toString();
                                          });
                                        }
                                            ,icon: Icon(Icons.flag)),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                                     ],
                ),

                ])
      ),
    );}

  Future ShowFlight() async {
    final snapshot = await _tourRef.get();
    final data = snapshot.value as Map?;
    int _counter = 1;
    setState(() {
      flights.clear();
      flightsId.clear();
    });

    for (var entry in data!.entries) {
      String substring = "flight: $_counter";
      if (entry.value.toString().contains(substring)) {
       // print(entry.value);
        setState(() {
          flights.add("Flight: $_counter");
          flightsId.add(entry.key);
        });
        _counter++;
            };
      //print(entry.value);
     // print("*");
     }
    //print(data);
    //print(flightsId);

  }

    Future AddFlight() async {
    var l = flights.length+1;
     final newPostKey = FirebaseDatabase.instance.ref().child('aa/tournaments/$idpassed').push().key;
     await _tourRef.update({
       '$newPostKey/flight': '$l',
             });

     ShowFlight();
     Utils.showSnackBar('Dodano Flight.');
   }

  Future EditFlight() async {
    DatabaseReference _flightRef = FirebaseDatabase.instance.ref("aa/tournaments/$idpassed/$_currentFlight");
    final snapshot = await _flightRef.get();
   setState(() {
     holenameController.text='';
     holeparController.text='';
     metersController.text='';
     scoreController.text='';
     holeNumb='';
     snapshot.child('playern').value == null? playerName='':
      playerName = snapshot.child('playern').value.toString();
     snapshot.child('players').value == null? playerSurname='':
      playerSurname = snapshot.child('players').value.toString();
     snapshot.child('playerId').value == null? playerId='':
      playerId = snapshot.child('playerId').value.toString();
     snapshot.child('markern').value == null? markerName='':
      markerName = snapshot.child('markern').value.toString();
     snapshot.child('markers').value == null? markerSurname='':
      markerSurname = snapshot.child('markers').value.toString();
     snapshot.child('markerId').value == null? markerId='':
      markerId = snapshot.child('markerId').value.toString();
    });
      }

  Future DeleteFlight() async {
DatabaseReference _flightrRef = FirebaseDatabase.instance.ref("aa/tournaments/$idpassed/$_currentFlight");
    await _flightrRef.remove();
      ShowFlight();
    Utils.showSnackBar('Flight został usunięty.');
  }

  Future UpdateFlight() async {
DatabaseReference _flightrRef = FirebaseDatabase.instance.ref("aa/tournaments/$idpassed/$_currentFlight");
    await _flightrRef.update({
      'playern': '$playerName',
      'players': '$playerSurname',
      'playerId': '$playerId',
      'markern': '$markerName',
      'markers': '$markerSurname',
      'markerId': '$markerId',
    });
    Utils.showSnackBar('Zaktualizowano Flight.');
  }

  Future AddHole() async {
    late DatabaseReference _flightRef = FirebaseDatabase.instance.ref("aa/tournaments/$idpassed/$_currentFlight");
    var l = holes.length+1;
    final newPostKey = FirebaseDatabase.instance.ref().child('aa/tournaments/$idpassed/$_currentFlight').push().key;
    await _flightRef.update({
      '$newPostKey/hole': '$l',
    });

    ShowHole();
    Utils.showSnackBar('Dodano dołek.');
  }

  Future DeleteHole() async {
    DatabaseReference _holeRef = FirebaseDatabase.instance.ref("aa/tournaments/$idpassed/$_currentFlight/$_currentHole");
    await _holeRef.remove();
    ShowHole();
    Utils.showSnackBar('Dołek został usunięty.');
  }

  Future ShowHole() async {
    DatabaseReference _flightRef = FirebaseDatabase.instance.ref("aa/tournaments/$idpassed/$_currentFlight");
    final snapshot = await _flightRef.get();
    final data = snapshot.value as Map?;
    int _counter = 1;
    setState(() {
      holes.clear();
      holesId.clear();
    });

    for (var entry in data!.entries) {
      String substring = "hole: $_counter";
      if (entry.value.toString().contains(substring)) {
        setState(() {
          holes.add("Dołek: $_counter");
          holesId.add(entry.key);
        });
        _counter++;
      };
     }
   }

  Future EditHole() async {
    DatabaseReference _holeRef = FirebaseDatabase.instance.ref("aa/tournaments/$idpassed/$_currentFlight/$_currentHole");
    final snapshot = await _holeRef.get();
    setState(() {
      snapshot.child('holename').value == null? holenameController.text = '':
      holenameController.text = snapshot.child('holename').value.toString();
      holeNumb = snapshot.child('hole').value.toString();
      snapshot.child('meters').value == null? metersController.text = '':
      metersController.text = snapshot.child('meters').value.toString();
      snapshot.child('holepar').value == null? holeparController.text = '':
      holeparController.text = snapshot.child('holepar').value.toString();
      snapshot.child('score').value == null? scoreController.text ='':
      scoreController.text = snapshot.child('score').value.toString();
      // markerId = snapshot.child('markerId').value.toString();
    });
  }

  Future UpdateHole() async {
    DatabaseReference _holeRef = FirebaseDatabase.instance.ref("aa/tournaments/$idpassed/$_currentFlight/$_currentHole");
    await _holeRef.update({
      'meters': metersController.text.trim(),
      'holepar': holeparController.text.trim(),
      'score': scoreController.text.trim(),
      'holename': holenameController.text.trim(),
      // 'markers': '$markerSurname',
      // 'markerId': '$markerId',
    });
    Utils.showSnackBar('Zaktualizowano dołek.');
  }

}
