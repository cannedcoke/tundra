import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 
import 'dart:io';
import 'package:tundra/editor.dart'; // needed to use the File class to display the image
import 'package:loading_animation_widget/loading_animation_widget.dart';
void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()));
}

class HomeScreen extends StatefulWidget {
  // must be StatefulWidget to store the image
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // this function handles picking an image from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker(); // create a picker instance

    // launch the camera or gallery depending on the source passed in
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // user picked an image (didn't cancel)
      File image = File(pickedFile.path);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Edit(image: image)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bienvenido"), centerTitle: true),
      body: Column(
        children: [
            LoadingAnimationWidget.staggeredDotsWave(
            color: const Color.fromARGB(255, 9, 8, 8),
            size: 50,
          ),
          Spacer(), // ← pushes buttons to the bottom

          Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  heroTag: 'camera',
                  onPressed: () => _pickImage(ImageSource.camera),
                  label: Text('Tomar foto'),
                  icon: Icon(Icons.camera_alt_outlined),
                ),

                SizedBox(width: 12),

                FloatingActionButton.extended(
                  heroTag: 'gallery',
                  onPressed: () => _pickImage(ImageSource.gallery),
                  label: Text('Elegir de la galeria'),
                  icon: Icon(Icons.photo_size_select_actual_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
