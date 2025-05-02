import 'package:flutter/material.dart';
import '../models/food_log.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../services/dynamodb_service.dart';

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
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final newFoodLog = FoodLog(
        id: _foodNameController.text,
        date: _selectedDate,
        foodName: _foodNameController.text,
        quantity: _quantityController.text,
        hadReaction: _hadReaction,
        reactionNotes: _notesController.text,
        imagePath: _selectedImage?.path,
      );

      // Convert to Map
      final foodLogMap = newFoodLog.toMap();

      final dynamoDBService = DynamoDBService();
      dynamoDBService.addFoodLog(foodLogMap);

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

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Food Log'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
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
                    SizedBox(height: 16),
                    _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Text('No image selected.'),
                    TextButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.image),
                      label: Text('Attach Image'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveForm,
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: TextStyle(fontSize: 18),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shadowColor: Colors.black54,
                  ),
                ),
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