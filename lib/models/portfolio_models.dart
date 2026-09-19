import 'package:flutter/material.dart';
import '../utils/hex_color.dart';

class ThemeConfigModel {
  final String primaryHex;
  final String secondaryHex;
  final String bgHex;
  final String surfaceHex;
  final String cardHex;
  final String textHex;
  final String fontFamily;
  final bool isDarkMode;

  ThemeConfigModel({
    required this.primaryHex,
    required this.secondaryHex,
    required this.bgHex,
    required this.surfaceHex,
    required this.cardHex,
    required this.textHex,
    required this.fontFamily,
    required this.isDarkMode,
  });

  Color get primaryColor => HexColor.fromHex(primaryHex, fallback: const Color(0xFF6366F1));
  Color get secondaryColor => HexColor.fromHex(secondaryHex, fallback: const Color(0xFFEC4899));
  Color get bgColor => HexColor.fromHex(bgHex, fallback: const Color(0xFF0F172A));
  Color get surfaceColor => HexColor.fromHex(surfaceHex, fallback: const Color(0xFF1E293B));
  Color get cardColor => HexColor.fromHex(cardHex, fallback: const Color(0x331E293B));
  Color get textColor => HexColor.fromHex(textHex, fallback: const Color(0xFFF8FAFC));

  factory ThemeConfigModel.defaultConfig() {
    return ThemeConfigModel(
      primaryHex: '#6366F1',
      secondaryHex: '#EC4899',
      bgHex: '#0B0F17',
      surfaceHex: '#151C2C',
      cardHex: '#1E293B',
      textHex: '#F8FAFC',
      fontFamily: 'Inter',
      isDarkMode: true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'primaryHex': primaryHex,
      'secondaryHex': secondaryHex,
      'bgHex': bgHex,
      'surfaceHex': surfaceHex,
      'cardHex': cardHex,
      'textHex': textHex,
      'fontFamily': fontFamily,
      'isDarkMode': isDarkMode,
    };
  }

  factory ThemeConfigModel.fromMap(Map<String, dynamic> map) {
    return ThemeConfigModel(
      primaryHex: map['primaryHex'] ?? '#6366F1',
      secondaryHex: map['secondaryHex'] ?? '#EC4899',
      bgHex: map['bgHex'] ?? '#0B0F17',
      surfaceHex: map['surfaceHex'] ?? '#151C2C',
      cardHex: map['cardHex'] ?? '#1E293B',
      textHex: map['textHex'] ?? '#F8FAFC',
      fontFamily: map['fontFamily'] ?? 'Inter',
      isDarkMode: map['isDarkMode'] ?? true,
    );
  }

