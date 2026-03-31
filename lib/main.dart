import 'package:flutter/material.dart';

void main() {
  runApp(RollEasyApp());
}

class RollEasyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roll Easy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String selectedMake = "KB";
  TextEditingController controller = TextEditingController();

  // 🔥 WSP DATABASE (CORE FEATURE)
  Map<String, dynamic> wspDB = {
    "KB": {
      "1101": {
        "fault": "Speed sensor fault Axle 1",
        "action": "Check wiring, plug and replace sensor"
      },
      "1301": {
        "fault": "Dump valve short Axle 1",
        "action": "Check wiring and replace dump valve"
      },
      "7401": {
        "fault": "Safety monitor fault",
        "action": "Reload software or replace MB board"
      }
    },

    "Escorts": {
      "1.1": {
        "fault": "Speed sensor fault Axle 1",
        "action": "Check gap, sensor connection and replace JFP card"
      },
      "1.2": {
        "fault": "Exhaust valve short",
        "action": "Check coil and replace valve"
      },
      "7.0": {
        "fault": "Memory mismatch",
        "action": "Replace CPU card"
      }
    }
  };

  Map<String, dynamic>? result;

  void diagnose() {
    String code = controller.text.trim();

    if (wspDB[selectedMake] != null &&
        wspDB[selectedMake][code] != null) {
      setState(() {
        result = wspDB[selectedMake][code];
      });
    } else {
      setState(() {
        result = {"fault": "Unknown Code", "action": "Check manually"};
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("Roll Easy"),
            Text("Coaching Depot - KAKINADA",
                style: TextStyle(fontSize: 12))
          ],
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            DropdownButton(
              value: selectedMake,
              items: ["KB", "Escorts"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => selectedMake = v!),
            ),

            SizedBox(height: 15),

            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Enter Fault Code",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: diagnose,
              child: Text("Diagnose"),
            ),

            SizedBox(height: 20),

            if (result != null)
              Card(
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Fault:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(result!["fault"]),

                      SizedBox(height: 10),

                      Text("Action:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(result!["action"]),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
