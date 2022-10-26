import 'dart:convert';

List<Chat> ChatFromJson(String str) =>
    List<Chat>.from(json.decode(str).map((x) => Chat.fromJson(x)));

class Chat {
  Chat({
    required this.id,
    required this.date,
    required this.alias,
    required this.message,
  });

  String id;
  int date;
  String alias;
  String message;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    id: json['id'].toString(),
    date: json['date'],
    alias: json['alias'],
    message: json['message'],
  );
}