  ThemeConfigModel copyWith({
    String? primaryHex,
    String? secondaryHex,
    String? bgHex,
    String? surfaceHex,
    String? cardHex,
    String? textHex,
    String? fontFamily,
    bool? isDarkMode,
  }) {
    return ThemeConfigModel(
      primaryHex: primaryHex ?? this.primaryHex,
      secondaryHex: secondaryHex ?? this.secondaryHex,
      bgHex: bgHex ?? this.bgHex,
      surfaceHex: surfaceHex ?? this.surfaceHex,
      cardHex: cardHex ?? this.cardHex,
      textHex: textHex ?? this.textHex,
      fontFamily: fontFamily ?? this.fontFamily,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

class BrandingModel {
  final String siteTitle;
  final String subtitle;
  final String logoUrl;
  final String resumeUrl;

  BrandingModel({
    required this.siteTitle,
    required this.subtitle,
    required this.logoUrl,
    required this.resumeUrl,
  });

  factory BrandingModel.defaultData() {
    return BrandingModel(
      siteTitle: 'BUNTY KUMAR',
      subtitle: 'Senior Flutter Developer',
      logoUrl: '',
      resumeUrl: 'https://drive.google.com/file/d/12RPgLlfqfz_Eyi5XD8PMi6sJFXtDqzh0/view?usp=sharing',
    );
  }

  Map<String, dynamic> toMap() => {
        'siteTitle': siteTitle,
        'subtitle': subtitle,
        'logoUrl': logoUrl,
        'resumeUrl': resumeUrl,
      };

  factory BrandingModel.fromMap(Map<String, dynamic> map) {
    return BrandingModel(
      siteTitle: map['siteTitle'] ?? 'BUNTY KUMAR',
      subtitle: map['subtitle'] ?? 'Senior Flutter Developer',
      logoUrl: map['logoUrl'] ?? '',
      resumeUrl: map['resumeUrl'] ?? 'https://drive.google.com/file/d/12RPgLlfqfz_Eyi5XD8PMi6sJFXtDqzh0/view?usp=sharing',
    );
  }
}

class HeroModel {
  final String greeting;
  final String name;
  final List<String> roles;
  final String bio;
  final String profileImageUrl;
  final String badgeText;
  final String primaryCtaText;
  final String secondaryCtaText;

  HeroModel({
    required this.greeting,
    required this.name,
    required this.roles,
    required this.bio,
    required this.profileImageUrl,
    required this.badgeText,
    required this.primaryCtaText,
    required this.secondaryCtaText,
  });

  factory HeroModel.defaultData() {
    return HeroModel(
      greeting: "Hello, I'm",
      name: "Bunty Kumar",
      roles: [
        "Senior Flutter Developer",
        "Flutter Architect",
        "Fintech & HRMS Specialist",
        "Clean Architecture Expert"
      ],
      bio: "Senior Flutter Developer with 4.5+ years of experience building scalable fintech, HRMS, and ERP applications across mobile and web. Specialized in Clean Architecture, BLoC, and multi-tenant systems serving 100K+ users and 150+ deployments.",
      profileImageUrl: "https://raw.githubusercontent.com/bunty-kumar/bunty_portfolio/main/assets/images/profile.png",
      badgeText: "Available for Senior Flutter Roles / Full Time / Remote",
      primaryCtaText: "Explore My Work",
      secondaryCtaText: "Get In Touch",
    );
  }

  Map<String, dynamic> toMap() => {
        'greeting': greeting,
        'name': name,
        'roles': roles,
        'bio': bio,
        'profileImageUrl': profileImageUrl,
        'badgeText': badgeText,
        'primaryCtaText': primaryCtaText,
        'secondaryCtaText': secondaryCtaText,
      };

  factory HeroModel.fromMap(Map<String, dynamic> map) {
    return HeroModel(
      greeting: map['greeting'] ?? "Hello, I'm",
      name: map['name'] ?? "Bunty Kumar",
      roles: List<String>.from(map['roles'] ?? ["Senior Flutter Developer", "Flutter Architect"]),
      bio: map['bio'] ?? "Senior Flutter Developer with 4.5+ years of experience building scalable fintech, HRMS, and ERP applications.",
      profileImageUrl: map['profileImageUrl'] ?? "",
      badgeText: map['badgeText'] ?? "Available for Senior Flutter Roles / Full Time / Remote",
      primaryCtaText: map['primaryCtaText'] ?? "Explore My Work",
      secondaryCtaText: map['secondaryCtaText'] ?? "Get In Touch",
    );
  }
}

class AboutModel {
  final String story;
  final int yearsExperience;
  final int projectsCompleted;
  final int happyClients;
  final int awardsCount;

  AboutModel({
    required this.story,
    required this.yearsExperience,
    required this.projectsCompleted,
    required this.happyClients,
    required this.awardsCount,
  });

  factory AboutModel.defaultData() {
    return AboutModel(
      story: "Senior Flutter Developer with 4.5+ years of experience engineering high-performance mobile and web applications. Proven track record in designing multi-tenant architectures, building complex HRMS and fintech payment systems with 150+ bank app deployments, and maintaining production apps serving over 100K+ active users.",
      yearsExperience: 5,
      projectsCompleted: 150,
      happyClients: 25,
      awardsCount: 10,
    );
  }

  Map<String, dynamic> toMap() => {
        'story': story,
        'yearsExperience': yearsExperience,
        'projectsCompleted': projectsCompleted,
        'happyClients': happyClients,
        'awardsCount': awardsCount,
      };

  factory AboutModel.fromMap(Map<String, dynamic> map) {
    return AboutModel(
      story: map['story'] ?? "",
      yearsExperience: map['yearsExperience'] ?? 5,
      projectsCompleted: map['projectsCompleted'] ?? 150,
      happyClients: map['happyClients'] ?? 25,
      awardsCount: map['awardsCount'] ?? 10,
    );
  }
}

class SocialsModel {
  final String github;
  final String linkedin;
  final String twitter;
  final String instagram;
  final String email;
  final String phone;
  final String location;

  SocialsModel({
    required this.github,
    required this.linkedin,
    required this.twitter,
    required this.instagram,
    required this.email,
    required this.phone,
    required this.location,
  });

  factory SocialsModel.defaultData() {
    return SocialsModel(
      github: "https://github.com/bunty-kumar",
      linkedin: "https://linkedin.com/in/bunty-kumar",
      twitter: "",
      instagram: "",
      email: "bunty.k.dev@gmail.com",
      phone: "+91-8058775532",
      location: "Patna, India",
    );
  }

  Map<String, dynamic> toMap() => {
        'github': github,
        'linkedin': linkedin,
        'twitter': twitter,
        'instagram': instagram,
        'email': email,
        'phone': phone,
        'location': location,
      };

  factory SocialsModel.fromMap(Map<String, dynamic> map) {
    return SocialsModel(
      github: map['github'] ?? "",
      linkedin: map['linkedin'] ?? "",
      twitter: map['twitter'] ?? "",
      instagram: map['instagram'] ?? "",
      email: map['email'] ?? "",
      phone: map['phone'] ?? "",
      location: map['location'] ?? "",
    );
  }
}

class ProjectModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final String imageUrl;
  final List<String> tags;
  final String liveUrl;
  final String githubUrl;
  final bool featured;
  final int order;

  ProjectModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.tags,
    required this.liveUrl,
    required this.githubUrl,
    required this.featured,
    required this.order,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'category': category,
        'description': description,
        'imageUrl': imageUrl,
        'tags': tags,
        'liveUrl': liveUrl,
        'githubUrl': githubUrl,
        'featured': featured,
        'order': order,
      };

  factory ProjectModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProjectModel(
      id: docId,
      title: map['title'] ?? '',
      category: map['category'] ?? 'Mobile App',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      liveUrl: map['liveUrl'] ?? '',
      githubUrl: map['githubUrl'] ?? '',
      featured: map['featured'] ?? false,
      order: map['order'] ?? 0,
    );
  }
}

