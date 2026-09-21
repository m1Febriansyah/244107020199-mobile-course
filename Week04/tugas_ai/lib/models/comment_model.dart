class Comment {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  Comment({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  // Konstruktor factory untuk konversi JSON ke objek Comment.
  // Dilengkapi dengan default value fallback (??) jika data dari API null atau field tidak ada.
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      // Casting secara eksplisit dan memberikan nilai fallback yang aman
      postId: json['postId'] as int? ?? 0,
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown Name',
      email: json['email'] as String? ?? 'No Email',
      body: json['body'] as String? ?? 'No Content',
    );
  }
} 