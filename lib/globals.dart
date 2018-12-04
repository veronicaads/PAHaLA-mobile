import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

GoogleSignIn googleSignIn = GoogleSignIn();
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
GoogleSignInAccount googleAccount;
GoogleSignInAuthentication googleAuth;
FirebaseUser firebaseUser;
bool redirectOnce = true;
Brightness globalBrightness = Brightness.light;