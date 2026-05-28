class Game {
  final String? id;
  final String name;
  final String genre;
  final double price;

  Game({
    this.id,
    required this.name,
    required this.genre,
    required this.price,
  });

  // Factory constructor to create a Game from a map (Firestore document)
  // This now uses the Spanish field names from your database.
  factory Game.fromMap(Map<String, dynamic> map, String id) {
    return Game(
      id: id,
      name: map['Nombre'] as String, // Was 'name'
      genre: map['Genero'] as String, // Was 'genre'
      price: (map['Precio'] as num).toDouble(), // Was 'price'
    );
  }

  // Method to convert a Game object to a map for Firestore
  // This now writes the Spanish field names to your database.
  Map<String, dynamic> toMap() {
    return {
      'Nombre': name, // Was 'name'
      'Genero': genre, // Was 'genre'
      'Precio': price, // Was 'price'
    };
  }
}
