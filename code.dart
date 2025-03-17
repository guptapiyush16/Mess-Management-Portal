import 'package:flutter/material.dart';

void main() {
  runApp(MessManagementApp());
}

class MessManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mess Management Portal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  // Simulated user database
  final Map<String, String> users = {
    'user1@example.com': 'password123',
    'admin@example.com': 'adminpass',
  };

  void _authenticate() {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    // Simulated delay to mimic backend call
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;

        String email = emailController.text.trim();
        String password = passwordController.text.trim();

        if (users.containsKey(email) && users[email] == password) {
          // Navigate to home screen if authentication is successful
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          // Show error message
          errorMessage = 'Invalid email or password.';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: isLoading ? null : _authenticate,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int mealCounter = 0;

  void updateMealCounter(int value) {
    setState(() {
      mealCounter += value;
      if (mealCounter < 0) mealCounter = 0;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mess Management Portal'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Welcome to the Mess Management Portal',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Text('Updated Menu'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdatedMenuScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Mess'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessScreen(
                    updateMealCounter: updateMealCounter,
                    currentMealCounter: mealCounter,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Canteen'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CanteenScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Waste Management'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WasteManagementScreen()),
              );
            },
          ),
          Spacer(),
          Card(
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Meal Counter',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$mealCounter',
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UpdatedMenuScreen extends StatelessWidget {
  final List<Map<String, String>> mealSchedule = [
    {'time': '08:00', 'meal': 'Breakfast: Eggs, Bread, and Milk'},
    {'time': '13:00', 'meal': 'Lunch: Rice, Dal, and Vegetables'},
    {'time': '19:00', 'meal': 'Dinner: Chapati, Curry, and Salad'},
  ];

  String getNextMeal() {
    final now = DateTime.now();
    for (var schedule in mealSchedule) {
      final mealTimeParts = schedule['time']!.split(':');
      final mealHour = int.parse(mealTimeParts[0]);
      final mealMinute = int.parse(mealTimeParts[1]);
      final mealTime = DateTime(now.year, now.month, now.day, mealHour, mealMinute);
      if (now.isBefore(mealTime)) {
        return schedule['meal']!;
      }
    }
    return 'No upcoming meals today!';
  }

  @override
  Widget build(BuildContext context) {
    final nextMeal = getNextMeal();

    return Scaffold(
      appBar: AppBar(title: Text('Updated Menu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Next Upcoming Meal',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              nextMeal,
              style: TextStyle(fontSize: 18, color: Colors.blue),
            ),
            Divider(height: 30),
            Text(
              'Full Day Menu',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...mealSchedule.map((meal) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  '${meal['time']} - ${meal['meal']}',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
 
class MessScreen extends StatefulWidget {
  final Function(int) updateMealCounter;
  final int currentMealCounter;

  MessScreen({required this.updateMealCounter, required this.currentMealCounter});

  @override
  _MessScreenState createState() => _MessScreenState();
}

class _MessScreenState extends State<MessScreen> {
  bool wantsMeal = true;

  void savePreference() {
    widget.updateMealCounter(wantsMeal ? 1 : -1);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Preference Saved'),
        content: Text('Your meal preference has been updated.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mess')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Will you be eating the upcoming meal?'),
              value: wantsMeal,
              onChanged: (bool value) {
                setState(() {
                  wantsMeal = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: savePreference,
              child: Text('Save Preferences'),
            ),
          ],
        ),
      ),
    );
  }
}

class CanteenScreen extends StatefulWidget {
  @override
  _CanteenScreenState createState() => _CanteenScreenState();
}

class _CanteenScreenState extends State<CanteenScreen> {
  final List<Map<String, dynamic>> items = [
    {"name": "Sandwich", "price": 30.0, "available": true},
    {"name": "Pasta", "price": 50.0, "available": true},
    {"name": "Burger", "price": 40.0, "available": true},
    {"name": "Soda", "price": 20.0, "available": true},
    {"name": "Ice Cream", "price": 25.0, "available": false},
  ];

  void placeOrder(String itemName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Placed'),
        content: Text('You have successfully ordered $itemName!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Canteen Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: Text(item["name"]),
                subtitle: Text("Price: ₹${item["price"]}"),
                trailing: item["available"]
                    ? ElevatedButton(
                        onPressed: () => placeOrder(item["name"]),
                        child: Text('Order'),
                      )
                    : Text(
                        'Unavailable',
                        style: TextStyle(color: Colors.red),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
class WasteManagementScreen extends StatelessWidget {
  final double wasteReducedWeek = 15.0; // Example data in kilograms
  final double wasteReducedMonth = 60.0; // Example data
  final double wasteReducedYear = 700.0; // Example data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Waste Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Waste Reduction Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Waste Reduced in the Last Week'),
              trailing: Text('${wasteReducedWeek.toStringAsFixed(1)} kg'),
            ),
            ListTile(
              title: Text('Waste Reduced in the Last Month'),
              trailing: Text('${wasteReducedMonth.toStringAsFixed(1)} kg'),
            ),
            ListTile(
              title: Text('Waste Reduced in the Last Year'),
              trailing: Text('${wasteReducedYear.toStringAsFixed(1)} kg'),
            ),
          ],
        ),
      ),
    );
  }
}
