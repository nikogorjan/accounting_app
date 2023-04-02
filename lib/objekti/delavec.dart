class Delavec {
  final String ID;
  final String naziv;
  final String naslov;
  final String tel;
  final String email;
  final String bilanca;
  final String urnaPostavka;
  final List<dynamic> ure;

  const Delavec({
    required this.ID,
    required this.naziv,
    required this.naslov,
    required this.tel,
    required this.email,
    required this.bilanca,
    required this.urnaPostavka,
    required this.ure,
  });

  Map toJson() => {
        'ID': ID,
        'naziv': naziv,
        'naslov': naslov,
        'tel': tel,
        'email': email,
        'bilanca': bilanca,
        'urnaPostavka': urnaPostavka,
        'ure': ure
      };

  Delavec.fromJson(Map<String, dynamic> json)
      : ID = json['ID'],
        naziv = json['naziv'],
        naslov = json['naslov'],
        tel = json['tel'],
        email = json['email'],
        bilanca = json['bilanca'],
        ure = json['ure'],
        urnaPostavka = json['urnaPostavka'];
}
