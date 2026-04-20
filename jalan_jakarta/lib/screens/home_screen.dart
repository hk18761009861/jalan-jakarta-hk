import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../services/data_service.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import 'place_detail_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ───────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
                ),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.white70, size: 16),
                                  const SizedBox(width: 4),
                                  const Text('Jakarta, Indonesia', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                  const Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 16),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text('Jalan\nJakarta', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -0.5)),
                            ],
                          ),
                        ),
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white30, width: 1.5),
                            image: DecorationImage(
                              image: NetworkImage(state.currentUser.avatarUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())),
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search, color: AppColors.textTertiary, size: 20),
                            SizedBox(width: 10),
                            Text('Cari restoran, spa, hiburan...', style: TextStyle(color: AppColors.textTertiary, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Categories ────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'Kategori'),
                    const SizedBox(height: 14),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _allCategoryChip(state),
                          const SizedBox(width: 14),
                          ...DataService.categories.map((cat) => Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: CategoryChip(
                              category: cat,
                              isSelected: state.selectedCategory == cat.id,
                              onTap: () => state.setCategory(cat.id),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Featured ──────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: SectionHeader(
                        title: '🔥 Populer Sekarang',
                        actionLabel: 'Lihat semua',
                        onAction: () => state.setCategory('all'),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 290,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(right: 20),
                        itemCount: state.featuredPlaces.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (ctx, i) {
                          final place = state.featuredPlaces[i];
                          return PlaceCardLarge(
                            place: place,
                            onTap: () => _goToDetail(ctx, place),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Quick Stats ───────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Row(
                  children: [
                    _statCard('200+', 'Tempat', Icons.place_outlined),
                    const SizedBox(width: 10),
                    _statCard('7', 'Kategori', Icons.category_outlined),
                    const SizedBox(width: 10),
                    _statCard('50k+', 'Review', Icons.star_border),
                  ],
                ),
              ),
            ),

            // ── Filtered / New ────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: SectionHeader(
                  title: state.selectedCategory == 'all'
                      ? '✨ Baru Ditambahkan'
                      : '📍 ${DataService.categories.firstWhere((c) => c.id == state.selectedCategory, orElse: () => const Category(id: '', name: '', nameId: '', emoji: '', colorValue: 0)).nameId}',
                  actionLabel: 'Semua',
                  onAction: () => state.setCategory('all'),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    final places = state.selectedCategory == 'all' ? state.newPlaces : state.filteredPlaces;
                    if (i >= places.length) return null;
                    return PlaceCardRow(
                      place: places[i],
                      onTap: () => _goToDetail(ctx, places[i]),
                    );
                  },
                  childCount: (state.selectedCategory == 'all' ? state.newPlaces : state.filteredPlaces).length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _allCategoryChip(AppState state) {
    final isSelected = state.selectedCategory == 'all';
    return GestureDetector(
      onTap: () => state.setCategory('all'),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.bgPrimary,
              borderRadius: BorderRadius.circular(16),
              border: isSelected ? null : Border.all(color: AppColors.cardBorder, width: 0.5),
            ),
            child: const Center(child: Text('🏙️', style: TextStyle(fontSize: 24))),
          ),
          const SizedBox(height: 5),
          Text('Semua', style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, color: isSelected ? AppColors.primary : AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder, width: 0.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
          ],
        ),
      ),
    );
  }

  void _goToDetail(BuildContext context, Place place) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => PlaceDetailScreen(place: place)));
  }
}
