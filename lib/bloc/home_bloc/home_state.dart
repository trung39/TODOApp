part of 'home_bloc.dart';

class HomeState extends Equatable {

  const HomeState(
      {this.currentPage = 0,
        this.status = const InitialStatus()
      });

  @override
  List<Object> get props => [
    currentPage, status
  ];

  final int currentPage;
  final SubmissionStatus status;
  HomeState copyWith({
    int? currentPage,
    SubmissionStatus? status
  }) {
    return HomeState(
      currentPage: currentPage ?? this.currentPage,
      status: status ?? this.status
    );
  }

  @override
  String toString() {
    return 'HomeState{currentPage: $currentPage, status: $status}';
  }
}
