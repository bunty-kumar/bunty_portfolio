import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/portfolio_models.dart';
import 'default_portfolio_data.dart';

class FirebaseService {
  static bool _isFirebaseInitialized = false;

  static bool get isInitialized => _isFirebaseInitialized;

  static const defaultOptions = FirebaseOptions(
    apiKey: "AIzaSyBN9mplOR5muNJF93k3x0QoIYFQ98Ev6PM",
    authDomain: "buntybusiness-f8535.firebaseapp.com",
    projectId: "buntybusiness-f8535",
    storageBucket: "buntybusiness-f8535.firebasestorage.app",
    messagingSenderId: "949543734238",
    appId: "1:949543734238:web:2cf789577e21e07b84eb4f",
  );

  /// Tries initializing Firebase using default or custom options provided by user
  static Future<bool> initializeCustomFirebase({
    required String apiKey,
    required String authDomain,
    required String projectId,
    required String storageBucket,
    required String messagingSenderId,
    required String appId,
  }) async {
    try {
      if (apiKey.isEmpty || projectId.isEmpty) return false;

      final options = FirebaseOptions(
        apiKey: apiKey,
        authDomain: authDomain.isNotEmpty ? authDomain : '$projectId.firebaseapp.com',
        projectId: projectId,
        storageBucket: storageBucket.isNotEmpty ? storageBucket : '$projectId.appspot.com',
        messagingSenderId: messagingSenderId.isNotEmpty ? messagingSenderId : '123456789',
        appId: appId,
      );

      if (Firebase.apps.isNotEmpty) {
        await Firebase.app().delete();
      }

      await Firebase.initializeApp(options: options);
      _isFirebaseInitialized = true;
      return true;
    } catch (e) {
      if (kDebugMode) print('Firebase init error: $e');
      return false;
    }
  }

  static Future<void> tryAutoInit() async {
    try {
      if (Firebase.apps.isNotEmpty) {
        _isFirebaseInitialized = true;
      } else {
        await Firebase.initializeApp(options: defaultOptions);
        _isFirebaseInitialized = true;
      }
    } catch (e) {
      try {
        await Firebase.initializeApp();
        _isFirebaseInitialized = true;
      } catch (_) {
        _isFirebaseInitialized = false;
      }
    }
  }

  // --- Firestore Streams ---

