import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:image_picker/image_picker.dart';

const String _baseURL = 'http://fatimamobile.atwebpages.com';

class AddNews extends StatefulWidget {
  const AddNews({super.key});

  @override
  State<AddNews> createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  int? _selectedCid;
  List<dynamic> _categories = [];
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final url = Uri.parse('$_baseURL/getCategories.php');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        setState(() {
          try {
             _categories = convert.jsonDecode(response.body);
             if (_categories.isNotEmpty && _selectedCid == null) {
               _selectedCid = int.tryParse(_categories[0]['cid'].toString());
             }
          } catch (e) {
             // Handle error
          }
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
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

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedCid != null) {
      setState(() {
        _loading = true;
      });
      saveNews(
        update,
        _titleController.text,
        _contentController.text,
        _imageFile,
        _selectedCid!
      );
    } else if (_selectedCid == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a category')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add News Article'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
               TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _contentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                validator: (value) => value!.isEmpty ? 'Please enter content' : null,
              ),
              const SizedBox(height: 16),

              // Image Picker UI
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Pick Featured Image'),
                  ),
                  const SizedBox(width: 10),
                  if (_imageFile != null)
                    Expanded(
                      child: Text(
                        'Selected: ${_imageFile!.name}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                ],
              ),
              if (_imageFile != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.network(
                    _imageFile!.path, // Works for web blob URLs
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (c, o, s) => const Text('Image Preview Error'),
                  ),
                ),

              const SizedBox(height: 16),

              DropdownButtonFormField<int>(
                value: _selectedCid,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories.map<DropdownMenuItem<int>>((item) {
                  return DropdownMenuItem<int>(
                    value: int.tryParse(item['cid'].toString()),
                    child: Text(item['name'] ?? 'Unknown'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCid = value;
                  });
                },
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text('PUBLISH NEWS', style: TextStyle(fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void saveNews(Function(String) update, String title, String content, XFile? imageFile, int cid) async {
  try {
    var request = http.MultipartRequest('POST', Uri.parse('$_baseURL/saveNews.php'));
    request.fields['title'] = title;
    request.fields['content'] = content;
    request.fields['cid'] = cid.toString();

    if (imageFile != null) {
       // For web, using fromBytes is safer if path assumes file system
       var bytes = await imageFile.readAsBytes();
       request.files.add(http.MultipartFile.fromBytes(
         'image', 
         bytes,
         filename: imageFile.name
       ));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      try {
        var json = convert.jsonDecode(response.body);
        if (json['success'] == true) {
           update('News published successfully!');
        } else {
           update('Failed: ${json['message']}');
        }
      } catch (e) {
        update('Server Response Error: ${response.body}');
      }
    } else {
      update('Server Error: ${response.statusCode}');
    }
  } catch (e) {
    update('Connection Error: $e');
  }
}
