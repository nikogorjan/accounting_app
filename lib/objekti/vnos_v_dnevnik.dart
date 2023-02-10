class VnosVDnevnik {
  final String datum;
  final String debet;
  final String kredit;
  final String kontDebet;
  final String kontKredit;
  final String komentar;
  final String id;

  const VnosVDnevnik({
    required this.datum,
    required this.debet,
    required this.kredit,
    required this.kontDebet,
    required this.kontKredit,
    required this.komentar,
    required this.id,
  });

  Map toJson() => {
        'datum': datum,
        'debet': debet,
        'kredit': kredit,
        'kontDebet': kontDebet,
        'kontKredit': kontKredit,
        'komentar': komentar,
        'id': id,
      };

  VnosVDnevnik.fromJson(Map<String, dynamic> json)
      : datum = json['datum'],
        debet = json['debet'],
        kredit = json['kredit'],
        kontDebet = json['kontDebet'],
        kontKredit = json['kontKredit'],
        komentar = json['komentar'],
        id = json['id'];
}
