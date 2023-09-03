import 'package:accounting_app/objekti/kont.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Testiranje spreminjanja bilance konta', () {
    //setup
    Kont kont = Kont(
        ID: 'ID',
        ime: 'ime',
        tip: 'tip',
        podtip: 'podtip',
        bilanca: '500.0',
        amortizacija: 'amortizacija',
        bilancaDate: 'bilancaDate',
        amortizacijaDate: 'amortizacijaDate',
        debet: '500.0',
        kredit: '0.0');
    //do
    kont.changeBalance(0, 50);
    //test
    expect(kont.bilanca, '450.0');
  });
}
