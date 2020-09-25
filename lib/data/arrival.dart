/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import '../posts/post.dart';
import '../data/cards/partners.dart';
import '../data/cards/articles.dart';
import '../data/cards/sales.dart';
import '../posts/page.dart';
import '../users/profile.dart';
import '../users/data.dart';
import '../data/local.dart';
import '../data/link.dart';
import '../foryou/row_card.dart';

class ArrivalData {
  static List<RowCard> foryou;
  static DataState server;
  static String result;
  static String sendMessage;
  static bool carry;
  static List<Post> posts;
  static List<Profile> profiles;
  static List<Business> partners;
  static List<Article> articles;
  static List<Sale> sales;
  static final DateTime default_time = new DateTime(1996, 9, 29);

  static dynamic innocentAdd(List<dynamic> _list, dynamic _input) {
    for (int i=0;i<_list.length;i++) {
      if (_list[i].cryptlink==_input.cryptlink) {
        return;
      }
    }
    _list.add(_input);
    return _input;
  }

  static void save() async {
    ArrivalFiles file = ArrivalFiles('partners.json');

    Map<String, dynamic> data = Map<String, dynamic>();

    for (var i=0;i<ArrivalData.partners.length;i++) {
      data[ArrivalData.partners[i].cryptlink] =
        ArrivalData.partners[i].toString();
    }

    await file.write(data);

    file = ArrivalFiles('articles.json');

    data = Map<String, dynamic>();

    for (var i=0;i<ArrivalData.articles.length;i++) {
      data[ArrivalData.articles[i].cryptlink] =
        ArrivalData.articles[i].toString();
    }

    await file.write(data);
  }
  static void load() async {
    ArrivalData.partners = List<Business>();
    ArrivalData.posts = List<Post>();
    ArrivalData.profiles = List<Profile>();
    ArrivalData.articles = List<Article>();
    ArrivalData.sales = List<Sale>();

    try {
      (await ArrivalFiles('partners.json').readAll())
        .forEach((String key, dynamic value) =>
          ArrivalData.innocentAdd(ArrivalData.partners, Business.parse(value)));
    } catch(e) {
      print('-------');
      print('Arrival Error when loading parter data');
      print(e);
      print('-------');
    }
    try {
      (await ArrivalFiles('articles.json').readAll())
        .forEach((String key, dynamic value) =>
          ArrivalData.innocentAdd(ArrivalData.articles, Article.parse(value)));
    } catch(e) {
      print('-------');
      print('Arrival Error when loading article data');
      print(e);
      print('-------');
    }
  }
  static void refresh() async {
    try {
      ArrivalFiles('partners.json').delete();
    } catch(e) {
      print('-------');
      print('Arrival Error when deleting partners file');
      print(e);
      print('-------');
    }
    try {
      ArrivalFiles('articles.json').delete();
    } catch(e) {
      print('-------');
      print('Arrival Error when deleting articles file');
      print(e);
      print('-------');
    }
  }
}
