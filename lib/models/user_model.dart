import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? email;
  final String? uid;
  final String? username;

  final int? total;
  final int? amount;
  final DateTime? date;
  final String? note;
  final String? type;

  User({
    this.email,
    this.uid,
    this.username,
    this.total,
    this.amount,
    this.date,
    this.note,
    this.type,
  });

  // Convert User to JSON map for Firestore
  Map<String, dynamic> toJson() => {
    'username': username,
    'uid': uid,
    'email': email,
    'total': total,
    'amount': amount,
    'date': date != null ? Timestamp.fromDate(date!) : null,
    'note': note,
    'type': type,
  };

  static int? _safeInt(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      total: _safeInt(snapshot['total']),
      amount: _safeInt(snapshot['amount']),
      date: snapshot['date'] != null ? (snapshot['date'] as Timestamp).toDate() : null, // Convert Timestamp to DateTime
      note: snapshot['note'],
      type: snapshot['type'],
    );
  }
}
