import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../data/data.dart';
import '../../objekti/predmet.dart';
import '../../services/storage_service.dart';

class ItemRowMobile extends StatefulWidget {
  const ItemRowMobile({super.key, required this.predmet});
  final Predmet predmet;

  @override
  State<ItemRowMobile> createState() => _ItemRowMobileState();
}

class _ItemRowMobileState extends State<ItemRowMobile> {
  Storage storage = Storage();
  late String image;
  late String data;
  late String ID;
  late String path;
  @override
  void initState() {
    ID = box.get('email');
    path = box.get('email') + '/images/' + widget.predmet.ime + '.png';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
              child: Column(
            children: [
              FutureBuilder(
                future: storage.getData(
                    'users',
                    box.get('email') +
                        '/images/' +
                        widget.predmet.ime +
                        '.png'),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text(
                      "Something went wrong",
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 50,
                        height: 50,
                        child: Image.network(
                          snapshot.data.toString(),
                        ),
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
              SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.predmet.ime,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          )),
        ),
        Expanded(
          child: Container(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    widget.predmet.kolicina,
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 11,
                    ),
                  ),
                  if (widget.predmet.enota != '/')
                    Text(
                      ' ' + widget.predmet.enota,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 11,
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.predmet.tip,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                double.parse(widget.predmet.bilanca).toStringAsFixed(2),
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
