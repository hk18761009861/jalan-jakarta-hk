import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../services/data_service.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import 'place_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final results = state.searchQuery.isEmpty ? [] : state.searchResults;

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _controller,
          focusNode: _focus,
          onChanged: (v) => state.setSearch(v),
          decoration: const InputDecoration(
            hintText: 'Cari tempat di Jakarta...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: AppColors.textTertiary, fontSize: 15),
          ),
          style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.textTertiary),
              onPressed: () {
                _controller.clear();
                state.setSearch('');
              },
            ),
        ],
      ),
      body: state.searchQuery.isEmpty
          ? _buildSuggestions(state)
          : results.isEmpty
              ? _buildEmpty()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: results.length,
                  itemBuilder: (ctx, i) => PlaceCardRow(
                    place: results[i],
                    onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => PlaceDetailScreen(place: results[i]))),
                  ),
                ),
    );
  }

  Widget _buildSuggestions(AppState state) {
    final suggestions = ['Sate', 'Spa', 'Kafe', 'Mall', 'Taman', 'Rooftop', 'Fine Dining', 'Gratis'];
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Pencarian Populer', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: suggestions.map((s) => GestureDetector(
            onTap: () {
              _controller.text = s;
              state.setSearch(s);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: AppColors.bgPrimary,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder, width: 0.5),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.search, size: 14, color: AppColors.textTertiary),
                const SizedBox(width: 6),
                Text(s, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ]),
            ),
          )).toList(),
        ),
        const SizedBox(height: 24),
        const Text('Semua Kategori', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        ...DataService.categories.map((cat) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: Color(cat.colorValue), borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(cat.emoji, style: const TextStyle(fontSize: 22))),
          ),
          title: Text(cat.nameId, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          subtitle: Text('${DataService.getByCategory(cat.id).length} tempat', style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textTertiary),
          onTap: () {
            context.read<AppState>().setCategory(cat.id);
            Navigator.pop(context);
          },
        )),
      ],
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text('Tidak ditemukan: "${context.read<AppState>().searchQuery}"', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          const Text('Coba kata kunci lain', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
        ],
      ),
    );
  }
}
