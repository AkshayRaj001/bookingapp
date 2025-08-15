import 'package:bookingapp/view/viewLocation.dart';
import 'package:flutter/material.dart';

class SpaceDetailScreen extends StatelessWidget {
  final String name;
  final String location;
  final String image;
  final String price;
  final String rating;
  final List<Map<String, dynamic>> amenities;

  const SpaceDetailScreen({
    super.key,
    required this.name,
    required this.location,
    required this.image,
    required this.price,
    required this.rating,
    required this.amenities,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Image
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      child: Image.asset(
                        image,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      right: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),

                // Title & Price
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(name,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(price,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal)),
                ),

                // Location & Rating
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StaticLocationPage()),
                            );
                          },
                          child: _infoCard(
                              Icons.location_on, location, "Location"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _infoCard(Icons.star, rating, "Ratings"),
                      ),
                    ],
                  ),
                ),

                // Amenities Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("What this place offers",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: amenities.length,
                    itemBuilder: (context, index) {
                      final item = amenities[index];
                      return Container(
                        margin: const EdgeInsets.all(8),
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 4)
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(item["icon"], color: Colors.teal),
                            const SizedBox(height: 4),
                            Text(item["name"],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Description
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "This workspace offers a premium experience with modern facilities, perfect for productivity and relaxation.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),

          // Book Now Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.teal,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/booking");
                },
                child: const Text("Book Now",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          Text(label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
