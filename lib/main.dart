import 'dart:async';
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
  String moodText = "Neutral 😊";
  Color petColor = Colors.yellow;

  Timer? _hungerTimer;
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    super.dispose();
  }

  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      _increaseHunger();
    });
  }

  void _updatePetName() {
    setState(() {
      petName =
          _nameController.text.isNotEmpty ? _nameController.text : "Your Pet";
    });
  }

  void _playWithPet() {
    if (_gameOver) return;
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
      _updatePetImage();
      _updateMood();
    });
  }

  void _feedPet() {
    if (_gameOver) return;
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
      _updatePetImage();
      _updateMood();
    });
  }

  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
      _checkGameOver();
    }
  }

  void _increaseHunger() {
    setState(() {
      hungerLevel = (hungerLevel + 10).clamp(0, 100);
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel = (happinessLevel - 20).clamp(0, 100);
        _checkGameOver();
      }
      _updatePetImage();
      _updateMood();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  void _updatePetImage() {
    if (happinessLevel > 70) {
      petImage = 'assets/images/happy_pet.png';
      petColor = Colors.green;
    } else if (happinessLevel >= 30) {
      petImage = 'assets/images/neutral_pet.png';
      petColor = Colors.yellow;
    } else {
      petImage = 'assets/images/unhappy_pet.png';
      petColor = Colors.red;
    }
  }

  void _updateMood() {
    if (happinessLevel > 70) {
      moodText = "Happy 😄";
    } else if (happinessLevel >= 30) {
      moodText = "Neutral 😊";
    } else {
      moodText = "Unhappy 😢";
    }
  }

  void _checkGameOver() {
    if (hungerLevel >= 100 && happinessLevel <= 10) {
      setState(() {
        _gameOver = true;
      });
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text("Your pet is too hungry and unhappy!"),
          actions: <Widget>[
            TextButton(
              child: Text("Restart"),
              onPressed: () {
                setState(() {
                  happinessLevel = 50;
                  hungerLevel = 50;
                  _gameOver = false;
                  petImage = 'assets/images/neutral_pet.png';
                  moodText = "Neutral 😊";
                  _startHungerTimer();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: SingleChildScrollView(
        // Wrap the entire Column in a SingleChildScrollView
        child: Center(
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
              Container(
                decoration: BoxDecoration(
                  color: petColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(8),
                child: Image.asset(
                  petImage,
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Happiness Level: $happinessLevel',
                style: TextStyle(fontSize: 20.0),
              ),
              Text(
                'Hunger Level: $hungerLevel',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 16.0),
              Text(
                moodText,
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _playWithPet,
                child: Text('Play with Your Pet'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _feedPet,
                child: Text('Feed Your Pet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
