import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:full_ecommerce_app/screens/auth/login_screen.dart';
import 'package:full_ecommerce_app/services/global_methods.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  static const routeName = '/signup-screen';
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isVisible = true;

  void _changeVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  String _fullName = '';
  late int _phoneNumber;
  File? _image;
  String _url = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  GlobalMethods _globalMethods = GlobalMethods();

  Future _getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    //final image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(image!.path);
    });
  }

  void _submitData() async {
    final _isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    var date = DateTime.now().toString();
    var parsedDate = DateTime.parse(date);
    var formatedDate =
        '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';

    if (_isValid) {
      _formKey.currentState!.save();
    }
    try {
      if (_image == null) {
        return _globalMethods.authDialog(context, 'Please provide an image');
      } else {
        setState(() {
          _isLoading = true;
        });
        final ref = FirebaseStorage.instance
            .ref()
            .child('userimages')
            .child(_fullName + '.jpg');
        await ref.putFile(_image!);
        _url = await ref.getDownloadURL();
        await _auth.createUserWithEmailAndPassword(
            email: _email.toLowerCase().trim(), password: _password.trim());
        final User? user = _auth.currentUser;
        final _uid = user!.uid;
        user.updatePhotoURL(_url);
        user.updateDisplayName(_fullName);
        user.reload();
        FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'id': _uid,
          'name': _fullName,
          'email': _email,
          'phoneNumber': _phoneNumber,
          'imageUrl': _url,
          'joinedDate': formatedDate,
          'createdAt': Timestamp.now(),
        });

        Navigator.canPop(context) ? Navigator.pop(context) : null;
      }
    } catch (error) {
      _globalMethods.authDialog(context, error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _fullNameFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RotatedBox(
            quarterTurns: 2,
            child: WaveWidget(
              config: CustomConfig(
                colors: [
                  Colors.orangeAccent,
                  Colors.tealAccent,
                  Colors.pinkAccent,
                  Colors.deepPurpleAccent,
                ],
                durations: [35000, 11000, 10800, 6000],
                heightPercentages: [0.01, 0.02, 0.03, 0.1],
                blur: const MaskFilter.blur(BlurStyle.solid, 0),
              ),
              heightPercentange: 0.2,
              size: const Size(double.infinity, double.infinity),
            ),
          ),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: _getImage,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                _image == null ? null : FileImage(_image!),
                            child: Icon(
                              _image == null ? Icons.camera : null,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          'Signup',
                          style: TextStyle(fontSize: 65),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      onSaved: (value) {
                        _fullName = value!;
                      },
                      key: const ValueKey('name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(_emailFocusNode),
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      onSaved: (value) {
                        _email = value!;
                      },
                      key: const ValueKey('email'),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => FocusScope.of(context)
                          .requestFocus(_passwordFocusNode),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      onSaved: (value) {
                        _password = value!;
                      },
                      key: const ValueKey('password'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 8) {
                          return 'Password must be atleast 8 units';
                        }
                        return null;
                      },
                      onEditingComplete: () => FocusScope.of(context)
                          .requestFocus(_passwordFocusNode),
                      obscureText: _isVisible,
                      focusNode: _passwordFocusNode,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _changeVisibility();
                          },
                          icon: _isVisible
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      onSaved: (value) {
                        _phoneNumber = int.parse(value!);
                      },
                      key: const ValueKey('phone'),
                      validator: (value) {
                        if (value!.length != 11 || value.isEmpty) {
                          return 'Phone number must be 11 units';
                        }
                        return null;
                      },
                      onEditingComplete: _submitData,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.phone),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _submitData,
                            child: const Text(
                              'Signup',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.routeName);
                  },
                  child: const Text(
                    'Signup to Your Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ],
      ),
    );
  }
}