  static Stream<ThemeConfigModel>? getThemeStream() {
    if (!_isFirebaseInitialized) return null;
    return FirebaseFirestore.instance
        .collection('portfolio_config')
        .doc('settings')
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return ThemeConfigModel.fromMap(snapshot.data()!['theme'] ?? {});
      }
      return DefaultPortfolioData.theme;
    });
  }

  static Stream<BrandingModel>? getBrandingStream() {
    if (!_isFirebaseInitialized) return null;
    return FirebaseFirestore.instance
        .collection('portfolio_config')
        .doc('settings')
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return BrandingModel.fromMap(snapshot.data()!['branding'] ?? {});
      }
      return DefaultPortfolioData.branding;
    });
  }

  static Stream<HeroModel>? getHeroStream() {
    if (!_isFirebaseInitialized) return null;
    return FirebaseFirestore.instance
        .collection('portfolio_config')
        .doc('hero')
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return HeroModel.fromMap(snapshot.data()!);
      }
      return DefaultPortfolioData.hero;
    });
  }

  static Stream<AboutModel>? getAboutStream() {
    if (!_isFirebaseInitialized) return null;
    return FirebaseFirestore.instance
        .collection('portfolio_config')
        .doc('about')
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return AboutModel.fromMap(snapshot.data()!);
      }
      return DefaultPortfolioData.about;
    });
  }

  static Stream<SocialsModel>? getSocialsStream() {
    if (!_isFirebaseInitialized) return null;
    return FirebaseFirestore.instance
        .collection('portfolio_config')
        .doc('settings')
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return SocialsModel.fromMap(snapshot.data()!['socials'] ?? {});
      }
      return DefaultPortfolioData.socials;
    });
  }

  static Stream<List<ProjectModel>>? getProjectsStream() {
    if (!_isFirebaseInitialized) return null;
    return FirebaseFirestore.instance
        .collection('projects')
        .orderBy('order')
        .snapshots()
        .map((query) {
      return query.docs.map((doc) => ProjectModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  static Stream<List<SkillModel>>? getSkillsStream() {
    if (!_isFirebaseInitialized) return null;
    return FirebaseFirestore.instance
        .collection('skills')
        .orderBy('order')
        .snapshots()
        .map((query) {
      return query.docs.map((doc) => SkillModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  static Stream<List<ExperienceModel>>? getExperiencesStream() {
    if (!_isFirebaseInitialized) return null;
    return FirebaseFirestore.instance
        .collection('experiences')
        .orderBy('order')
        .snapshots()
        .map((query) {
      return query.docs.map((doc) => ExperienceModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  static Stream<List<ServiceModel>>? getServicesStream() {
    if (!_isFirebaseInitialized) return null;
    return FirebaseFirestore.instance
        .collection('services')
        .orderBy('order')
        .snapshots()
        .map((query) {
      return query.docs.map((doc) => ServiceModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  static Stream<List<TestimonialModel>>? getTestimonialsStream() {
    if (!_isFirebaseInitialized) return null;
    return FirebaseFirestore.instance
        .collection('testimonials')
        .orderBy('order')
        .snapshots()
        .map((query) {
      return query.docs.map((doc) => TestimonialModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  static Stream<List<ContactMessageModel>>? getMessagesStream() {
    if (!_isFirebaseInitialized) return null;
    return FirebaseFirestore.instance
        .collection('messages')
        .snapshots()
        .map((query) {
      return query.docs.map((doc) => ContactMessageModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  // --- Save Operations ---

  static Future<void> saveTheme(ThemeConfigModel theme) async {
    if (!_isFirebaseInitialized) return;
    await FirebaseFirestore.instance
        .collection('portfolio_config')
        .doc('settings')
        .set({'theme': theme.toMap()}, SetOptions(merge: true));
  }

  static Future<void> saveBranding(BrandingModel branding) async {
    if (!_isFirebaseInitialized) return;
    await FirebaseFirestore.instance
        .collection('portfolio_config')
        .doc('settings')
        .set({'branding': branding.toMap()}, SetOptions(merge: true));
  }

  static Future<void> saveHero(HeroModel hero) async {
    if (!_isFirebaseInitialized) return;
    await FirebaseFirestore.instance
        .collection('portfolio_config')
        .doc('hero')
        .set(hero.toMap());
  }

  static Future<void> saveAbout(AboutModel about) async {
    if (!_isFirebaseInitialized) return;
    await FirebaseFirestore.instance
        .collection('portfolio_config')
        .doc('about')
        .set(about.toMap());
  }

  static Future<void> saveSocials(SocialsModel socials) async {
    if (!_isFirebaseInitialized) return;
    await FirebaseFirestore.instance
        .collection('portfolio_config')
        .doc('settings')
        .set({'socials': socials.toMap()}, SetOptions(merge: true));
  }

  // --- Projects CRUD ---
  static Future<void> addOrUpdateProject(ProjectModel project) async {
    if (!_isFirebaseInitialized) return;
    final docRef = project.id.isEmpty
        ? FirebaseFirestore.instance.collection('projects').doc()
        : FirebaseFirestore.instance.collection('projects').doc(project.id);
    
    await docRef.set(project.toMap()..['id'] = docRef.id);
  }

  static Future<void> deleteProject(String id) async {
    if (!_isFirebaseInitialized) return;
    await FirebaseFirestore.instance.collection('projects').doc(id).delete();
  }

  // --- Skills CRUD ---
  static Future<void> addOrUpdateSkill(SkillModel skill) async {
    if (!_isFirebaseInitialized) return;
    final docRef = skill.id.isEmpty
        ? FirebaseFirestore.instance.collection('skills').doc()
        : FirebaseFirestore.instance.collection('skills').doc(skill.id);
    
    await docRef.set(skill.toMap()..['id'] = docRef.id);
  }

  static Future<void> deleteSkill(String id) async {
    if (!_isFirebaseInitialized) return;
    await FirebaseFirestore.instance.collection('skills').doc(id).delete();
  }

  // --- Experience CRUD ---
  static Future<void> addOrUpdateExperience(ExperienceModel exp) async {
    if (!_isFirebaseInitialized) return;
    final docRef = exp.id.isEmpty
        ? FirebaseFirestore.instance.collection('experiences').doc()
        : FirebaseFirestore.instance.collection('experiences').doc(exp.id);
    
    await docRef.set(exp.toMap()..['id'] = docRef.id);
  }

  static Future<void> deleteExperience(String id) async {
    if (!_isFirebaseInitialized) return;
    await FirebaseFirestore.instance.collection('experiences').doc(id).delete();
  }

  // --- Services CRUD ---
  static Future<void> addOrUpdateService(ServiceModel service) async {
    if (!_isFirebaseInitialized) return;
    final docRef = service.id.isEmpty
        ? FirebaseFirestore.instance.collection('services').doc()
        : FirebaseFirestore.instance.collection('services').doc(service.id);
    
    await docRef.set(service.toMap()..['id'] = docRef.id);
  }

  static Future<void> deleteService(String id) async {
    if (!_isFirebaseInitialized) return;
    await FirebaseFirestore.instance.collection('services').doc(id).delete();
  }

  // --- Testimonials CRUD ---
  static Future<void> addOrUpdateTestimonial(TestimonialModel item) async {
    if (!_isFirebaseInitialized) return;
    final docRef = item.id.isEmpty
        ? FirebaseFirestore.instance.collection('testimonials').doc()
        : FirebaseFirestore.instance.collection('testimonials').doc(item.id);
    
    await docRef.set(item.toMap()..['id'] = docRef.id);
  }

  static Future<void> deleteTestimonial(String id) async {
    if (!_isFirebaseInitialized) return;
    await FirebaseFirestore.instance.collection('testimonials').doc(id).delete();
  }

  // --- Contact Messages ---
  static Future<void> sendMessage(ContactMessageModel message) async {
    if (!_isFirebaseInitialized) return;
    final docRef = FirebaseFirestore.instance.collection('messages').doc();
    await docRef.set(message.toMap()..['id'] = docRef.id);
  }

  static Future<void> markMessageRead(String id) async {
    if (!_isFirebaseInitialized) return;
    await FirebaseFirestore.instance.collection('messages').doc(id).update({'read': true});
  }

  static Future<void> deleteMessage(String id) async {
    if (!_isFirebaseInitialized) return;
    await FirebaseFirestore.instance.collection('messages').doc(id).delete();
  }

  // --- Auth Operations ---
  static Future<UserCredential?> loginAdmin(String email, String password) async {
    if (!_isFirebaseInitialized) return null;
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<UserCredential?> registerAdminUser(String email, String password) async {
    if (!_isFirebaseInitialized) return null;
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> logoutAdmin() async {
    if (!_isFirebaseInitialized) return;
    await FirebaseAuth.instance.signOut();
  }
}