class SkillModel {
  final String id;
  final String name;
  final String category; // e.g. Mobile, Frontend, Backend, Cloud & DevOps
  final int proficiency; // 0-100
  final String iconName;
  final String colorHex;
  final int order;

  SkillModel({
    required this.id,
    required this.name,
    required this.category,
    required this.proficiency,
    required this.iconName,
    required this.colorHex,
    required this.order,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'proficiency': proficiency,
        'iconName': iconName,
        'colorHex': colorHex,
        'order': order,
      };

  factory SkillModel.fromMap(Map<String, dynamic> map, String docId) {
    return SkillModel(
      id: docId,
      name: map['name'] ?? '',
      category: map['category'] ?? 'General',
      proficiency: map['proficiency'] ?? 80,
      iconName: map['iconName'] ?? 'code',
      colorHex: map['colorHex'] ?? '#6366F1',
      order: map['order'] ?? 0,
    );
  }
}

class ExperienceModel {
  final String id;
  final String role;
  final String company;
  final String companyLogoUrl;
  final String period;
  final String description;
  final List<String> bulletPoints;
  final int order;

  ExperienceModel({
    required this.id,
    required this.role,
    required this.company,
    required this.companyLogoUrl,
    required this.period,
    required this.description,
    required this.bulletPoints,
    required this.order,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'role': role,
        'company': company,
        'companyLogoUrl': companyLogoUrl,
        'period': period,
        'description': description,
        'bulletPoints': bulletPoints,
        'order': order,
      };

  factory ExperienceModel.fromMap(Map<String, dynamic> map, String docId) {
    return ExperienceModel(
      id: docId,
      role: map['role'] ?? '',
      company: map['company'] ?? '',
      companyLogoUrl: map['companyLogoUrl'] ?? '',
      period: map['period'] ?? '',
      description: map['description'] ?? '',
      bulletPoints: List<String>.from(map['bulletPoints'] ?? []),
      order: map['order'] ?? 0,
    );
  }
}

class ServiceModel {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final int order;

  ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.order,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'iconName': iconName,
        'order': order,
      };

  factory ServiceModel.fromMap(Map<String, dynamic> map, String docId) {
    return ServiceModel(
      id: docId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      iconName: map['iconName'] ?? 'star',
      order: map['order'] ?? 0,
    );
  }
}

class TestimonialModel {
  final String id;
  final String name;
  final String role;
  final String company;
  final String avatarUrl;
  final String content;
  final int rating;
  final int order;

  TestimonialModel({
    required this.id,
    required this.name,
    required this.role,
    required this.company,
    required this.avatarUrl,
    required this.content,
    required this.rating,
    required this.order,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'role': role,
        'company': company,
        'avatarUrl': avatarUrl,
        'content': content,
        'rating': rating,
        'order': order,
      };

  factory TestimonialModel.fromMap(Map<String, dynamic> map, String docId) {
    return TestimonialModel(
      id: docId,
      name: map['name'] ?? '',
      role: map['role'] ?? '',
      company: map['company'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      content: map['content'] ?? '',
      rating: map['rating'] ?? 5,
      order: map['order'] ?? 0,
    );
  }
}

class ContactMessageModel {
  final String id;
  final String name;
  final String email;
  final String subject;
  final String message;
  final DateTime timestamp;
  final bool read;

  ContactMessageModel({
    required this.id,
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.timestamp,
    required this.read,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'subject': subject,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
        'read': read,
      };

  factory ContactMessageModel.fromMap(Map<String, dynamic> map, String docId) {
    return ContactMessageModel(
      id: docId,
      name: map['name'] ?? 'Anonymous',
      email: map['email'] ?? '',
      subject: map['subject'] ?? 'No Subject',
      message: map['message'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      read: map['read'] ?? false,
    );
  }
}
