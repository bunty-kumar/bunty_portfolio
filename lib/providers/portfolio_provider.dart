import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/portfolio_models.dart';
import '../services/default_portfolio_data.dart';
import '../services/firebase_service.dart';

class PortfolioProvider extends ChangeNotifier {
  ThemeConfigModel _theme = DefaultPortfolioData.theme;
  BrandingModel _branding = DefaultPortfolioData.branding;
  HeroModel _hero = DefaultPortfolioData.hero;
  AboutModel _about = DefaultPortfolioData.about;
  SocialsModel _socials = DefaultPortfolioData.socials;

  List<ProjectModel> _projects = DefaultPortfolioData.projects;
  List<SkillModel> _skills = DefaultPortfolioData.skills;
  List<ExperienceModel> _experiences = DefaultPortfolioData.experiences;
  List<ServiceModel> _services = DefaultPortfolioData.services;
  List<TestimonialModel> _testimonials = DefaultPortfolioData.testimonials;
  List<ContactMessageModel> _messages = [];

  bool _isFetchingFromFirestore = true;

  // Config strings for visual setup
  String firebaseApiKey = 'AIzaSyDG31kdPBKAcH23qAWnMr_riInv-a1A8Lc';
  String firebaseProjectId = 'bunty-portfolio-project';
  String firebaseAppId = '1:1097946740580:web:0b1b82cee86f5c534bec71';

  PortfolioProvider() {
    _initPortfolio();
  }

  // Getters
  ThemeConfigModel get theme => _theme;
  BrandingModel get branding => _branding;
  HeroModel get hero => _hero;
  AboutModel get about => _about;
  SocialsModel get socials => _socials;

  List<ProjectModel> get projects => _projects;
  List<SkillModel> get skills => _skills;
  List<ExperienceModel> get experiences => _experiences;
  List<ServiceModel> get services => _services;
  List<TestimonialModel> get testimonials => _testimonials;
  List<ContactMessageModel> get messages => _messages;

  bool get isFetchingFromFirestore => _isFetchingFromFirestore;

  Future<void> _initPortfolio() async {
    _isFetchingFromFirestore = true;
    notifyListeners();

    await FirebaseService.tryAutoInit();
    if (FirebaseService.isInitialized) {
      _listenToFirestore();
    } else {
      _isFetchingFromFirestore = false;
      notifyListeners();
    }
  }

