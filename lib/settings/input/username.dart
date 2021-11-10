import 'package:formz/formz.dart';

class UsernameInput extends FormzInput<String, String> {

  const UsernameInput.pure() : super.pure('');
  const UsernameInput.dirty([String value = '']) : super.dirty(value);

  @override
  String? validator(String? value) {
    if(value != null && value.length > 20) return 'Max 20 characters.';
    return null;
  }
}