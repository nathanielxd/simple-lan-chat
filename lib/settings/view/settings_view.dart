import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lan_chat_theme/lan_chat_theme.dart';
import 'package:simple_lan_chat/settings/settings.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const AppBarBasic(title: 'Settings'),
            _buildDonation(context),
            _buildUsername(context),
            _buildConnections(),
          ],
        ),
      ),
    );
  }

  Widget _buildDonation(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) =>
          previous.showDonation != current.showDonation,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(5),
          child: Material(
            borderRadius: kBorderRadius,
            color: context.colorScheme.background,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextTitle(
                    'Support this project',
                  ),
                  if (state.showDonation)
                    const Text(
                      'If you like this app and would like to support me and '
                      'my projects, I appreciate any help!\n\n'
                      'Upcoming features:\n'
                      '> Run in background support\n'
                      '> Support while hotspotting\n'
                      '> Windows and Mac support\n'
                      '> Multiple theme selector\n',
                    ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonBasic(
                        filled: false,
                        onPressed: () =>
                            context.read<SettingsCubit>().showDonationChanged(),
                        label: Text(state.showDonation ? 'Hide' : 'Show'),
                      ),
                      const SizedBox(width: 15),
                      ButtonBasic(
                        label: const Text('Buy me a coffee'),
                        onPressed: () => launchUrlString(
                          'https://ko-fi.com/nathanielxd',
                          mode: LaunchMode.externalApplication,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUsername(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(5),
          child: Material(
            borderRadius: kBorderRadius,
            color: Theme.of(context).colorScheme.background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: TextTitle(
                    'Username',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Material(
                    color: context.colorScheme.onPrimaryContainer,
                    borderRadius: kBorderRadius,
                    child: TextFormField(
                      initialValue: state.username.value,
                      cursorColor: context.colorScheme.surface,
                      style: TextStyle(color: context.colorScheme.surface),
                      decoration: InputDecoration(
                        hintText: 'enter your username',
                        errorText: state.username.displayError,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(15),
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      onChanged: (value) =>
                          context.read<SettingsCubit>().usernameChanged(value),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildConnections() {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) =>
          previous.connections != current.connections,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(5),
          child: Material(
            borderRadius: kBorderRadius,
            color: context.colorScheme.background,
            child: Column(
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: TextTitle(
                        'Connections',
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: TextTitle(
                        state.connections.length.toString(),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: List.generate(
                    state.connections.length,
                    (index) => ConnectionWidget(
                      state.connections[index],
                      state.ownConnection.address,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
