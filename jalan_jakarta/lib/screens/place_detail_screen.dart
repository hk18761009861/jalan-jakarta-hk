import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

class PlaceDetailScreen extends StatefulWidget {
  final Place place;
  const PlaceDetailScreen({super.key, required this.place});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabs;
  int _selectedImage = 0;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final place = widget.place;

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Hero Image ─────────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: AppColors.bgPrimary,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () => state.toggleSave(place.id),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                      child: Icon(
                        state.isSaved(place.id) ? Icons.bookmark : Icons.bookmark_border,
                        color: state.isSaved(place.id) ? AppColors.primary : AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: place.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(color: AppColors.bgTertiary),
                        errorWidget: (_, __, ___) => Container(color: AppColors.bgTertiary),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Place Info ─────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  color: AppColors.bgPrimary,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(place.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                                const SizedBox(height: 4),
                                Text('${place.subcategory} · ${place.district}', style: const TextStyle(fontSize: 13, color: AppColors.textTertiary)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: place.isOpen ? const Color(0xFFEDF8E4) : const Color(0xFFFFF3F0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(place.isOpen ? '● Buka' : '● Tutup',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: place.isOpen ? AppColors.success : AppColors.error)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: AppColors.accent, size: 18),
                          const SizedBox(width: 4),
                          Text('${place.rating}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          Text(' (${place.reviewCount} ulasan)', style: const TextStyle(fontSize: 13, color: AppColors.textTertiary)),
                          const Spacer(),
                          const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textTertiary),
                          Text(' ${place.distanceKm} km', style: const TextStyle(fontSize: 13, color: AppColors.textTertiary)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Quick info row
                      Row(
                        children: [
                          _infoChip(Icons.access_time_outlined, place.openHours),
                          const SizedBox(width: 8),
                          _infoChip(Icons.payments_outlined, place.priceRange),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Tags
                      Wrap(
                        spacing: 8, runSpacing: 6,
                        children: place.tags.map((t) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.bgTertiary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(t, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        )).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // ── Tabs ───────────────────────────────────────────────────────
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  TabBar(
                    controller: _tabs,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textTertiary,
                    indicatorColor: AppColors.primary,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    tabs: const [Tab(text: 'Info'), Tab(text: 'Ulasan'), Tab(text: 'Fasilitas')],
                  ),
                ),
              ),

              // ── Tab Content ────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: AnimatedBuilder(
                  animation: _tabs,
                  builder: (ctx, _) {
                    return IndexedStack(
                      index: _tabs.index,
                      children: [
                        _buildInfo(place),
                        _buildReviews(place),
                        _buildAmenities(place),
                      ],
                    );
                  },
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),

          // ── Bottom CTA ─────────────────────────────────────────────────────
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              decoration: BoxDecoration(
                color: AppColors.bgPrimary,
                border: Border(top: BorderSide(color: AppColors.cardBorder, width: 0.5)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.cardBorder),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.phone_outlined, color: AppColors.textPrimary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showBookingSheet(context, place),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('Reservasi Sekarang', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textTertiary),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildInfo(Place place) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tentang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(place.description, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.6)),
          const SizedBox(height: 16),
          const Text('Lokasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.bgSecondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder, width: 0.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(child: Text(place.address, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews(Place place) {
    if (place.reviews.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: Text('Belum ada ulasan', style: TextStyle(color: AppColors.textTertiary))),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: place.reviews.map((r) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.bgPrimary,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 18, backgroundImage: NetworkImage(r.userAvatar)),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(r.userName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    Row(children: List.generate(5, (i) => Icon(Icons.star_rounded, size: 12, color: i < r.rating ? AppColors.accent : AppColors.bgTertiary))),
                  ])),
                  Text('${r.date.day}/${r.date.month}/${r.date.year}', style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                ],
              ),
              const SizedBox(height: 8),
              Text(r.comment, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildAmenities(Place place) {
    if (place.amenities.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: Text('Info fasilitas belum tersedia', style: TextStyle(color: AppColors.textTertiary))),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        spacing: 10, runSpacing: 10,
        children: place.amenities.map((a) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: AppColors.bgSecondary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.cardBorder, width: 0.5),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.check_circle_outline, size: 14, color: AppColors.success),
            const SizedBox(width: 6),
            Text(a, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          ]),
        )).toList(),
      ),
    );
  }

  void _showBookingSheet(BuildContext context, Place place) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    String selectedTime = '10:00';
    int guests = 2;
    final times = ['09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: AppColors.bgPrimary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.bgTertiary, borderRadius: BorderRadius.circular(2))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Expanded(child: Text('Buat Reservasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
                    GestureDetector(onTap: () => Navigator.pop(ctx), child: const Icon(Icons.close, color: AppColors.textTertiary)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _bookingSection('Tanggal',
                      Row(
                        children: List.generate(5, (i) {
                          final d = DateTime.now().add(Duration(days: i + 1));
                          final isSelected = selectedDate.day == d.day;
                          return GestureDetector(
                            onTap: () => setS(() => selectedDate = d),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 8),
                              width: 52, height: 62,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : AppColors.bgSecondary,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isSelected ? AppColors.primary : AppColors.cardBorder, width: 0.5),
                              ),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Text(_dayName(d.weekday), style: TextStyle(fontSize: 10, color: isSelected ? Colors.white70 : AppColors.textTertiary)),
                                const SizedBox(height: 2),
                                Text('${d.day}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : AppColors.textPrimary)),
                              ]),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _bookingSection('Waktu',
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: times.map((t) {
                          final isSel = t == selectedTime;
                          return GestureDetector(
                            onTap: () => setS(() => selectedTime = t),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSel ? AppColors.primary : AppColors.bgSecondary,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: isSel ? AppColors.primary : AppColors.cardBorder, width: 0.5),
                              ),
                              child: Text(t, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isSel ? Colors.white : AppColors.textSecondary)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _bookingSection('Jumlah Orang',
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () { if (guests > 1) setS(() => guests--); },
                            child: Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(color: AppColors.bgSecondary, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.cardBorder, width: 0.5)),
                              child: const Icon(Icons.remove, size: 18, color: AppColors.textSecondary),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text('$guests', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                          ),
                          GestureDetector(
                            onTap: () { if (guests < 20) setS(() => guests++); },
                            child: Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.add, size: 18, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 34),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<AppState>().addBooking(Booking(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        placeId: place.id,
                        placeName: place.name,
                        placeImage: place.imageUrl,
                        date: selectedDate,
                        time: selectedTime,
                        guests: guests,
                        status: 'confirmed',
                        totalPrice: 0,
                      ));
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Reservasi berhasil dibuat! 🎉'),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('Konfirmasi Reservasi · $guests orang', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bookingSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        child,
      ],
    );
  }

  String _dayName(int d) {
    const days = ['', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return days[d];
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height + 1;
  @override
  double get maxExtent => tabBar.preferredSize.height + 1;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.bgPrimary,
      child: Column(children: [
        tabBar,
        Container(height: 0.5, color: AppColors.cardBorder),
      ]),
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate old) => false;
}
