import 'package:flutter/material.dart';
import 'package:lan_chat_theme/lan_chat_theme.dart';

class AppBarBasic extends StatelessWidget {
  const AppBarBasic({
    required this.title,
    this.actions,
    super.key,
  });

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Material(
        borderRadius: kBorderRadius,
        color: context.colorScheme.onPrimaryContainer,
        child: Row(
          children: [
            if (Navigator.of(context).canPop())
              InkWell(
                borderRadius: kBorderRadius,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Icon(
                    Icons.navigate_before_rounded,
                    color: context.colorScheme.primaryContainer,
                  ),
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
            const SizedBox(
              width: 16,
            ),
            TextTitle(
              title,
              shade: TextShade.light,
            ),
            if (actions != null && actions!.isNotEmpty) const Spacer(),
            if (actions != null && actions!.isNotEmpty) ...actions!,
          ],
        ),
      ),
    );
  }
}
