import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/note.dart';

class NoteFormScreen extends StatefulWidget {
  final Note? note;
  const NoteFormScreen({super.key, this.note});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _title = TextEditingController();
  final _content = TextEditingController();
  final _category = TextEditingController(text: 'Sekolah');
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _wa = TextEditingController();

  @override
  void initState() {
    super.initState();
    final n = widget.note;
    if (n != null) {
      _title.text = n.title;
      _content.text = n.content;
      _category.text = n.category;
      _phone.text = n.phone ?? '';
      _email.text = n.email ?? '';
      _wa.text = n.whatsapp ?? '';
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    _category.dispose();
    _phone.dispose();
    _email.dispose();
    _wa.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final t = _title.text.trim();
    final c = _content.text.trim();
    final cat = _category.text.trim();

    if (t.isEmpty || c.isEmpty || cat.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul, isi, dan kategori wajib diisi')),
      );
      return;
    }

    final now = DateTime.now();
    final note = (widget.note == null)
        ? Note(
            title: t,
            content: c,
            category: cat,
            phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
            email: _email.text.trim().isEmpty ? null : _email.text.trim(),
            whatsapp: _wa.text.trim().isEmpty ? null : _wa.text.trim(),
            createdAt: now,
          )
        : widget.note!.copyWith(
            title: t,
            content: c,
            category: cat,
            phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
            email: _email.text.trim().isEmpty ? null : _email.text.trim(),
            whatsapp: _wa.text.trim().isEmpty ? null : _wa.text.trim(),
          );

    if (widget.note == null) {
      await DBHelper.instance.insertNote(note);
    } else {
      await DBHelper.instance.updateNote(note);
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.note != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Note' : 'Tambah Note')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(
                  labelText: 'Judul', prefixIcon: Icon(Icons.title)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _category,
              decoration: const InputDecoration(
                  labelText: 'Kategori', prefixIcon: Icon(Icons.category)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _content,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.subject),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  'Kontak (opsional) untuk fitur WhatsApp/Telepon/Email',
                  style: TextStyle(color: Colors.grey.shade700)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _wa,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'WhatsApp (contoh: 62812xxxx)',
                prefixIcon: Icon(Icons.chat),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  labelText: 'Telepon', prefixIcon: Icon(Icons.call)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  labelText: 'Email', prefixIcon: Icon(Icons.email)),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: Text(isEdit ? 'Simpan Perubahan' : 'Tambah Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
