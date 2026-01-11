import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/note.dart';
import '../db/db_helper.dart';
import 'note_form_screen.dart';

class DetailScreen extends StatelessWidget {
  final Note note;
  const DetailScreen({super.key, required this.note});

  Future<void> _launchExternal(BuildContext context, Uri uri) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka aplikasi terkait')),
      );
    }
  }

  Future<void> _delete(BuildContext context) async {
    if (note.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data belum tersimpan (id null).')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Yakin hapus "${note.title}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus')),
        ],
      ),
    );

    if (confirm != true) return;

    await DBHelper.instance.deleteNote(note.id!);
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final wa = (note.whatsapp ?? '').trim();
    final phone = (note.phone ?? '').trim();
    final email = (note.email ?? '').trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Note'),
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => NoteFormScreen(note: note)));
              if (context.mounted) Navigator.pop(context);
            },
          ),
          IconButton(
              tooltip: 'Hapus',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _delete(context)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(note.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text('Kategori: ${note.category}'),
                    const Divider(height: 24),
                    Text(note.content),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Aksi Cepat',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.icon(
                  onPressed: wa.isEmpty
                      ? null
                      : () => _launchExternal(
                            context,
                            Uri.parse(
                              'https://wa.me/$wa?text=Halo%20saya%20mau%20tanya%20tentang%20${Uri.encodeComponent(note.title)}',
                            ),
                          ),
                  icon: const Icon(Icons.chat),
                  label: const Text('WhatsApp'),
                ),
                FilledButton.icon(
                  onPressed: phone.isEmpty
                      ? null
                      : () => _launchExternal(
                          context, Uri(scheme: 'tel', path: phone)),
                  icon: const Icon(Icons.call),
                  label: const Text('Telepon'),
                ),
                FilledButton.icon(
                  onPressed: email.isEmpty
                      ? null
                      : () => _launchExternal(
                            context,
                            Uri(
                              scheme: 'mailto',
                              path: email,
                              queryParameters: {
                                'subject': 'Tentang: ${note.title}',
                                'body': note.content
                              },
                            ),
                          ),
                  icon: const Icon(Icons.email),
                  label: const Text('Email'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
