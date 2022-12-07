part of 'detail_tv_bloc.dart';

abstract class DetailTvEvent extends Equatable {
  const DetailTvEvent();

  @override
  List<Object> get props => [];
}

class OnDetailTv extends DetailTvEvent {
  final int id;

  OnDetailTv(this.id);

  @override
  List<Object> get props => [id];
}
