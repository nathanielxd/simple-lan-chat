import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lan_chat/lan_chat.dart';
import 'package:simple_lan_chat/file_message/file_message.dart';

class FileMessageView extends StatelessWidget {
  const FileMessageView(
    this.message, {
    super.key,
    this.isOwn = false,
    this.username = '',
  });

  final ReceivedMessage message;
  final bool isOwn;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Align(
        alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 1.4,
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
            padding: !isOwn ? const EdgeInsets.all(15) : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: isOwn
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isOwn)
                  Text(
                    username.isNotEmpty ? username : message.address,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                if (!isOwn) const SizedBox(height: 5),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Icon(
                        Icons.file_present_sharp,
                        color: isOwn ? Colors.white : Colors.black,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        utf8.decode(message.data.fileName!),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isOwn ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: BlocBuilder<FileMessageCubit, FileMessageStatus>(
                          builder: (context, state) {
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: state == FileMessageStatus.downloaded
                                  ? Icon(
                                      Icons.download_done_rounded,
                                      key: ValueKey('${message}downloaded'),
                                      color:
                                          isOwn ? Colors.white : Colors.black,
                                    )
                                  : Icon(
                                      Icons.download_rounded,
                                      key: ValueKey('${message}download'),
                                      color:
                                          isOwn ? Colors.white : Colors.black,
                                    ),
                            );
                          },
                        ),
                      ),
                      onTap: () => context.read<FileMessageCubit>().openFile(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
