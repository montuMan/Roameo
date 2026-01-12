import '../models/game_models.dart';

class VegasLocations {
  static List<VegasLocation> getDefaultLocations() {
    return [
      // BARS
      VegasLocation(
        id: 'bobs_bar',
        name: 'Bob\'s Bar',
        description: 'Popular bar and hangout spot in Indiranagar',
        x: 0.5,
        y: 0.5,
        points: 200,
        iconPath: '🍺',
        type: LocationType.restaurant,
      ),
      VegasLocation(
        id: 'toit',
        name: 'Toit Brewpub',
        description: 'Famous microbrewery with craft beers',
        x: 0.52,
        y: 0.48,
        points: 180,
        iconPath: '🍻',
        type: LocationType.restaurant,
      ),
      VegasLocation(
        id: 'permit_room',
        name: 'The Permit Room',
        description: 'Cocktail bar with innovative drinks',
        x: 0.48,
        y: 0.52,
        points: 170,
        iconPath: '🍸',
        type: LocationType.restaurant,
      ),
      
      // RESTAURANTS
      VegasLocation(
        id: 'smoke_house',
        name: 'Smoke House Deli',
        description: 'European bistro with great food',
        x: 0.6,
        y: 0.55,
        points: 160,
        iconPath: '🍽️',
        type: LocationType.restaurant,
      ),
      VegasLocation(
        id: 'truffles',
        name: 'Truffles',
        description: 'American diner famous for burgers',
        x: 0.55,
        y: 0.6,
        points: 150,
        iconPath: '🍔',
        type: LocationType.restaurant,
      ),
      VegasLocation(
        id: 'fatty_bao',
        name: 'Fatty Bao',
        description: 'Asian cuisine and dim sum',
        x: 0.65,
        y: 0.5,
        points: 165,
        iconPath: '🥟',
        type: LocationType.restaurant,
      ),
      VegasLocation(
        id: 'social',
        name: 'Social',
        description: 'Co-working cafe with food and drinks',
        x: 0.47,
        y: 0.48,
        points: 155,
        iconPath: '🍴',
        type: LocationType.restaurant,
      ),
      
      // CAFES
      VegasLocation(
        id: 'third_wave',
        name: 'Third Wave Coffee',
        description: 'Specialty coffee roasters',
        x: 0.58,
        y: 0.57,
        points: 140,
        iconPath: '☕',
        type: LocationType.restaurant,
      ),
      VegasLocation(
        id: 'ccd',
        name: 'Cafe Coffee Day',
        description: 'Popular coffee chain',
        x: 0.42,
        y: 0.45,
        points: 120,
        iconPath: '☕',
        type: LocationType.restaurant,
      ),
      VegasLocation(
        id: 'starbucks',
        name: 'Starbucks',
        description: 'International coffee house',
        x: 0.68,
        y: 0.58,
        points: 130,
        iconPath: '☕',
        type: LocationType.restaurant,
      ),
      
      // HOTELS
      VegasLocation(
        id: 'lemon_tree',
        name: 'Lemon Tree Hotel',
        description: 'Modern hotel with amenities',
        x: 0.7,
        y: 0.45,
        points: 190,
        iconPath: '🏨',
        type: LocationType.hotel,
      ),
      VegasLocation(
        id: 'the_den',
        name: 'The Den',
        description: 'Boutique hotel in Indiranagar',
        x: 0.38,
        y: 0.65,
        points: 175,
        iconPath: '🏨',
        type: LocationType.hotel,
      ),
    ];
  }
}