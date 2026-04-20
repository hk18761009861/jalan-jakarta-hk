import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../services/app_state.dart';

// ─── Place Card (Large) ──────────────────────────────────────────────────────
class PlaceCardLarge extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;

  const PlaceCardLarge({super.key, required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.cardBorder, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: place.imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      height: 160,
                      color: AppColors.bgTertiary,
                      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: 160, color: AppColors.bgTertiary,
                      child: const Icon(Icons.image_outlined, color: AppColors.textTertiary, size: 40),
                    ),
                  ),
                ),
                Positioned(
                  top: 10, right: 10,
                  child: GestureDetector(
                    onTap: () => state.toggleSave(place.id),
                    child: Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        state.isSaved(place.id) ? Icons.bookmark : Icons.bookmark_border,
                        color: state.isSaved(place.id) ? AppColors.primary : AppColors.textSecondary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                if (place.isNew)
                  Positioned(
                    top: 10, left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('BARU', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text(place.subcategory, style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.accent, size: 14),
                      const SizedBox(width: 3),
                      Text('${place.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(width: 3),
                      Text('(${place.reviewCount})', style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: place.isOpen ? const Color(0xFFEDF8E4) : const Color(0xFFFFF3F0),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          place.isOpen ? 'Buka' : 'Tutup',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: place.isOpen ? AppColors.success : AppColors.error),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textTertiary),
                      const SizedBox(width: 3),
                      Text('${place.distanceKm} km', style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                      const SizedBox(width: 10),
                      const Icon(Icons.monetization_on_outlined, size: 12, color: AppColors.textTertiary),
                      const SizedBox(width: 3),
                      Expanded(child: Text(place.priceRange, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Place Card (List Row) ───────────────────────────────────────────────────
class PlaceCardRow extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;

  const PlaceCardRow({super.key, required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 0.5),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: place.imageUrl,
                width: 80, height: 80, fit: BoxFit.cover,
                placeholder: (_, __) => Container(width: 80, height: 80, color: AppColors.bgTertiary),
                errorWidget: (_, __, ___) => Container(width: 80, height: 80, color: AppColors.bgTertiary, child: const Icon(Icons.image_outlined, color: AppColors.textTertiary)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text('${place.subcategory} · ${place.district}', style: const TextStyle(fontSize: 12, color: AppColors.textTertiary), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.accent, size: 13),
                      const SizedBox(width: 2),
                      Text('${place.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textTertiary),
                      Text(' ${place.distanceKm} km', style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(place.priceRange, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => state.toggleSave(place.id),
              child: Icon(
                state.isSaved(place.id) ? Icons.bookmark : Icons.bookmark_border,
                color: state.isSaved(place.id) ? AppColors.primary : AppColors.textTertiary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Category Chip ───────────────────────────────────────────────────────────
class CategoryChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({super.key, required this.category, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: Color(category.colorValue),
              borderRadius: BorderRadius.circular(16),
              border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
              boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 3))] : null,
            ),
            child: Center(child: Text(category.emoji, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(height: 5),
          Text(category.name, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, color: isSelected ? AppColors.primary : AppColors.textSecondary)),
        ],
      ),
    );
  }
}

// ─── Section Header ──────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(actionLabel!, style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w500)),
          ),
      ],
    );
  }
}

// ─── Event Card ──────────────────────────────────────────────────────────────
class EventCard extends StatelessWidget {
  final Event event;
  final bool isInterested;
  final VoidCallback onToggleInterest;

  const EventCard({super.key, required this.event, required this.isInterested, required this.onToggleInterest});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: event.imageUrl,
                  height: 160, width: double.infinity, fit: BoxFit.cover,
                  placeholder: (_, __) => Container(height: 160, color: AppColors.bgTertiary),
                  errorWidget: (_, __, ___) => Container(height: 160, color: AppColors.bgTertiary),
                ),
                if (event.isFree)
                  Positioned(
                    top: 12, left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(8)),
                      child: const Text('GRATIS', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(
                      '${event.startDate.day} ${_month(event.startDate.month)} ${event.startDate.year}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textTertiary),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Expanded(child: Text(event.district, style: const TextStyle(fontSize: 12, color: AppColors.textTertiary), overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(event.priceRange, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                          Text('${event.interestedCount} tertarik', style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: onToggleInterest,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isInterested ? AppColors.primary : Colors.transparent,
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isInterested ? 'Tertarik ✓' : 'Tertarik',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isInterested ? Colors.white : AppColors.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _month(int m) {
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return months[m];
  }
}
