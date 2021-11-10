import 'package:formz/formz.dart';

enum MessageInputError {invalid, tooLong}

class MessageInput extends FormzInput<String, MessageInputError> {

  const MessageInput.pure() : super.pure('');
  const MessageInput.dirty([String value = '']) : super.dirty(value);

  @override
  MessageInputError? validator(String? value) {
    if(value == null || value.isEmpty) return MessageInputError.invalid;
    if(value.length > 50000) return MessageInputError.tooLong;
    return null;
  }
}