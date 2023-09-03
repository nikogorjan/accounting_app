import 'dart:convert';

import 'package:accounting_app/gradniki/nadzorna_plosca/grafi/banka_podatki.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:dots_indicator/dots_indicator.dart';

import '../../../data/data.dart';
import '../../../objekti/banka.dart';

class BankaCarousel extends StatefulWidget {
  const BankaCarousel({super.key});

  @override
  State<BankaCarousel> createState() => _BankaCarouselState();
}

class _BankaCarouselState extends State<BankaCarousel> {
  final _controller = PageController();
  final List<Widget> _pages = [];

  Future<void> getBanks() async {
    var db = FirebaseFirestore.instance;
    String ID = box.get('email');
    final docRef = db.collection("Users").doc(ID);
    docRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      List<dynamic> bankeJson = data['banka'];
      List<Banka> banke = [];
      for (int i = 0; i < bankeJson.length; i++) {
        Map<String, dynamic> valueMap = json.decode(bankeJson[i]);
        Banka NewAccount = Banka.fromJson(valueMap);
        banke.add(NewAccount);
        _pages.add(BankaPodatki(banka: NewAccount));
      }
    });
  }

  int _currentPage = 0;
  bool _isLoading = true;
  Future<void> _loadData() async {
    await getBanks(); // replace with your async function call
    setState(() {
      _isLoading = false;
    });
  }

  void _onPageSelected(double index) {
    _controller.animateToPage(
      index.toInt(),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page?.round() ?? 0;
      });
    });
  }

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

            List<dynamic> bankeJson = data['banka'];
            List<Banka> banke = [];
            _pages.clear();
            for (int i = 0; i < bankeJson.length; i++) {
              Map<String, dynamic> valueMap = json.decode(bankeJson[i]);
              Banka NewAccount = Banka.fromJson(valueMap);
              banke.add(NewAccount);
              _pages.add(BankaPodatki(banka: NewAccount));
            }

            //debetItem = dropdownValue;
            return SizedBox(
              width: 400,
              height: 400,
              child: Stack(
                children: [
                  Container(
                    color: Colors.black,
                  ),
                  PageView(
                    controller: _controller,
                    children: _pages,
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: DotsIndicator(
                      dotsCount: _pages.length,
                      position: _currentPage.toDouble(),
                      decorator: DotsDecorator(
                        activeColor: Colors.white,
                        size: const Size.square(9),
                        activeSize: const Size.square(9),
                      ),
                      onTap: _onPageSelected,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
