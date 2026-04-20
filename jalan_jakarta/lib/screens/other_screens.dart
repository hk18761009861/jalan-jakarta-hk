import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import 'place_detail_screen.dart';

// ════════════════════════════════════════════════════════════════════════════
//  EVENTS SCREEN
// ════════════════════════════════════════════════════════════════════════════
class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        title: const Text('Event & Festival', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        centerTitle: false,
        actions: [
          IconButton(icon: const Icon(Icons.tune_outlined), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(children: [
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Acara Bulan Ini', style: TextStyle(color: Colors.white70, fontSize: 12)),
                SizedBox(height: 4),
                Text('4 Event\nMenarik', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, height: 1.2)),
                SizedBox(height: 8),
                Text('Jangan sampai kelewatan!', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ])),
              const Text('📅', style: TextStyle(fontSize: 60)),
            ]),
          ),
          const SizedBox(height: 20),
          ...state.events.map((e) => EventCard(
            event: e,
            isInterested: state.isInterested(e.id),
            onToggleInterest: () => state.toggleInterest(e.id),
          )),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  SAVED SCREEN
// ════════════════════════════════════════════════════════════════════════════
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final saved = state.savedPlaces;
    final bookings = state.bookings;

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        title: const Text('Tersimpan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        centerTitle: false,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: AppColors.bgPrimary,
              child: const TabBar(
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textTertiary,
                indicatorColor: AppColors.primary,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [Tab(text: 'Bookmark'), Tab(text: 'Reservasi')],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // ── Bookmarks ──────────────────────────────────────────────
                  saved.isEmpty
                      ? _empty('Belum ada tempat yang disimpan', '🔖\n\nTambahkan tempat favoritmu\ndengan ikon bookmark')
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: saved.length,
                          itemBuilder: (ctx, i) => PlaceCardRow(
                            place: saved[i],
                            onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => PlaceDetailScreen(place: saved[i]))),
                          ),
                        ),

                  // ── Bookings ───────────────────────────────────────────────
                  bookings.isEmpty
                      ? _empty('Belum ada reservasi', '📋\n\nReservasi dari detail tempat\nakan muncul di sini')
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: bookings.length,
                          itemBuilder: (ctx, i) => _bookingCard(ctx, bookings[i], state),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _empty(String title, String body) {
    return Center(
      child: Text('$body\n\n$title', textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: AppColors.textTertiary, height: 1.6)),
    );
  }

  Widget _bookingCard(BuildContext ctx, booking, AppState state) {
    final statusColor = booking.status == 'confirmed' ? AppColors.success : booking.status == 'cancelled' ? AppColors.error : AppColors.warning;
    final statusLabel = booking.status == 'confirmed' ? 'Dikonfirmasi' : booking.status == 'cancelled' ? 'Dibatalkan' : 'Menunggu';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 0.5),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(booking.placeImage, width: 64, height: 64, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(width: 64, height: 64, color: AppColors.bgTertiary)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(booking.placeName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 3),
            Text('${booking.date.day}/${booking.date.month}/${booking.date.year} · ${booking.time}', style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
            Text('${booking.guests} orang', style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
          ])),
          Column(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
              child: Text(statusLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
            ),
            if (booking.status == 'confirmed') ...[
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => state.cancelBooking(booking.id),
                child: const Text('Batalkan', style: TextStyle(fontSize: 11, color: AppColors.error)),
              ),
            ],
          ]),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  PROFILE SCREEN
// ════════════════════════════════════════════════════════════════════════════
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.bgPrimary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    CircleAvatar(radius: 40, backgroundImage: NetworkImage(user.avatarUrl)),
                    const SizedBox(height: 12),
                    Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    Text(user.email, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Stats
                  Row(children: [
                    _statCard('${state.savedPlaces.length}', 'Disimpan', Icons.bookmark_outline),
                    const SizedBox(width: 10),
                    _statCard('${state.bookings.length}', 'Reservasi', Icons.calendar_today_outlined),
                    const SizedBox(width: 10),
                    _statCard('${user.reviewCount}', 'Ulasan', Icons.star_outline),
                  ]),
                  const SizedBox(height: 20),

                  // Menu
                  _menuSection('Akun', [
                    _menuItem(Icons.person_outline, 'Edit Profil', () {}),
                    _menuItem(Icons.notifications_outlined, 'Notifikasi', () {}),
                    _menuItem(Icons.location_on_outlined, 'Lokasi Saya', () {}),
                  ]),
                  const SizedBox(height: 12),
                  _menuSection('Preferensi', [
                    _menuItem(Icons.language_outlined, 'Bahasa', () {}, trailing: 'Indonesia'),
                    _menuItem(Icons.dark_mode_outlined, 'Tema', () {}, trailing: 'Terang'),
                  ]),
                  const SizedBox(height: 12),
                  _menuSection('Tentang', [
                    _menuItem(Icons.info_outline, 'Tentang JalanJakarta', () {}),
                    _menuItem(Icons.star_outline, 'Beri Rating', () {}),
                    _menuItem(Icons.share_outlined, 'Bagikan Aplikasi', () {}),
                  ]),
                  const SizedBox(height: 12),
                  _menuSection('', [
                    _menuItem(Icons.logout, 'Keluar', () {}, isDestructive: true),
                  ]),
                  const SizedBox(height: 30),
                  const Text('JalanJakarta v1.0.0', style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
                  const SizedBox(height: 4),
                  const Text('Dibuat dengan ❤️ di Jakarta', style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder, width: 0.5),
        ),
        child: Column(children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
        ]),
      ),
    );
  }

  Widget _menuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textTertiary)),
          ),
        ],
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgPrimary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder, width: 0.5),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap, {String? trailing, bool isDestructive = false}) {
    final color = isDestructive ? AppColors.error : AppColors.textPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider, width: 0.5))),
        child: Row(children: [
          Icon(icon, size: 20, color: isDestructive ? AppColors.error : AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: TextStyle(fontSize: 14, color: color))),
          if (trailing != null) Text(trailing, style: const TextStyle(fontSize: 13, color: AppColors.textTertiary)),
          const SizedBox(width: 4),
          Icon(Icons.arrow_forward_ios, size: 13, color: isDestructive ? AppColors.error.withOpacity(0.4) : AppColors.textTertiary),
        ]),
      ),
    );
  }
}
