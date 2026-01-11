import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/note.dart';
import '../widgets/app_background.dart';
import '../widgets/app_logo_3d.dart';
import '../services/session_service.dart';
import 'detail_screen.dart';
import 'note_form_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _gridMode = false;
  String _query = '';
  late Future<List<Note>> _futureNotes;

  @override
  void initState() {
    super.initState();
    _futureNotes = DBHelper.instance.getNotes();
  }

  void _reload() {
    setState(() => _futureNotes = DBHelper.instance.getNotes(query: _query));
  }

  Future<void> _goAdd() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (_) => const NoteFormScreen()));
    _reload();
  }

  Future<void> _goDetail(Note note) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (_) => DetailScreen(note: note)));
    _reload();
  }

  Future<void> _logout() async {
    await SessionService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final maxWidth = w > 980 ? 980.0 : w;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: _gridMode ? 'Mode List' : 'Mode Grid',
            onPressed: () => setState(() => _gridMode = !_gridMode),
            icon: Icon(_gridMode ? Icons.view_list : Icons.grid_view_rounded),
          ),
          IconButton(
              tooltip: 'Logout',
              onPressed: _logout,
              icon: const Icon(Icons.logout)),
        ],
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: _goAdd, child: const Icon(Icons.add)),
      body: AppBackground(
        child: Center(
          child: SizedBox(
            width: maxWidth,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  FutureBuilder<List<Note>>(
                    future: _futureNotes,
                    builder: (context, snap) {
                      final notes = snap.data ?? [];
                      final total = notes.length;

                      final Map<String, int> byCat = {};
                      for (final n in notes) {
                        byCat[n.category] = (byCat[n.category] ?? 0) + 1;
                      }
                      final topCats = byCat.entries.toList()
                        ..sort((a, b) => b.value.compareTo(a.value));
                      final top3 = topCats.take(3).toList();

                      return Card(
                        color: Colors.white.withOpacity(0.92),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const AppLogo3D(size: 58),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Welcome 👋',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900)),
                                        const SizedBox(height: 2),
                                        Text(
                                          widget.username,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.grey.shade800,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1D4ED8)
                                          .withOpacity(0.10),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                            _gridMode
                                                ? Icons.grid_view_rounded
                                                : Icons.view_list,
                                            size: 18,
                                            color: const Color(0xFF1D4ED8)),
                                        const SizedBox(width: 6),
                                        Text(_gridMode ? 'Grid' : 'List',
                                            style: const TextStyle(
                                                color: Color(0xFF1D4ED8),
                                                fontWeight: FontWeight.w800)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _StatTile(
                                      icon: Icons.collections_bookmark_rounded,
                                      label: 'Total Notes',
                                      value: '$total',
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _StatTile(
                                      icon: Icons.local_fire_department_rounded,
                                      label: 'Top Kategori',
                                      value:
                                          top3.isEmpty ? '0' : '${top3.length}',
                                    ),
                                  ),
                                ],
                              ),
                              if (top3.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Top Kategori',
                                      style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontWeight: FontWeight.w800)),
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: top3.map((e) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1D4ED8)
                                            .withOpacity(0.08),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                        border: Border.all(
                                            color: const Color(0xFF1D4ED8)
                                                .withOpacity(0.15)),
                                      ),
                                      child: Text('${e.key} • ${e.value}',
                                          style: const TextStyle(
                                              color: Color(0xFF1D4ED8),
                                              fontWeight: FontWeight.w800)),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Cari judul / isi / kategori...',
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                        ),
                        onChanged: (v) {
                          _query = v.trim();
                          _reload();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: FutureBuilder<List<Note>>(
                      future: _futureNotes,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white));
                        }
                        final notes = snapshot.data ?? [];
                        if (notes.isEmpty) return _EmptyState(onAdd: _goAdd);
                        return _gridMode
                            ? _buildGrid(notes)
                            : _buildList(notes);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<Note> notes) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, i) {
        final n = notes[i];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.note_alt_rounded),
            title: Text(n.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text('${n.category} • ${_fmtDate(n.createdAt)}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _goDetail(n),
          ),
        );
      },
    );
  }

  Widget _buildGrid(List<Note> notes) {
    return LayoutBuilder(
      builder: (context, c) {
        final width = c.maxWidth;
        final crossAxisCount = width > 900 ? 4 : (width > 600 ? 3 : 2);

        return GridView.builder(
          itemCount: notes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.12,
          ),
          itemBuilder: (context, i) {
            final n = notes[i];
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _goDetail(n),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.note_alt_rounded, size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              n.category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(n.title,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      Text(n.content,
                          maxLines: 3, overflow: TextOverflow.ellipsis),
                      const Spacer(),
                      Text(_fmtDate(n.createdAt),
                          style: TextStyle(color: Colors.grey.shade700)),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _fmtDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1D4ED8).withOpacity(0.10),
            const Color(0xFF3B82F6).withOpacity(0.08),
            Colors.white.withOpacity(0.10),
          ],
        ),
        border: Border.all(color: const Color(0xFF1D4ED8).withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF1D4ED8).withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF1D4ED8)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white.withOpacity(0.92),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppLogo3D(size: 64),
              const SizedBox(height: 10),
              const Text('Belum ada notes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              Text(
                'Klik tombol + untuk menambah data pertama kamu.',
                style: TextStyle(color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Note')),
            ],
          ),
        ),
      ),
    );
  }
}
