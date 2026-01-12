import 'dart:math';
import '../models/game_models.dart';
import '../data/vegas_locations.dart';

class GameEngine {
  static final GameEngine _instance = GameEngine._internal();
  factory GameEngine() => _instance;
  GameEngine._internal();

  late GameData _gameData;
  late Player _player;
  late List<VegasLocation> _locations;

  GameData get gameData => _gameData;
  Player get player => _player;
  List<VegasLocation> get locations => _locations;

  void initializeGame() {
    _gameData = GameData();
    _player = Player();
    _locations = VegasLocations.getDefaultLocations();
    
    // Make the starting area locations discoverable
    _discoverNearbyLocations();
  }

  void movePlayer(double newX, double newY) {
    // Calculate energy cost based on distance
    double distance = _calculateDistance(_player.currentX, _player.currentY, newX, newY);
    int energyCost = (distance * 100).round();
    
    if (_player.energy >= energyCost) {
      _player.currentX = newX;
      _player.currentY = newY;
      _player.energy = max(0, _player.energy - energyCost);
      
      _discoverNearbyLocations();
      _checkLocationVisits();
    }
  }

  bool visitLocation(String locationId) {
    VegasLocation? location = _locations.firstWhere(
      (loc) => loc.id == locationId,
      orElse: () => throw Exception('Location not found'),
    );

    if (!location.isVisited && _isPlayerNearLocation(location)) {
      location.isVisited = true;
      _gameData.totalScore += location.points;
      _gameData.locationsVisited++;
      
      // Restore some energy when visiting locations
      _player.energy = min(_player.maxEnergy, _player.energy + 20);
      
      _checkAchievements();
      return true;
    }
    return false;
  }

  void _discoverNearbyLocations() {
    for (var location in _locations) {
      if (!location.isDiscovered) {
        double distance = _calculateDistance(
          _player.currentX, 
          _player.currentY, 
          location.x, 
          location.y
        );
        
        if (distance <= 0.15) { // Discovery radius
          location.isDiscovered = true;
          _gameData.locationsDiscovered++;
        }
      }
    }
  }

  void _checkLocationVisits() {
    for (var location in _locations) {
      if (location.isDiscovered && !location.isVisited) {
        if (_isPlayerNearLocation(location)) {
          // Player is close enough to visit
          continue;
        }
      }
    }
  }

  bool _isPlayerNearLocation(VegasLocation location) {
    double distance = _calculateDistance(
      _player.currentX, 
      _player.currentY, 
      location.x, 
      location.y
    );
    return distance <= 0.05; // Visit radius
  }

  double _calculateDistance(double x1, double y1, double x2, double y2) {
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  }

  void _checkAchievements() {
    // First Location Achievement
    if (_gameData.locationsVisited == 1 && 
        !_gameData.achievementsUnlocked.contains('first_visit')) {
      _gameData.achievementsUnlocked.add('first_visit');
    }
    
    // Explorer Achievement
    if (_gameData.locationsVisited >= 5 && 
        !_gameData.achievementsUnlocked.contains('explorer')) {
      _gameData.achievementsUnlocked.add('explorer');
    }
    
    // Vegas Master Achievement
    if (_gameData.locationsVisited >= 10 && 
        !_gameData.achievementsUnlocked.contains('vegas_master')) {
      _gameData.achievementsUnlocked.add('vegas_master');
    }

    // High Roller Achievement (visit high roller specifically)
    if (_locations.any((loc) => loc.id == 'high_roller' && loc.isVisited) &&
        !_gameData.achievementsUnlocked.contains('high_roller')) {
      _gameData.achievementsUnlocked.add('high_roller');
    }
  }

  void restoreEnergy() {
    _player.energy = _player.maxEnergy;
  }

  String getLocationInfo(String locationId) {
    VegasLocation location = _locations.firstWhere((loc) => loc.id == locationId);
    return '''
${location.name}
${location.description}
Points: ${location.points}
${location.isVisited ? '✅ Visited' : location.isDiscovered ? '👁️ Discovered' : '❓ Unknown'}
''';
  }
}