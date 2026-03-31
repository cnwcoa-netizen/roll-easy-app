import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(RollEasyApp());
}

class RollEasyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

// 🚆 SPLASH SCREEN
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(Icons.train, color: Colors.white, size: 80),

            SizedBox(height: 20),

            Text("Roll Easy",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold)),

            SizedBox(height: 10),

            Text("Coaching Depot - KAKINADA",
                style: TextStyle(color: Colors.white70))
          ],
        ),
      ),
    );
  }
}

// 🚆 HOME SCREEN WITH BACKGROUND
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String selectedMake = "KB";
  TextEditingController controller = TextEditingController();

  Map<String, dynamic>? result;

  // 🔥 FULL RDSO DATABASE

  final Map<String, Map<String, Map<String, String>>> wspDB = {

    "KB": {
      "0101": {"fault": "Main Board error", "action": "Replace MB board"},
      "0202": {"fault": "Extension Board error", "action": "Replace EB board"},

      "1001": {"fault": "Dump valve timeout axle 1", "action": "Reset and test"},
      "1101": {"fault": "Speed sensor fault axle 1", "action": "Check wiring, replace sensor"},
      "1201": {"fault": "Speed signal error axle 1", "action": "Check installation"},
      "1301": {"fault": "Dump valve short axle 1", "action": "Check wiring"},
      "1401": {"fault": "Dump valve open axle 1", "action": "Check wiring"},
      "1501": {"fault": "Main board defect axle 1", "action": "Replace MB board"},

      "2001": {"fault": "Dump valve timeout axle 2", "action": "Reset and test"},
      "2101": {"fault": "Speed sensor fault axle 2", "action": "Check wiring"},
      "2201": {"fault": "Speed signal error axle 2", "action": "Check sensor"},
      "2301": {"fault": "Dump valve short axle 2", "action": "Check wiring"},
      "2401": {"fault": "Dump valve open axle 2", "action": "Check wiring"},
      "2501": {"fault": "Main board defect axle 2", "action": "Replace MB"},

      "3001": {"fault": "Dump valve timeout axle 3", "action": "Reset and test"},
      "3101": {"fault": "Speed sensor fault axle 3", "action": "Check wiring"},
      "3201": {"fault": "Speed signal error axle 3", "action": "Check sensor"},
      "3301": {"fault": "Dump valve short axle 3", "action": "Check wiring"},
      "3401": {"fault": "Dump valve open axle 3", "action": "Check wiring"},
      "3501": {"fault": "Main board defect axle 3", "action": "Replace MB"},

      "4001": {"fault": "Dump valve timeout axle 4", "action": "Reset and test"},
      "4101": {"fault": "Speed sensor fault axle 4", "action": "Check wiring"},
      "4201": {"fault": "Speed signal error axle 4", "action": "Check sensor"},
      "4301": {"fault": "Dump valve short axle 4", "action": "Check wiring"},
      "4401": {"fault": "Dump valve open axle 4", "action": "Check wiring"},
      "4501": {"fault": "Main board defect axle 4", "action": "Replace MB"},

      "7001": {"fault": "Speed signal affecting doors", "action": "Check sensors"},
      "7201": {"fault": "Single axle fault", "action": "Check individual axle"},
      "7301": {"fault": "Multiple axle faults", "action": "Check all axles"},
      "7401": {"fault": "Safety monitor fault", "action": "Reload software / replace MB"},

      "S101": {"fault": "Main board connector defect", "action": "Check connector"},
      "S202": {"fault": "Extension board connector defect", "action": "Check connector"},
      "C802": {"fault": "Group fault signal error", "action": "Replace EB board"}
    },

    "Escorts": {
      "1.0": {"fault": "Relay disconnector failure", "action": "Replace JOP"},
      "1.1": {"fault": "Speed sensor fault axle 1", "action": "Check gap (0.9–1.4 mm)"},
      "1.2": {"fault": "Exhaust valve short", "action": "Replace valve"},
      "1.3": {"fault": "Exhaust valve open", "action": "Check wiring"},
      "1.4": {"fault": "Exhaust valve switch failure", "action": "Replace JOP"},
      "1.5": {"fault": "Cut-off valve short", "action": "Replace valve"},
      "1.6": {"fault": "Cut-off valve open", "action": "Check wiring"},
      "1.7": {"fault": "Cut-off valve switch failure", "action": "Replace JOP"},

      "2.1": {"fault": "Speed sensor axle 2", "action": "Check sensor"},
      "3.1": {"fault": "Speed sensor axle 3", "action": "Check sensor"},
      "4.1": {"fault": "Speed sensor axle 4", "action": "Check sensor"},

      "7.0": {"fault": "Memory mismatch", "action": "Replace CPU"},
      "7.1": {"fault": "Kilometre counter failure", "action": "Replace CPU"},
      "7.2": {"fault": "DPB relay failure", "action": "Replace JIO"},
      "7.3": {"fault": "Magnetic brake relay failure", "action": "Replace JIO"},
      "7.4": {"fault": "Door relay failure", "action": "Replace JIO"},
      "7.5": {"fault": "User comparator failure", "action": "Replace JIO"},

      "9.0": {"fault": "Configuration mismatch", "action": "Upload config"},
      "9.5": {"fault": "Old fault stored", "action": "No action"},
      "9.9": {"fault": "System healthy", "action": "No issue"}
    },

    "Faiveley": {
      "0011": {"fault": "Speed sensor axle 1", "action": "Check sensor"},
      "0021": {"fault": "Speed sensor axle 2", "action": "Check sensor"},
      "0031": {"fault": "Speed sensor axle 3", "action": "Check sensor"},
      "0041": {"fault": "Speed sensor axle 4", "action": "Check sensor"},

      "0013": {"fault": "Dump valve short axle 1", "action": "Check wiring"},
      "0023": {"fault": "Dump valve short axle 2", "action": "Check wiring"},
      "0033": {"fault": "Dump valve short axle 3", "action": "Check wiring"},
      "0043": {"fault": "Dump valve short axle 4", "action": "Check wiring"},

      "0014": {"fault": "Dump valve open axle 1", "action": "Check wiring"},
      "0024": {"fault": "Dump valve open axle 2", "action": "Check wiring"},
      "0034": {"fault": "Dump valve open axle 3", "action": "Check wiring"},
      "0044": {"fault": "Dump valve open axle 4", "action": "Check wiring"},

      "0099": {"fault": "System healthy", "action": "No issue"}
    }
  };

    void diagnose() {
    String code = controller.text.trim();

    if (wspDB[selectedMake]?[code] != null) {
      result = wspDB[selectedMake]![code];
    } else {
      result = {"fault": "Unknown Code", "action": "Check manually"};
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
  body: Stack(
    children: [

      // Background
      Container(
       decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFF9933),
            Colors.white,
            Color(0xFF138808),
          ],
        ),
      ),
    ),


      // Overlay
      Container(color: Colors.black.withOpacity(0.6)),

      // Content
      SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [

                SizedBox(height: 50),

                Text("Roll Easy",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),

                Text("Coaching Depot - KAKINADA",
                    style: TextStyle(color: Colors.white70)),

                SizedBox(height: 20),

                DropdownButton(
                  dropdownColor: Colors.black,
                  value: selectedMake,
                  style: TextStyle(color: Colors.white),
                  items: ["KB", "Escorts", "Faiveley"]
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e,
                              style: TextStyle(color: Colors.white))))
                      .toList(),
                  onChanged: (v) => setState(() => selectedMake = v!),
                ),

                TextField(
                  controller: controller,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Enter Fault Code",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 10),

                ElevatedButton(
                  onPressed: diagnose,
                  child: Text("Diagnose"),
                ),

                SizedBox(height: 20),

                if (result != null)
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Fault: ${result!["fault"]}"),
                          SizedBox(height: 10),
                          Text("Action: ${result!["action"]}")
                          ],
                        ),
                      ),
                    ),
                 ],
               ),
             ), 
           ), 
         ),
       ],
     ),
   );
 }
}
