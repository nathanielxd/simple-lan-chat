import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'image_message_state.dart';

class ImageMessageCubit extends Cubit<ImageMessageState> {
  ImageMessageCubit() : super(ImageMessageState());
  
}