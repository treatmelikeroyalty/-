/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

import '../foryou/cards/sale_card.dart';
import '../data/preferences.dart';
import '../partners/partner.dart';
import '../data/link.dart';
import '../data/socket.dart';
import '../data/arrival.dart';
import '../styles.dart';
import '../widgets/close_button.dart';
import '../widgets/cards.dart';
import '../maps/maps.dart';


class SellerView extends StatelessWidget {
  final biz;
  int _alreadyRequested = 0;

  SellerView(this.biz);

  @override
  Widget build(BuildContext context) {
    final prefs = ScopedModel.of<Preferences>(context, rebuildOnChange: true);
    final themeData = CupertinoTheme.of(context);

    if (biz.sales.length==0) {
      socket.emit('partners request sales', {
        'link': biz.cryptlink,
        'amount': 10,
        'skip': _alreadyRequested,
      });

      return Padding(
        padding: EdgeInsets.all(64),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: 100,
            child: Image.asset('assets/loading/Bucket-1s-200px.gif'),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: RowSale(biz.sales).generate(prefs),
    );
  }
}

class InfoView extends StatelessWidget {
  final biz;

  const InfoView(this.biz);

  @override
  Widget build(BuildContext context) {
    final prefs = ScopedModel.of<Preferences>(context, rebuildOnChange: true);
    final themeData = CupertinoTheme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: ListView(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              FutureBuilder<Set<SourceIndustry>>(
                future: prefs.preferredIndustries,
                builder: (context, snapshot) {
                  return Text(
                    LocalIndustries.industryGrabber(biz.industry).name.toUpperCase(),
                    style: (snapshot.hasData &&
                        snapshot.data.contains(biz.industry))
                        ? Styles.detailsPreferredCategoryText(themeData)
                        : Styles.detailsCategoryText(themeData),
                  );
                },
              ),
              Spacer(),
              for (var i=1;i<6;i++) ...[
                SizedBox(width: 12),
                Icon(
                    Styles.ratingIconData[i<biz.rating ? 1 : (i-1<biz.rating && biz.rating%1>0.5 ? 2 : 0)],
                    semanticLabel: biz.rating.toString(),
                    color: Styles.ratingColors[i<biz.rating ? 1 : (i-1<biz.rating && biz.rating%1>0.5 ? 2 : 0)],
                  ),
              ],
              Spacer(),
              Text(
                ' (' + biz.ratingAmount.toString() + ')',
                style: Styles.detailsDescriptionText(themeData),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            biz.shortDescription,
            style: Styles.detailsDescriptionText(themeData),
          ),
          SizedBox(height: 24),
          GestureDetector(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  biz.contact.address + ', ' + biz.contact.zip,
                  style: Styles.detailsAddressText,
                ),
                // ButtonBar(
                //  do later
                // ),
                Text(
                  'take me here'.toUpperCase(),
                  style: Styles.detailsBigLinkText,
                ),
              ],
            ),
            onTap: () {
              Arrival.navigator.currentState.push(MaterialPageRoute(
                builder: (context) => Maps.directions(partner: biz.cryptlink),
                fullscreenDialog: true,
              ));
            },
          ),
          SizedBox(height: 24),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: FrostyBackground(
                color: Styles.frostedBackground,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Contact Links',
                        style: Styles.cardTitleText,
                      ),
                      SizedBox(height: 18),
                      GestureDetector(
                        child: Text(
                          biz.contact.phoneNumber,
                          style: Styles.detailsLinkText,
                        ),
                        onTap: () {
                          launch('tel://' + biz.contact.phoneNumber);
                        },
                      ),
                      SizedBox(height: 12),
                      GestureDetector(
                        child: Text(
                          'Go to Website',
                          style: Styles.detailsLinkText,
                        ),
                        onTap: () {
                          launch(biz.contact.website);
                        },
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class PartnerDisplayPage extends StatefulWidget {
  final String cryptlink;

  PartnerDisplayPage(this.cryptlink);

  @override
  _PartnerDisplayPageState createState() => _PartnerDisplayPageState();
}

class _PartnerDisplayPageState extends State<PartnerDisplayPage> {
  int _selectedViewIndex = 0;
  final double _headerHeight = 150.0;

  Widget _buildHeader(BuildContext context) {
    final biz = ArrivalData.getPartner(widget.cryptlink);

    return SizedBox(
      height: _headerHeight,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            child: Image.network(
              biz.images.logo,
              fit: BoxFit.cover,
              semanticLabel: 'A background image of ',
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: ArrCloseButton(() {
                Navigator.of(context).pop();
              }),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final biz = ArrivalData.getPartner(widget.cryptlink);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildHeader(context),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    biz.name,
                    style: Styles.PartnerNameText,
                  ),
                ),
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     Switch(
                //       value: biz.isFavorite,
                //       activeColor: Styles.ArrivalPalletteBlue,
                //       onChanged: (value) {
                //         appState.setFavorite(widget.cryptlink, value);
                //       },
                //     ),
                //     SizedBox(width: 8),
                //     Text(
                //       'Save to Favorites',
                //       style: CupertinoTheme.of(context).textTheme.textStyle,
                //     ),
                //   ],
                // ),
                Container(
                  height: MediaQuery.of(context).size.height - _headerHeight
                    - 160 - MediaQuery.of(context).padding.top,
                  child: _selectedViewIndex == 0
                    ? SellerView(biz)
                    : InfoView(biz),
                ),
                CupertinoSegmentedControl<int>(
                  children: {
                    0: Icon(Icons.shopping_cart),
                    1: Icon(Icons.phone),
                  },
                  borderColor: Styles.ArrivalPalletteCream,
                  selectedColor: Styles.ArrivalPalletteBlue,
                  unselectedColor: Styles.ArrivalPalletteWhite,
                  groupValue: _selectedViewIndex,
                  onValueChanged: (value) {
                    setState(() => _selectedViewIndex = value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
