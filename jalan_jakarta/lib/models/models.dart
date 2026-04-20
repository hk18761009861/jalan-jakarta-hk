// ─── Place Model ───────────────────────────────────────────────────────────
class Place {
  final String id;
  final String name;
  final String category;
  final String subcategory;
  final String address;
  final String district;
  final double latitude;
  final double longitude;
  final double rating;
  final int reviewCount;
  final String priceRange;
  final String openHours;
  final bool isOpen;
  final bool isFeatured;
  final bool isNew;
  final String imageUrl;
  final List<String> images;
  final String phone;
  final String description;
  final List<String> tags;
  final double distanceKm;
  final List<Review> reviews;
  final List<String> amenities;

  const Place({
    required this.id,
    required this.name,
    required this.category,
    required this.subcategory,
    required this.address,
    required this.district,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviewCount,
    required this.priceRange,
    required this.openHours,
    required this.isOpen,
    this.isFeatured = false,
    this.isNew = false,
    required this.imageUrl,
    this.images = const [],
    required this.phone,
    required this.description,
    this.tags = const [],
    this.distanceKm = 0.0,
    this.reviews = const [],
    this.amenities = const [],
  });

  Place copyWith({double? distanceKm}) {
    return Place(
      id: id, name: name, category: category, subcategory: subcategory,
      address: address, district: district, latitude: latitude,
      longitude: longitude, rating: rating, reviewCount: reviewCount,
      priceRange: priceRange, openHours: openHours, isOpen: isOpen,
      isFeatured: isFeatured, isNew: isNew, imageUrl: imageUrl,
      images: images, phone: phone, description: description,
      tags: tags, distanceKm: distanceKm ?? this.distanceKm,
      reviews: reviews, amenities: amenities,
    );
  }
}

// ─── Category Model ─────────────────────────────────────────────────────────
class Category {
  final String id;
  final String name;
  final String nameId;
  final String emoji;
  final int colorValue;

  const Category({
    required this.id,
    required this.name,
    required this.nameId,
    required this.emoji,
    required this.colorValue,
  });
}

// ─── Review Model ───────────────────────────────────────────────────────────
class Review {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final DateTime date;
  final List<String> images;
  final int helpfulCount;

  const Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.date,
    this.images = const [],
    this.helpfulCount = 0,
  });
}

// ─── Event Model ────────────────────────────────────────────────────────────
class Event {
  final String id;
  final String title;
  final String description;
  final String location;
  final String district;
  final DateTime startDate;
  final DateTime endDate;
  final String imageUrl;
  final String category;
  final String priceRange;
  final bool isFree;
  final int interestedCount;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.district,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
    required this.category,
    required this.priceRange,
    this.isFree = false,
    this.interestedCount = 0,
  });
}

// ─── Booking Model ──────────────────────────────────────────────────────────
class Booking {
  final String id;
  final String placeId;
  final String placeName;
  final String placeImage;
  final DateTime date;
  final String time;
  final int guests;
  final String status; // pending, confirmed, completed, cancelled
  final String notes;
  final double totalPrice;

  const Booking({
    required this.id,
    required this.placeId,
    required this.placeName,
    required this.placeImage,
    required this.date,
    required this.time,
    required this.guests,
    required this.status,
    this.notes = '',
    required this.totalPrice,
  });
}

// ─── User Model ─────────────────────────────────────────────────────────────
class AppUser {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final List<String> savedPlaceIds;
  final List<Booking> bookings;
  final int reviewCount;
  final String memberSince;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.savedPlaceIds = const [],
    this.bookings = const [],
    this.reviewCount = 0,
    required this.memberSince,
  });
}
