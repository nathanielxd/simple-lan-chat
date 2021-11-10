import 'package:flutter/material.dart';
import 'package:simple_lan_chat/image_message/image_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageMessagePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
		return BlocProvider(
      create: (_) => ImageMessageCubit(),
      child: ImageMessageView()
    );
  }
}
  