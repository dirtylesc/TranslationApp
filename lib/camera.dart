import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import 'package:translation_app/constants/languages.dart';

class CameraPage extends StatefulWidget {
  final Function(String, Language, Language) navigateToHome;
  const CameraPage({super.key, required this.navigateToHome});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isFlashOn = false;

  late Language _sourceLanguage = languages[0];
  late Language _targetLanguage = languages[1];

  @override
  void initState() {
    super.initState();

    _setCamera();
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller!.dispose();
    }

    super.dispose();
  }

  Future<void> _setCamera() async {
    final cameras = await availableCameras();

    setState(() {
      _controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
      );

      _initializeControllerFuture = _controller!.initialize();
    });
  }

  Future<void> _toggleFlash() async {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });

    if (_controller != null) {
      await _controller!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
    }
  }

  Future<void> _recognizingText(InputImage img) async {
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(img);

    widget.navigateToHome(
        recognizedText.text, _sourceLanguage, _targetLanguage);

    textRecognizer.close();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _recognizingText(InputImage.fromFilePath(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (_controller != null &&
                  snapshot.connectionState == ConnectionState.done) {
                return Positioned.fill(
                  child: CameraPreview(_controller!),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Positioned(
            top: 10,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 251, 254, 1),
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    _sourceLanguage.img,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButton<Language>(
                      value: _sourceLanguage,
                      onChanged: (newValue) {
                        setState(() {
                          if (newValue != null &&
                              _targetLanguage.code == newValue.code) {
                            _targetLanguage = _sourceLanguage;
                          }
                          _sourceLanguage = newValue!;
                        });
                      },
                      items: languages.map((language) {
                        return DropdownMenuItem<Language>(
                          value: language,
                          child: Text(
                            language.name,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        );
                      }).toList(),
                      isExpanded: true,
                      underline: Container(
                        height: 1,
                        color: Colors.grey[400],
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: () {
                      setState(() {
                        final temp = _sourceLanguage;
                        _sourceLanguage = _targetLanguage;
                        _targetLanguage = temp;
                      });
                    },
                    child: const Icon(Icons.swap_horiz, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Image.asset(
                    _targetLanguage.img,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButton<Language>(
                      value: _targetLanguage,
                      onChanged: (newValue) {
                        setState(() {
                          if (newValue != null && _sourceLanguage == newValue) {
                            _sourceLanguage = _targetLanguage;
                          }
                          _targetLanguage = newValue!;
                        });
                      },
                      items: languages.map((language) {
                        return DropdownMenuItem<Language>(
                          value: language,
                          child: Text(
                            language.name,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        );
                      }).toList(),
                      isExpanded: true,
                      underline: Container(
                        height: 1,
                        color: Colors.grey[400],
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {
                      _pickImage(ImageSource.gallery);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset("images/placeholder.jpg",
                          width: 32, height: 32),
                    )),
                FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  onPressed: () async {
                    try {
                      await _initializeControllerFuture;
                      if (_controller == null) return;

                      final image = await _controller!.takePicture();

                      if (!context.mounted) return;

                      _recognizingText(InputImage.fromFilePath(image.path));

                      // await Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => DisplayPictureScreen(
                      //       imagePath: image.path,
                      //     ),
                      //   ),
                      // );
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white, width: 5),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.blue[900],
                          borderRadius: BorderRadius.circular(35),
                        ),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    _toggleFlash();
                  },
                  child: Icon(
                    _isFlashOn
                        ? Icons.flash_on_outlined
                        : Icons.flash_off_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
