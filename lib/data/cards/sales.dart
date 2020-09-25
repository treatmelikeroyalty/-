/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../arrival.dart';
import '../socket.dart';
import 'partners.dart';

class Sale {
  static final String source =
    'https://res.cloudinary.com/arrival-kc/image/upload/';
  static final String default_img =
    'https://arrival-app.herokuapp.com/includes/img/default-profile-pic.png';

  final int id;
  final String cryptlink;
  final String name;
  String pic;
  final String shortDescription;
  final Business partner;

  String toString() {
    String str = '';
    str += 'cryptlink:' + cryptlink + ',';
    str += 'name:' + name + ',';
    str += 'info:' + shortDescription + ',';
    str += 'partner:' + partner.cryptlink + ',';
    return str;
  }
  bool isOpen() {
    return true;
  }

  Sale({
    @required this.id,
    @required this.cryptlink,
    @required this.name,
    @required this.shortDescription,
    @required this.partner,
  }) {
    ArrivalData.innocentAdd(partner.sales, this);
  }

  NetworkImage card_image() {
    if (pic==null) return NetworkImage(Sale.default_img);
    return NetworkImage(Sale.source + pic);
  }
  Widget image() {
    if (pic==null) return Icon(Icons.shopping_cart);
    return Image.network(Sale.source + pic);
  }

  static Sale json(var data) {
    return Sale(
      id: Sale.index++,
      cryptlink: data['link'],
      name: data['name'],
      shortDescription: data['info'],
      partner: Business.link(data['partner']),
    );
  }
  static Sale parse(String input) {
    var id, name, partner,
        shortDescription, cryptlink;

    var startDataLoc, endDataLoc = 0;

    id = Sale.index++;

    startDataLoc = input.indexOf('cryptlink')        + 10;
    endDataLoc = input.indexOf(',', startDataLoc);
    cryptlink = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('name')            + 5;
    endDataLoc = input.indexOf(',', startDataLoc);
    name = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('info')            + 5;
    endDataLoc = input.indexOf(',', startDataLoc);
    shortDescription = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('partner')            + 8;
    endDataLoc = input.indexOf(',', startDataLoc);
    partner = Business.link(input.substring(startDataLoc, endDataLoc));

    return Sale(
      id: id,
      cryptlink: cryptlink,
      name: name,
      shortDescription: shortDescription,
      partner: partner,
    );
  }
  static int index = 0;
}
Sale blankSale = Sale(
  id: -1,
  cryptlink: '',
  name: 'no sale',
  shortDescription: 'we apologize, but no sale could be found',
  partner: blankBusiness,
);
