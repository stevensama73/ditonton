part of 'detail_bloc.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object> get props => [];
}

class OnDetail extends DetailEvent {
  final int id;

  OnDetail(this.id);

  @override
  List<Object> get props => [id];
}
