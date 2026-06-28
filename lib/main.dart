import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const VinosApp());
}

class VinosApp extends StatelessWidget {
  const VinosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vinos Barbers',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();
  List<String> customers = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      customers = prefs.getStringList('customers') ?? [];
    });
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('customers', customers);
  }

  void addCustomer() async {
    if (controller.text.isEmpty) return;

    customers.add('${controller.text}:0');

    controller.clear();
    await saveData();
    setState(() {});
  }

  void addHaircut(int index) async {
    var parts = customers[index].split(':');
    int count = int.parse(parts[1]);

    count++;

    if (count > 10) count = 0;

    customers[index] = '${parts[0]}:$count';

    await saveData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vinos Barbers")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Customer name",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addCustomer,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final parts = customers[index].split(':');
                final name = parts[0];
                final count = int.parse(parts[1]);

                return ListTile(
                  title: Text(name),
                  subtitle: Text("$count / 10"),
                  trailing: ElevatedButton(
                    onPressed: () => addHaircut(index),
                    child: const Text("+1"),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}