import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'detail_tv_event.dart';
part 'detail_tv_state.dart';

class DetailTvBloc extends Bloc<DetailTvEvent, DetailTvState> {
  final GetTvDetail _detailTv;

  DetailTvBloc(this._detailTv) : super(DetailTvEmpty()) {
    on<OnDetailTv>((event, emit) async {
      emit(DetailTvLoading());
      final result = await _detailTv.execute(event.id);

      result.fold(
        (failure) {
          emit(DetailTvError(failure.message));
        },
        (data) {
          emit(DetailTvHasData(data));
        },
      );
    });
  }
}
