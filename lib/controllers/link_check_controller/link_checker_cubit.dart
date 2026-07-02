import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/vt_link_result.dart';
import '../../services/virustotal_service.dart';
part 'link_checker_state.dart';

class LinkCheckerCubit extends Cubit<LinkCheckerState> {
  LinkCheckerCubit() : super(const LinkCheckerState());

  final VirusUrlService _service = VirusUrlService();

  Future<void> scanLink(String url) async {
    emit(
      state.copyWith(
        status: LinkCheckerStatus.loading,
        result: null,
        error: null,
      ),
    );

    try {
      final result = await _service.scanUrl(url);

      emit(
        state.copyWith(
          status: LinkCheckerStatus.success,
          result: result,
          history: [result, ...state.history],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LinkCheckerStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  void clearHistory() {
    emit(
      state.copyWith(
        history: [],
      ),
    );
  }
}