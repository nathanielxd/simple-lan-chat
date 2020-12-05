import 'package:awesomelanchat/logic/user_preferences.dart';
import 'package:awesomelanchat/logic/storefront.dart';
import 'package:awesomelanchat/view/others/custom_page_routes.dart';
import 'package:awesomelanchat/view/others/no_scroll_glow.dart';
import 'package:awesomelanchat/view/pages/premium_page.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          color: Theme.of(context).accentColor,
          icon: Icon(Icons.navigate_before),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Settings', 
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w600,
          )
        )
      ),
      body: ScrollConfiguration(
        behavior: NoScrollGlowBehavoir(),
        child: ListView(
          children: [
            if(!Storefront.isPremium)
            _buildItem('Premium', [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Text(
                  'Buy premium for ${Storefront.products[0].price} to unlock image-sharing, dark mode, ability to set nicknames, '
                  'and support me and this software.'
                )
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lock_open, color: Theme.of(context).primaryColor),
                            Container(width: 4),
                            Text('Unlock Premium', style: TextStyle(
                              color: Theme.of(context).primaryColor
                            ))
                          ]
                        )
                      ),
                      onTap: () => Navigator.of(context)
                        .push(popPageRoute((context) => PremiumPage()),
                      )
                    )
                  )
                )
              )
            ]),
            _buildItem('Nickname', [
              Material(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(12),
                child: TextFormField(
                  readOnly: !UserPreferences.isPremium,
                  initialValue: UserPreferences.nickname,
                  cursorColor: Theme.of(context).accentColor,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(16),
                    border: InputBorder.none,
                    hintText: 'Enter your nickname',
                    hintStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light ? Colors.grey[600] : Colors.grey[300]
                    )
                  ),
                  onTap: () {
                    if(!UserPreferences.isPremium) {
                      Navigator.of(context).push(popPageRoute((context) => PremiumPage()));
                    }
                  },
                  onFieldSubmitted: (value) async {
                    UserPreferences.nickname = value;
                    await UserPreferences.save();
                  },
                )
              )
            ]),
            _buildItem('Appereance', [
              CheckboxListTile(
                value: UserPreferences.isDarkmode,
                onChanged: (value) async {
                  if(UserPreferences.isPremium) {
                    setState(() => UserPreferences.isDarkmode = value);
                    await UserPreferences.save();
                    DynamicTheme.of(context).setBrightness(value ? Brightness.dark : Brightness.light);
                  }
                  else Navigator.of(context).push(popPageRoute((context) => PremiumPage()));
                },
                title: Text('Dark Mode', style: Theme.of(context).textTheme.bodyText2),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  children: [
                    Text('Font Size', style: TextStyle(
                      fontSize: 14
                    )),
                    Spacer(),
                    DropdownButton<int>(
                      value: UserPreferences.fontSize.toInt(),
                      items: [
                        DropdownMenuItem(
                          value: 12,
                          child: Text('12px', style: Theme.of(context).textTheme.bodyText2)
                        ),
                        DropdownMenuItem(
                          value: 14,
                          child: Text('14px', style: Theme.of(context).textTheme.bodyText2),
                        ),
                        DropdownMenuItem(
                          value: 16,
                          child: Text('16px', style: Theme.of(context).textTheme.bodyText2),
                        )
                      ],
                      onChanged: (value) async {
                        setState(() => UserPreferences.fontSize = value.toDouble());
                        await UserPreferences.save();
                      }
                    ),
                  ],
                ),
              )
            ])
          ]
        )
      )
    );
  }

  Widget _buildItem(String title, [List<Widget> children]) 
  => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(
            fontSize: 20,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w600
          )),
          Container(height: 4),
          ...children
        ]
      ),
  );
}