import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const String _baseURL = 'http://fatimamobile.atwebpages.com';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void update(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    setState(() {
      _loading = false;
    });
    if (text.toLowerCase().contains('success')) {
      Navigator.of(context).pop();
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      saveCategory(update, _nameController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Category'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Category Name', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Enter Name' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading ? const CircularProgressIndicator() : const Text('Save Category'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void saveCategory(Function(String) update, String name) async {
  try {
    // We use a regular POST request (Standard Form) for better compatibility
    final response = await http.post(
      Uri.parse('$_baseURL/save_category.php'),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "name": name,
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      if (response.body.contains('success":true')) {
        update('Category added successfully');
      } else {
        update('Error: ${response.body}');
      }
    } else {
      update('Server Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to add category: $e');
    update('Connection Error: $e');
  }
}
