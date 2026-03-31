import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() {
  runApp(RollEasyApp());
}

class RollEasyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  String lang = "en";
  TextEditingController controller = TextEditingController();

  FlutterTts tts = FlutterTts();
  SpeechToText speech = SpeechToText();

  Map<String, dynamic>? result;

  // 🔥 FULL DATABASE
  Map<String, dynamic> wspDB = {

    "KB": {
      "0101": {"fault": "Main board error", "action": "Replace MB board"},
      "0202": {"fault": "Extension board error", "action": "Replace EB board"},
      "1101": {"fault": "Speed sensor fault axle 1", "action": "Check wiring / replace sensor"},
      "1201": {"fault": "Speed signal error axle 1", "action": "Check installation"},
      "1301": {"fault": "Dump valve short axle 1", "action": "Check wiring"},
      "1401": {"fault": "Dump valve open axle 1", "action": "Check wiring"},
      "2101": {"fault": "Speed sensor axle 2", "action": "Check wiring"},
      "3101": {"fault": "Speed sensor axle 3", "action": "Check wiring"},
      "4101": {"fault": "Speed sensor axle 4", "action": "Check wiring"},
      "7001": {"fault": "Speed signal affecting doors", "action": "Check EB board"},
      "7401": {"fault": "Safety monitor fault", "action": "Reload software / replace MB"}
    },

    "Escorts": {
      "1.0": {"fault": "Relay disconnector failure", "action": "Replace JOP card"},
      "1.1": {"fault": "Speed sensor fault", "action": "Check gap / replace JFP"},
      "1.2": {"fault": "Exhaust valve short", "action": "Replace valve"},
      "1.3": {"fault": "Exhaust valve open", "action": "Check wiring"},
      "1.5": {"fault": "Cut-off valve short", "action": "Replace valve"},
      "7.0": {"fault": "Memory mismatch", "action": "Replace CPU"},
      "9.9": {"fault": "System healthy", "action": "No action"}
    },

    "Faiveley": {
      "0011": {"fault": "Speed sensor axle 1", "action": "Check sensor"},
      "0013": {"fault": "Dump valve short axle 1", "action": "Check wiring"},
      "0023": {"fault": "Dump valve short axle 2", "action": "Check wiring"},
      "0033": {"fault": "Dump valve short axle 3", "action": "Check wiring"},
      "0044": {"fault": "Dump valve open axle 4", "action": "Check wiring"},
      "0099": {"fault": "System healthy", "action": "No issue"}
    }
  };

  // 🎤 Voice Input
  void startListening() async {
    bool available = await speech.initialize();
    if (available) {
      speech.listen(onResult: (result) {
        setState(() {
          controller.text = result.recognizedWords.replaceAll(" ", "");
        });
      });
    }
  }

  // 🔊 Voice Output
  void speak(String text) async {
    await tts.setLanguage(lang == "te" ? "te-IN" : "en-US");
    await tts.speak(text);
  }

  void diagnose() {
    String code = controller.text.trim();

    if (wspDB[selectedMake] != null &&
        wspDB[selectedMake][code] != null) {
      result = wspDB[selectedMake][code];
    } else {
      result = {"fault": "Unknown Code", "action": "Check manually"};
    }

    setState(() {});
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
              items: ["KB", "Escorts", "Faiveley"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => selectedMake = v!),
            ),

            SizedBox(height: 10),

            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: lang == "te"
                    ? "లోపం కోడ్ నమోదు చేయండి"
                    : "Enter Fault Code",
                border: OutlineInputBorder(),
              ),
            ),

            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: startListening,
                ),
                IconButton(
                  icon: Icon(Icons.volume_up),
                  onPressed: () {
                    if (result != null) {
                      speak("${result!["fault"]} ${result!["action"]}");
                    }
                  },
                ),
              ],
            ),

            ElevatedButton(
              onPressed: diagnose,
              child: Text(lang == "te" ? "పరిశీలించండి" : "Diagnose"),
            ),

            Switch(
              value: lang == "te",
              onChanged: (v) {
                setState(() => lang = v ? "te" : "en");
              },
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
                      Text("Action: ${result!["action"]}"),
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
