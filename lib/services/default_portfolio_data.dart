import '../models/portfolio_models.dart';

class DefaultPortfolioData {
  static ThemeConfigModel get theme => ThemeConfigModel.defaultConfig();
  static BrandingModel get branding => BrandingModel.defaultData();
  static HeroModel get hero => HeroModel.defaultData();
  static AboutModel get about => AboutModel.defaultData();
  static SocialsModel get socials => SocialsModel.defaultData();

  static List<ProjectModel> get projects => [
        ProjectModel(
          id: 'proj_1',
          title: 'QuantumPay - Crypto Wallet App',
          category: 'Flutter App',
          description: 'A futuristic decentralized Web3 crypto wallet with real-time portfolio tracking, biometric authentication, and multi-chain swap.',
          imageUrl: 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?auto=format&fit=crop&w=1200&q=80',
          tags: ['Flutter', 'Dart', 'Web3.dart', 'Firebase', 'Bloc'],
          liveUrl: 'https://example.com/quantumpay',
          githubUrl: 'https://github.com/example/quantumpay',
          featured: true,
          order: 1,
        ),
        ProjectModel(
          id: 'proj_2',
          title: 'Aura - AI Health & Fitness Assistant',
          category: 'Mobile & AI',
          description: 'Cross-platform AI assistant monitoring daily activity, meal nutrition via computer vision, and workout analytics.',
          imageUrl: 'https://images.unsplash.com/photo-1576678927484-cc909957088c?auto=format&fit=crop&w=1200&q=80',
          tags: ['Flutter Web', 'OpenAI API', 'Firebase Firestore', 'Riverpod'],
          liveUrl: 'https://example.com/aura-health',
          githubUrl: 'https://github.com/example/aura-health',
          featured: true,
          order: 2,
        ),
        ProjectModel(
          id: 'proj_3',
          title: 'Nexus - Real-time Team Collaboration Suite',
          category: 'Web Application',
          description: 'Ultra-fast web platform featuring canvas whiteboard, voice channels, markdown documentation, and kanban boards.',
          imageUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&w=1200&q=80',
          tags: ['React', 'Node.js', 'Socket.io', 'Tailwind', 'Cloudinary'],
          liveUrl: 'https://example.com/nexus-app',
          githubUrl: 'https://github.com/example/nexus-app',
          featured: true,
          order: 3,
        ),
        ProjectModel(
          id: 'proj_4',
          title: 'Zenith - E-Commerce Storefront',
          category: 'Flutter Web',
          description: 'High-performance e-commerce platform with dynamic light/dark dynamic theme engine, instant search, and Stripe payment gateway.',
          imageUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=1200&q=80',
          tags: ['Flutter Web', 'Stripe API', 'Cloudinary', 'Firebase'],
          liveUrl: 'https://example.com/zenith-store',
          githubUrl: 'https://github.com/example/zenith-store',
          featured: false,
          order: 4,
        ),
      ];

  static List<SkillModel> get skills => [
        SkillModel(id: 'sk_1', name: 'Flutter & Dart', category: 'Mobile & Web', proficiency: 95, iconName: 'phone_android', colorHex: '#02569B', order: 1),
        SkillModel(id: 'sk_2', name: 'Firebase & Firestore', category: 'Backend & Cloud', proficiency: 90, iconName: 'cloud', colorHex: '#FFCA28', order: 2),
        SkillModel(id: 'sk_3', name: 'React & Next.js', category: 'Frontend', proficiency: 88, iconName: 'code', colorHex: '#61DAFB', order: 3),
        SkillModel(id: 'sk_4', name: 'State Management (Bloc/Riverpod)', category: 'Architecture', proficiency: 92, iconName: 'account_tree', colorHex: '#EC4899', order: 4),
        SkillModel(id: 'sk_5', name: 'REST APIs & GraphQL', category: 'Backend & Cloud', proficiency: 85, iconName: 'api', colorHex: '#10B981', order: 5),
        SkillModel(id: 'sk_6', name: 'UI/UX & Framer/CustomPainter', category: 'Design', proficiency: 90, iconName: 'palette', colorHex: '#8B5CF6', order: 6),
      ];

  static List<ExperienceModel> get experiences => [
        ExperienceModel(
          id: 'exp_1',
          role: 'Lead Mobile & Web Architect',
          company: 'TechCorp Innovations',
          companyLogoUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=200&q=80',
          period: '2023 - Present',
          description: 'Architecting scalable cross-platform Flutter mobile applications and web dashboards for over 500,000 active users.',
          bulletPoints: [
            'Reduced app startup time by 40% using optimized tree-shaking and lazy rendering.',
            'Mentored a team of 8 developers and established automated CI/CD pipelines.',
            'Integrated real-time WebSockets and Firebase Firestore sync.'
          ],
          order: 1,
        ),
        ExperienceModel(
          id: 'exp_2',
          role: 'Senior Full Stack Developer',
          company: 'Apex Digital Labs',
          companyLogoUrl: 'https://images.unsplash.com/photo-1572021335469-31706a17aaef?auto=format&fit=crop&w=200&q=80',
          period: '2021 - 2023',
          description: 'Developed responsive web applications, cloud microservices, and dynamic CMS systems.',
          bulletPoints: [
            'Built custom Cloudinary image optimization pipelines resulting in 60% faster asset loading.',
            'Implemented secure multi-tenant Firebase authentication and rule systems.',
          ],
          order: 2,
        ),
      ];

  static List<ServiceModel> get services => [
        ServiceModel(
          id: 'srv_1',
          title: 'Cross-Platform Mobile Apps',
          description: 'High-performance Flutter iOS & Android apps with smooth 60fps animations and offline-first capabilities.',
          iconName: 'smartphone',
          order: 1,
        ),
        ServiceModel(
          id: 'srv_2',
          title: 'Dynamic Web Development',
          description: 'Fast, responsive web applications and portfolios powered by dynamic CMS and realtime data storage.',
          iconName: 'web',
          order: 2,
        ),
        ServiceModel(
          id: 'srv_3',
          title: 'Cloud & Firebase Architecture',
          description: 'Secure Firestore databases, serverless Cloud Functions, auth security rules, and real-time backend integration.',
          iconName: 'cloud_done',
          order: 3,
        ),
        ServiceModel(
          id: 'srv_4',
          title: 'UI/UX Design & Animation',
          description: 'Creating wow-factor user interfaces with vibrant glassmorphic design, custom shaders, and interactive micro-animations.',
          iconName: 'auto_awesome',
          order: 4,
        ),
      ];

  static List<TestimonialModel> get testimonials => [
        TestimonialModel(
          id: 'tst_1',
          name: 'Sarah Jenkins',
          role: 'CTO',
          company: 'FinPulse Systems',
          avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80',
          content: 'Bunty delivered our Flutter Web app ahead of schedule with breathtaking animations. His attention to detail and dynamic theme architecture is top tier!',
          rating: 5,
          order: 1,
        ),
        TestimonialModel(
          id: 'tst_2',
          name: 'David Miller',
          role: 'Product Director',
          company: 'CloudScale Inc',
          avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
          content: 'The admin CMS and Cloudinary upload workflow Bunty created made updating our portfolio content effortless. Highly recommended developer!',
          rating: 5,
          order: 2,
        ),
      ];
}
