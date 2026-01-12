class VegasLocation {
  final String id;
  final String name;
  final String description;
  final double x; // Map coordinate
  final double y; // Map coordinate
  final int points;
  final String iconPath;
  final LocationType type;
  bool isDiscovered;
  bool isVisited;

  VegasLocation({
    required this.id,
    required this.name,
    required this.description,
    required this.x,
    required this.y,
    required this.points,
    required this.iconPath,
    required this.type,
    this.isDiscovered = false,
    this.isVisited = false,
  });
}

enum LocationType {
  casino,
  hotel,
  restaurant,
  entertainment,
  shopping,
  landmark,
}

class GameData {
  int totalScore;
  int locationsVisited;
  int locationsDiscovered;
  DateTime gameStartTime;
  Duration totalPlayTime;
  List<String> achievementsUnlocked;

  GameData({
    this.totalScore = 0,
    this.locationsVisited = 0,
    this.locationsDiscovered = 0,
    DateTime? gameStartTime,
    this.totalPlayTime = const Duration(),
    List<String>? achievementsUnlocked,
  }) : gameStartTime = gameStartTime ?? DateTime.now(),
       achievementsUnlocked = achievementsUnlocked ?? [];
}

class Player {
  final String name;
  double currentX;
  double currentY;
  int energy;
  final int maxEnergy;

  Player({
    this.name = "Explorer",
    this.currentX = 0.5, // Center of map
    this.currentY = 0.5,
    this.energy = 100,
    this.maxEnergy = 100,
  });
}