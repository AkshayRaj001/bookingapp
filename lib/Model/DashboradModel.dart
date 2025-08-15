class Workspace {
  final String name;
  final String location;
  final String image;
  final String price;
  final double rating;
  final String? status;
  final String? date;
  final List<String>? avatars;

  Workspace({
    required this.name,
    required this.location,
    required this.image,
    required this.price,
    required this.rating,
    this.status,
    this.date,
    this.avatars,
  });
}