  void _listenToFirestore() {
    void handleErr(dynamic error) {
      if (kDebugMode) print('Firestore stream notice: $error');
      if (_isFetchingFromFirestore) {
        _isFetchingFromFirestore = false;
        notifyListeners();
      }
    }

    // Theme Stream
    FirebaseService.getThemeStream()?.handleError(handleErr).listen((newTheme) {
      _theme = newTheme;
      _isFetchingFromFirestore = false;
      notifyListeners();
    });

    // Branding Stream
    FirebaseService.getBrandingStream()?.handleError(handleErr).listen((b) {
      _branding = b;
      _isFetchingFromFirestore = false;
      notifyListeners();
    });

    // Hero Stream
    FirebaseService.getHeroStream()?.handleError(handleErr).listen((h) {
      _hero = h;
      _isFetchingFromFirestore = false;
      notifyListeners();
    });

    // About Stream
    FirebaseService.getAboutStream()?.handleError(handleErr).listen((a) {
      _about = a;
      _isFetchingFromFirestore = false;
      notifyListeners();
    });

    // Socials Stream
    FirebaseService.getSocialsStream()?.handleError(handleErr).listen((s) {
      _socials = s;
      _isFetchingFromFirestore = false;
      notifyListeners();
    });

    // Projects Stream
    FirebaseService.getProjectsStream()?.handleError(handleErr).listen((p) {
      if (p.isNotEmpty) {
        _projects = p;
      }
      _isFetchingFromFirestore = false;
      notifyListeners();
    });

    // Skills Stream
    FirebaseService.getSkillsStream()?.handleError(handleErr).listen((s) {
      if (s.isNotEmpty) {
        _skills = s;
      }
      _isFetchingFromFirestore = false;
      notifyListeners();
    });

    // Experiences Stream
    FirebaseService.getExperiencesStream()?.handleError(handleErr).listen((e) {
      if (e.isNotEmpty) {
        _experiences = e;
      }
      _isFetchingFromFirestore = false;
      notifyListeners();
    });

    // Services Stream
    FirebaseService.getServicesStream()?.handleError(handleErr).listen((s) {
      if (s.isNotEmpty) {
        _services = s;
      }
      _isFetchingFromFirestore = false;
      notifyListeners();
    });

    // Testimonials Stream
    FirebaseService.getTestimonialsStream()?.handleError(handleErr).listen((t) {
      if (t.isNotEmpty) {
        _testimonials = t;
      }
      _isFetchingFromFirestore = false;
      notifyListeners();
    });

    // Messages Stream
    FirebaseService.getMessagesStream()?.handleError(handleErr).listen((m) {
      _messages = m;
      _isFetchingFromFirestore = false;
      notifyListeners();
    });

    // Safety timeout to dismiss shimmer if Firestore collections take longer
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (_isFetchingFromFirestore) {
        _isFetchingFromFirestore = false;
        notifyListeners();
      }
    });
  }

  // --- Dynamic Color & Theme Actions ---
  Future<void> updateTheme(ThemeConfigModel newTheme) async {
    _theme = newTheme;
    notifyListeners();
    if (FirebaseService.isInitialized) {
      await FirebaseService.saveTheme(newTheme);
    }
  }

  // --- Branding Actions ---
  Future<void> updateBranding(BrandingModel newBranding) async {
    _branding = newBranding;
    notifyListeners();
    if (FirebaseService.isInitialized) {
      await FirebaseService.saveBranding(newBranding);
    }
  }

  // --- Hero Actions ---
  Future<void> updateHero(HeroModel newHero) async {
    _hero = newHero;
    notifyListeners();
    if (FirebaseService.isInitialized) {
      await FirebaseService.saveHero(newHero);
    }
  }

  // --- About Actions ---
  Future<void> updateAbout(AboutModel newAbout) async {
    _about = newAbout;
    notifyListeners();
    if (FirebaseService.isInitialized) {
      await FirebaseService.saveAbout(newAbout);
    }
  }

  // --- Socials Actions ---
  Future<void> updateSocials(SocialsModel newSocials) async {
    _socials = newSocials;
    notifyListeners();
    if (FirebaseService.isInitialized) {
      await FirebaseService.saveSocials(newSocials);
    }
  }

  // --- Projects CRUD ---
  Future<void> saveProject(ProjectModel project) async {
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index >= 0) {
      _projects[index] = project;
    } else {
      _projects.add(project);
    }
    notifyListeners();
    if (FirebaseService.isInitialized) {
      await FirebaseService.addOrUpdateProject(project);
    }
  }

  Future<void> deleteProject(String id) async {
    _projects.removeWhere((p) => p.id == id);
    notifyListeners();
    if (FirebaseService.isInitialized) {
      await FirebaseService.deleteProject(id);
    }
  }

  // --- Skills CRUD ---
  Future<void> saveSkill(SkillModel skill) async {
    final index = _skills.indexWhere((s) => s.id == skill.id);
    if (index >= 0) {
      _skills[index] = skill;
    } else {
      _skills.add(skill);
    }
    notifyListeners();
    if (FirebaseService.isInitialized) {
      await FirebaseService.addOrUpdateSkill(skill);
    }
  }

  Future<void> deleteSkill(String id) async {
    _skills.removeWhere((s) => s.id == id);
    notifyListeners();
    if (FirebaseService.isInitialized) {
      await FirebaseService.deleteSkill(id);
    }
  }

  // --- Experience CRUD ---
  Future<void> saveExperience(ExperienceModel exp) async {
    final index = _experiences.indexWhere((e) => e.id == exp.id);
    if (index >= 0) {
      _experiences[index] = exp;
    } else {
      _experiences.add(exp);
    }
    notifyListeners();
    if (FirebaseService.isInitialized) {
      await FirebaseService.addOrUpdateExperience(exp);
    }
  }

  Future<void> deleteExperience(String id) async {
    _experiences.removeWhere((e) => e.id == id);
    notifyListeners();
    if (FirebaseService.isInitialized) {
      await FirebaseService.deleteExperience(id);
    }
  }

  // --- Services CRUD ---
  Future<void> saveService(ServiceModel service) async {
    final index = _services.indexWhere((s) => s.id == service.id);
    if (index >= 0) {
      _services[index] = service;
    } else {
      _services.add(service);
    }
    notifyListeners();
    if (FirebaseService.isInitialized) {
      await FirebaseService.addOrUpdateService(service);
    }
  }

  Future<void> deleteService(String id) async {
    _services.removeWhere((s) => s.id == id);
    notifyListeners();
    if (FirebaseService.isInitialized) {
      await FirebaseService.deleteService(id);
    }
  }

  // --- Testimonials CRUD ---
  Future<void> saveTestimonial(TestimonialModel item) async {
    final index = _testimonials.indexWhere((t) => t.id == item.id);
    if (index >= 0) {
      _testimonials[index] = item;
    } else {
      _testimonials.add(item);
    }
    notifyListeners();
    if (FirebaseService.isInitialized) {
      await FirebaseService.addOrUpdateTestimonial(item);
    }
  }

  Future<void> deleteTestimonial(String id) async {
    _testimonials.removeWhere((t) => t.id == id);
    notifyListeners();
    if (FirebaseService.isInitialized) {
      await FirebaseService.deleteTestimonial(id);
    }
  }

  // --- Contact Messages ---
  Future<void> sendContactMessage(ContactMessageModel message) async {
    _messages.insert(0, message);
    notifyListeners();
    if (FirebaseService.isInitialized) {
      await FirebaseService.sendMessage(message);
    }
  }

  Future<void> markMessageRead(String id) async {
    final index = _messages.indexWhere((m) => m.id == id);
    if (index >= 0) {
      _messages[index] = ContactMessageModel(
        id: _messages[index].id,
        name: _messages[index].name,
        email: _messages[index].email,
        subject: _messages[index].subject,
        message: _messages[index].message,
        timestamp: _messages[index].timestamp,
        read: true,
      );
      notifyListeners();
      if (FirebaseService.isInitialized) {
        await FirebaseService.markMessageRead(id);
      }
    }
  }

  Future<void> deleteMessage(String id) async {
    _messages.removeWhere((m) => m.id == id);
    notifyListeners();
    if (FirebaseService.isInitialized) {
      await FirebaseService.deleteMessage(id);
    }
  }
}
