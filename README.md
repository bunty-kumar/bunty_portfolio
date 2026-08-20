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
  apiKey: "AIzaSyDG31kdPBKAcH23qAWnMr_riInv-a1A8Lc",
  authDomain: "bunty-portfolio-project.firebaseapp.com",
  projectId: "bunty-portfolio-project",
  storageBucket: "bunty-portfolio-project.firebasestorage.app",
  messagingSenderId: "1097946740580",
  appId: "1:1097946740580:web:0b1b82cee86f5c534bec71",
  measurementId: "G-YHY76XYGYW"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);


"site": "bunty-dev",