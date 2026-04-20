import 'package:flutter/foundation.dart';
import '../models/models.dart';
import 'data_service.dart';

class AppState extends ChangeNotifier {
  // ── Navigation ──────────────────────────────────────────────────
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // ── Category Filter ─────────────────────────────────────────────
  String _selectedCategory = 'all';
  String get selectedCategory => _selectedCategory;

  void setCategory(String cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  // ── Search ──────────────────────────────────────────────────────
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void setSearch(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  List<Place> get searchResults => DataService.search(_searchQuery);

  // ── Places ──────────────────────────────────────────────────────
  List<Place> get allPlaces => DataService.places;
  List<Place> get featuredPlaces => DataService.getFeatured();
  List<Place> get newPlaces => DataService.getNew();

  List<Place> get filteredPlaces {
    if (_selectedCategory == 'all') return DataService.places;
    return DataService.getByCategory(_selectedCategory);
  }

  // ── Saved / Bookmarks ───────────────────────────────────────────
  final Set<String> _savedIds = {};

  bool isSaved(String placeId) => _savedIds.contains(placeId);

  void toggleSave(String placeId) {
    if (_savedIds.contains(placeId)) {
      _savedIds.remove(placeId);
    } else {
      _savedIds.add(placeId);
    }
    notifyListeners();
  }

  List<Place> get savedPlaces =>
      DataService.places.where((p) => _savedIds.contains(p.id)).toList();

  // ── Bookings ────────────────────────────────────────────────────
  final List<Booking> _bookings = [];
  List<Booking> get bookings => _bookings;

  void addBooking(Booking booking) {
    _bookings.add(booking);
    notifyListeners();
  }

  void cancelBooking(String bookingId) {
    final idx = _bookings.indexWhere((b) => b.id == bookingId);
    if (idx != -1) {
      _bookings[idx] = Booking(
        id: _bookings[idx].id,
        placeId: _bookings[idx].placeId,
        placeName: _bookings[idx].placeName,
        placeImage: _bookings[idx].placeImage,
        date: _bookings[idx].date,
        time: _bookings[idx].time,
        guests: _bookings[idx].guests,
        status: 'cancelled',
        notes: _bookings[idx].notes,
        totalPrice: _bookings[idx].totalPrice,
      );
      notifyListeners();
    }
  }

  // ── User ────────────────────────────────────────────────────────
  final AppUser currentUser = const AppUser(
    id: 'u_me',
    name: 'Alex Wijaya',
    email: 'alex.wijaya@email.com',
    avatarUrl: 'https://i.pravatar.cc/200?img=12',
    memberSince: 'Januari 2024',
    reviewCount: 14,
  );

  // ── Events ──────────────────────────────────────────────────────
  List<Event> get events => DataService.events;

  final Set<String> _interestedEvents = {};
  bool isInterested(String eventId) => _interestedEvents.contains(eventId);
  void toggleInterest(String eventId) {
    if (_interestedEvents.contains(eventId)) {
      _interestedEvents.remove(eventId);
    } else {
      _interestedEvents.add(eventId);
    }
    notifyListeners();
  }
}
