# bunty_portfolio

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyBN9mplOR5muNJF93k3x0QoIYFQ98Ev6PM",
  authDomain: "buntybusiness-f8535.firebaseapp.com",
  databaseURL: "https://buntybusiness-f8535-default-rtdb.firebaseio.com",
  projectId: "buntybusiness-f8535",
  storageBucket: "buntybusiness-f8535.firebasestorage.app",
  messagingSenderId: "949543734238",
  appId: "1:949543734238:web:2cf789577e21e07b84eb4f",
  measurementId: "G-R23K4QPW6N"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);