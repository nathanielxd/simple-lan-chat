import 'package:awesomelanchat/logic/ad_rewards.dart';
import 'package:awesomelanchat/logic/storefront.dart';
import 'package:flutter/material.dart';

class PremiumPage extends StatefulWidget {

  @override
  _PremiumPageState createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {

  void showAd() async {
    if(AdRewards.available) {
      await AdRewards.loadAd();
      Navigator.of(context).pop();
    }
  }

  void purchase() async {
    if(Storefront.available) {
      await Storefront.purchase();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, 
                bottom: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  color: Colors.black,
                ),
              ),
            ),
            Spacer(flex: 2),
            Text(Storefront.products.isNotEmpty
              ? Storefront.products[0].price + ' for lifetime'
              : '\$4 for lifetime',
              style: TextStyle(
                fontSize: 32,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w500
              )
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).accentColor
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildStar(),
                        Flexible(
                          child: Text('Ability to send images in the chat*')
                        )
                      ],
                    ),
                    Row(
                      children: [
                        _buildStar(),
                        Flexible(
                          child: Text('Set a nickname so you can be recognized')
                        )
                      ],
                    ),
                    Row(
                      children: [
                        _buildStar(),
                        Flexible(
                          child: Text('Allow beautiful dark mode theme')
                        )
                      ],
                    ),
                    Row(
                      children: [
                        _buildStar(),
                        Flexible(
                          child: Text('Support this project')
                        )
                      ]
                    )
                  ]
                )
              )
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text('* Theres a very small chance of losing image data when sending on LAN.', 
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey
                ),
                textAlign: TextAlign.center,
              )
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Material(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.attach_money, color: Theme.of(context).primaryColor),
                        Container(width: 4),
                        Text('Purchase', style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20
                        ))
                      ]
                    )
                  ),
                  onTap: purchase,
                )
              )
            ),
            Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Text('Or watch an ad and unlock premium features for one hour.',
                textAlign: TextAlign.center
              )
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Material(
                color: Colors.green[300],
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.whatshot, color: Theme.of(context).accentColor),
                        Container(width: 4),
                        Text('Watch an ad', style: TextStyle(
                          fontSize: 20
                        ))
                      ]
                    )
                  ),
                  onTap: showAd
                )
              )
            )
          ]
        )
      )
    );
  }

  Widget _buildStar() => Padding(
    padding: const EdgeInsets.all(12),
    child: Icon(Icons.star, color: Colors.yellow[600]),
  );
}