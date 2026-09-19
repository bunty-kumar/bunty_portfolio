import '../models/portfolio_models.dart';

class DefaultPortfolioData {
  static ThemeConfigModel get theme => ThemeConfigModel.defaultConfig();
  static BrandingModel get branding => BrandingModel.defaultData();
  static HeroModel get hero => HeroModel.defaultData();
  static AboutModel get about => AboutModel.defaultData();
  static SocialsModel get socials => SocialsModel.defaultData();

  static List<ProjectModel> get projects => [];
  static List<SkillModel> get skills => [];
  static List<ExperienceModel> get experiences => [];
  static List<ServiceModel> get services => [];
  static List<TestimonialModel> get testimonials => [];
}
