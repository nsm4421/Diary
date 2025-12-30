enum Assets {
  lightAppLogoSvg('assets/svg/light_app_logo.svg'),
  darkAppLogoSvg('assets/svg/dark_app_logo.svg'),
  lightSplashLogoSvg('assets/svg/light_splash_logo.svg'),
  darkSplashLogoSvg('assets/svg/dark_splash_logo.svg');

  final String path;

  const Assets(this.path);
}
