import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'signature_modal_state.dart';

class SignatureModalCubit extends Cubit<SignatureModalState> {
  Timer? _errorTimer;

  SignatureModalCubit(String signature)
      : super(
          SignatureModalState(
            signature: signature,
            status: SignatureModalStatus.idle,
          ),
        );

  Future<void> downloadSignature() async {
    if (state.status == SignatureModalStatus.downloading) return;
    _errorTimer?.cancel();
    _errorTimer = null;
    emit(state.copyWith(status: SignatureModalStatus.downloading, errorMessage: null));
    try {
      final bytes = Uint8List.fromList(utf8.encode(state.signature));
      final params = SaveFileDialogParams(
        fileName: 'wasla_digital_signature_${DateTime.now().millisecondsSinceEpoch}',
        data: bytes,
      );
      final savedPath = await FlutterFileDialog.saveFile(params: params);
      if (savedPath == null) {
        // User cancelled the dialog — go back to idle silently
        emit(state.copyWith(status: SignatureModalStatus.idle, errorMessage: null));
        return;
      }
      debugPrint('[SignatureModal] Signature downloaded successfully → $savedPath');
      emit(state.copyWith(status: SignatureModalStatus.downloaded));
    } catch (e) {
      emit(
        state.copyWith(
          status: SignatureModalStatus.downloadError,
          errorMessage: e.toString(),
        ),
      );
      _errorTimer = Timer(const Duration(seconds: 30), () {
        if (!isClosed) {
          emit(state.copyWith(
            status: SignatureModalStatus.idle,
            errorMessage: null,
          ));
        }
      });
    }
  }

  @override
  Future<void> close() {
    _errorTimer?.cancel();
    return super.close();
  }
}
