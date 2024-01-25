import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Screen Lock',
      theme: ThemeData(

        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String username = 'User';
  String imagePath = 'assets/images/avatar.jpg';

  void _editProfile() async {
    final editedProfile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          currentUsername: username,
          currentImagePath: imagePath,
        ),
      ),
    );

    if (editedProfile != null) {
      setState(() {
        username = editedProfile['username'];
        imagePath = editedProfile['imagePath'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //       onPressed: _editProfile,
      //       icon: Icon(Icons.edit),
      //     ),
      //   ],
      // ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [ 0.1, 0.4, 0.6, 0.9 ],
            colors: [ Colors.black, Colors.black87, Colors.black87, Colors.black,],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 119,),
                GestureDetector(
                  onTap: _editProfile,
                  child: _buildImageWidget(),
                ),
                SizedBox(height: 39),
                Text(
                  username,
                  style: TextStyle(fontSize: 39, color: Colors.white, fontFamily: 'FontMain',),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _buildImageWidget() {
    if (imagePath.toLowerCase().startsWith('assets/')) {
      // If the path is an asset, display it using AssetImage
      return CircleAvatar(
        backgroundImage: AssetImage(imagePath),
        backgroundColor: Colors.transparent,
        radius: 100,
        key: UniqueKey(),
      );
    } else {
      // Otherwise, treat it as a file path and display it using FileImage
      return CircleAvatar(
        backgroundImage: FileImage(File(imagePath)),
        backgroundColor: Colors.transparent,
        radius: 100,
        key: UniqueKey(),
      );
    }
  }
}

class EditProfileScreen extends StatefulWidget {
  final String currentUsername;
  final String currentImagePath;

  const EditProfileScreen({
    required this.currentUsername,
    required this.currentImagePath,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _usernameController;
  late String _imagePath;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.currentUsername);
    _imagePath = widget.currentImagePath;
  }

  Future<void> _selectNewImage() async {
    final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imagePath = pickedImage.path;
      });
    }
  }

  void _saveChanges() {
    final editedProfile = {
      'username': _usernameController.text,
      'imagePath': _imagePath,
    };

    Navigator.pop(context, editedProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 49,),
            GestureDetector(
              onTap: _selectNewImage,
              child: _buildImageWidget(),
            ),
            SizedBox(height: 29),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 29),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (_imagePath.toLowerCase().startsWith('assets/')) {
      // If the path is an asset, display it using AssetImage
      return CircleAvatar(
        backgroundImage: AssetImage(_imagePath),
        backgroundColor: Colors.transparent,
        radius: 100,
        key: UniqueKey(),
      );
    } else {
      // Otherwise, treat it as a file path and display it using FileImage
      return CircleAvatar(
        backgroundImage: FileImage(File(_imagePath)),
        backgroundColor: Colors.transparent,
        radius: 100,
        key: UniqueKey(),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
