import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  final TextEditingController _nameController = TextEditingController();
  String petImage = 'assets/images/neutral_pet.png';

  // Function to update the pet's name
  void _updatePetName() {
    setState(() {
      petName = _nameController.text.isNotEmpty ? _nameController.text : "Your Pet";
    });
  }

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
      _updatePetImage();
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  

  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  // Update pet image based on happiness level
  void _updatePetImage() {
    if (happinessLevel > 70) {
      petImage = 'assets/images/happy_pet.png';
    } else if (happinessLevel >= 30) {
      petImage = 'assets/images/neutral_pet.png';
    } else {
      petImage = 'assets/images/unhappy_pet.png';
    }
  }

  // Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Name: $petName',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Enter Pet Name",
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: _updatePetName,
              child: Text("Update Pet Name"),
            ),
            SizedBox(height: 16.0),
            // Display the pet image
            Image.asset(
              petImage,
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            
          ],
        ),
      ),
    );
  }
}
