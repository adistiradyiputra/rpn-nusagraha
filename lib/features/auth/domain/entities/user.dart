class LastFung {
  final String? fungJab;
  final String? ak;

  const LastFung({
    this.fungJab,
    this.ak,
  });

  factory LastFung.fromJson(Map<String, dynamic> json) {
    return LastFung(
      fungJab: json['fung_jab'],
      ak: json['ak'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fung_jab': fungJab,
      'ak': ak,
    };
  }
}

class LastGol {
  final String? levelGolongan;

  const LastGol({
    this.levelGolongan,
  });

  factory LastGol.fromJson(Map<String, dynamic> json) {
    return LastGol(
      levelGolongan: json['level_golongan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level_golongan': levelGolongan,
    };
  }
}

class User {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String? profilePicture;
  final String? nik;
  final String? jabFung;
  final String? jabStruk;
  final String? puslit;
  final String? foto;
  final String? idKar;
  final String? noHp;
  final String? kepakaran;
  final String? type;
  final LastFung? lastFung;
  final LastGol? lastGol;
  final int? jmlHki;
  final int? jmlGSchoolar;
  final int? jmlPublikasi;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    this.profilePicture,
    this.nik,
    this.jabFung,
    this.jabStruk,
    this.puslit,
    this.foto,
    this.idKar,
    this.noHp,
    this.kepakaran,
    this.type,
    this.lastFung,
    this.lastGol,
    this.jmlHki,
    this.jmlGSchoolar,
    this.jmlPublikasi,
    required this.createdAt,
    required this.updatedAt,
  });

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? fullName,
    String? profilePicture,
    String? nik,
    String? jabFung,
    String? jabStruk,
    String? puslit,
    String? foto,
    String? idKar,
    String? noHp,
    String? kepakaran,
    String? type,
    LastFung? lastFung,
    LastGol? lastGol,
    int? jmlHki,
    int? jmlGSchoolar,
    int? jmlPublikasi,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      profilePicture: profilePicture ?? this.profilePicture,
      nik: nik ?? this.nik,
      jabFung: jabFung ?? this.jabFung,
      jabStruk: jabStruk ?? this.jabStruk,
      puslit: puslit ?? this.puslit,
      foto: foto ?? this.foto,
      idKar: idKar ?? this.idKar,
      noHp: noHp ?? this.noHp,
      kepakaran: kepakaran ?? this.kepakaran,
      type: type ?? this.type,
      lastFung: lastFung ?? this.lastFung,
      lastGol: lastGol ?? this.lastGol,
      jmlHki: jmlHki ?? this.jmlHki,
      jmlGSchoolar: jmlGSchoolar ?? this.jmlGSchoolar,
      jmlPublikasi: jmlPublikasi ?? this.jmlPublikasi,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, fullName: $fullName)';
  }
}

