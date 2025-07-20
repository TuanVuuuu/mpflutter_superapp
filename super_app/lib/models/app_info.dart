class AppInfo {
  final String name;
  final String description;
  final String mpkPath;
  final String iconPath;

  const AppInfo({
    required this.name,
    required this.description,
    required this.mpkPath,
    this.iconPath = '',
  });
}
