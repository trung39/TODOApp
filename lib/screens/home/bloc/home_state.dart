part of 'home_bloc.dart';

class HomeState extends Equatable {

  const HomeState(
      {this.currentPage = 0});

  @override
  List<Object> get props => [
    currentPage
  ];

  final int currentPage;
  HomeState copyWith({
    int? currentPage,
  }) {
    return HomeState(
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
