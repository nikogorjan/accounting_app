library konti;

import '../objekti/kont.dart';

final List<Kont> konti = [
  Kont(
    ID: '47',
    ime: 'Stroški dela',
    tip: 'Odhodki',
    podtip: 'Poslovni odhodki',
    bilanca: '0',
    amortizacija: '0',
    bilancaDate: DateTime.now().toString(),
    amortizacijaDate: DateTime.now().toString(),
  ),
  Kont(
    ID: '13',
    ime: 'Material',
    tip: 'Gibljiva sredstva',
    podtip: 'Zaloge',
    bilanca: '0',
    amortizacija: '0',
    bilancaDate: DateTime.now().toString(),
    amortizacijaDate: DateTime.now().toString(),
  ),
  Kont(
    ID: '76',
    ime: 'Prodaja',
    tip: 'Prihodki',
    podtip: 'Poslovni prihodki',
    bilanca: '0',
    amortizacija: '0',
    bilancaDate: DateTime.now().toString(),
    amortizacijaDate: DateTime.now().toString(),
  ),
];
