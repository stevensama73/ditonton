import 'package:ditonton/presentation/bloc/airing_today_tv_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class AiringTodayTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/airing-today-tv';

  @override
  _AiringTodayTvPageState createState() => _AiringTodayTvPageState();
}

class _AiringTodayTvPageState extends State<AiringTodayTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AiringTodayTvBloc>().add(OnAiringTodayTv()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airing Today Tv'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<AiringTodayTvBloc, AiringTodayTvState>(
          builder: (context, state) {
            if (state is AiringTodayTvLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is AiringTodayTvHasData) {
              final result = state.result;
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final tv = result[index];
                  return TvCard(tv);
                },
                itemCount: result.length,
              );
            } else if (state is AiringTodayTvError) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
