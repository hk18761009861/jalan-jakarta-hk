import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../services/data_service.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import 'place_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  String _selectedCat = 'all';
  Place? _selectedPlace;

  static const _jakarta = CameraPosition(
    target: LatLng(-6.2088, 106.8456),
    zoom: 12,
  );

  Set<Marker> _buildMarkers(List<Place> places) {
    return places.map((p) {
      return Marker(
        markerId: MarkerId(p.id),
        position: LatLng(p.latitude, p.longitude),
        infoWindow: InfoWindow(title: p.name, snippet: p.subcategory),
        onTap: () => setState(() => _selectedPlace = p),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          p.category == 'food' ? BitmapDescriptor.hueRed :
          p.category == 'cafe' ? BitmapDescriptor.hueGreen :
          p.category == 'spa' ? BitmapDescriptor.hueViolet :
          p.category == 'shopping' ? BitmapDescriptor.hueBlue :
          BitmapDescriptor.hueOrange,
        ),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final places = _selectedCat == 'all' ? DataService.places : DataService.getByCategory(_selectedCat);

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: Stack(
        children: [
          // ── Map ────────────────────────────────────────────────────────────
          GoogleMap(
            initialCameraPosition: _jakarta,
            onMapCreated: (c) => _mapController = c,
            markers: _buildMarkers(places),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onTap: (_) => setState(() => _selectedPlace = null),
          ),

          // ── Top Bar ────────────────────────────────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 10, 16, 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.transparent],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 3))],
                          ),
                          child: const Row(
                            children: [
                              SizedBox(width: 12),
                              Icon(Icons.search, color: AppColors.textTertiary, size: 18),
                              SizedBox(width: 8),
                              Text('Cari di peta...', style: TextStyle(color: AppColors.textTertiary, fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10)],
                        ),
                        child: const Icon(Icons.my_location, color: AppColors.primary, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Category filter scroll
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _mapCatChip('all', '🏙️', 'Semua'),
                        ...DataService.categories.map((c) => _mapCatChip(c.id, c.emoji, c.name)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Place Bottom Card ──────────────────────────────────────────────
          if (_selectedPlace != null)
            Positioned(
              bottom: 20, left: 16, right: 16,
              child: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlaceDetailScreen(place: _selectedPlace!))),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 20, offset: const Offset(0, 5))],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(_selectedPlace!.imageUrl, width: 70, height: 70, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(width: 70, height: 70, color: AppColors.bgTertiary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(_selectedPlace!.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(_selectedPlace!.subcategory, style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.star_rounded, color: AppColors.accent, size: 13),
                          Text(' ${_selectedPlace!.rating}  ·  ${_selectedPlace!.distanceKm} km', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                        ]),
                      ])),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _mapCatChip(String id, String emoji, String label) {
    final isSel = _selectedCat == id;
    return GestureDetector(
      onTap: () => setState(() { _selectedCat = id; _selectedPlace = null; }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSel ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6)],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSel ? Colors.white : AppColors.textSecondary)),
        ]),
      ),
    );
  }
}
