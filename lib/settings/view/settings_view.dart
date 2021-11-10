import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_lan_chat/settings/settings.dart';

class SettingsView extends StatelessWidget {

  SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColor,
                child: Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Icon(Icons.navigate_before_rounded,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () => Navigator.of(context).pop()
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text('Settings', 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700
                        )
                      )
                    )
                  ]
                )
              )
            ),
            BlocBuilder<SettingsCubit, SettingsState>(
              buildWhen: (previous, current) => previous.username != current.username,
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).backgroundColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text('Username', style: Theme.of(context).textTheme.headline3),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Material(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20),
                            child: TextFormField(
                              initialValue: state.username.value,
                              cursorColor: Colors.white,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'enter your username',
                                errorText: state.username.invalid ? state.username.error : null,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(15),
                                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                              ),
                              onChanged: (value) => context.read<SettingsCubit>().usernameChanged(value)
                            )
                          )
                        )
                      ]
                    )
                  )
                );
              }
            ),
            BlocBuilder<SettingsCubit, SettingsState>(
              buildWhen: (previous, current) => previous.connections != current.connections,
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).backgroundColor,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text('Connections', style: Theme.of(context).textTheme.headline3),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(state.connections.length.toString(), style: Theme.of(context).textTheme.headline3)
                            )
                          ]
                        ),
                        Column(
                          children: List.generate(state.connections.length, 
                            (index) => ConnectionWidget(state.connections[index], state.ownConnection.address)
                          ),
                        )
                      ]
                    )
                  )
                );
              }
            )
          ]
        )
      )
    );
  }
}