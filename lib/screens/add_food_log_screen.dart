import 'package:flutter/material.dart';
import '../models/food_log.dart';
import 'package:hive/hive.dart';

class AddFoodLogScreen extends StatefulWidget {
  @override
  _AddFoodLogScreenState createState() => _AddFoodLogScreenState();
}

class _AddFoodLogScreenState extends State<AddFoodLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _foodNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _hadReaction = false;

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final newFoodLog = FoodLog(
        id: DateTime.now().toString(),
        date: _selectedDate,
        foodName: _foodNameController.text,
        quantity: _quantityController.text,
        hadReaction: _hadReaction,
        reactionNotes: _notesController.text,
      );

      // Save to Hive
      final box = Hive.box<FoodLog>('food_logs');
      box.add(newFoodLog);

      print('New food log added: $newFoodLog'); // Debug print

      Navigator.of(context).pop(); // Navigate back to the home screen
    }
  }

  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Food Log'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _foodNameController,
                decoration: InputDecoration(labelText: 'Food Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a food name.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the quantity.';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date: ${_selectedDate.toLocal()}'.split(' ')[0],
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: Text('Select Date'),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: _hadReaction,
                    onChanged: (value) {
                      setState(() {
                        _hadReaction = value!;
                      });
                    },
                  ),
                  Text('Had Reaction'),
                ],
              ),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(labelText: 'Reaction Notes'),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _foodNameController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}