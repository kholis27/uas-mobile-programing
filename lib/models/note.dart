class Note {
  final int? id;
  final String title;
  final String content;
  final String category;
  final String? phone;
  final String? email;
  final String? whatsapp;
  final DateTime createdAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.category,
    this.phone,
    this.email,
    this.whatsapp,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'phone': phone,
      'email': email,
      'whatsapp': whatsapp,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: (map['title'] ?? '') as String,
      content: (map['content'] ?? '') as String,
      category: (map['category'] ?? '') as String,
      phone: map['phone'] as String?,
      email: map['email'] as String?,
      whatsapp: map['whatsapp'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    String? category,
    String? phone,
    String? email,
    String? whatsapp,
    DateTime? createdAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      whatsapp: whatsapp ?? this.whatsapp,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
