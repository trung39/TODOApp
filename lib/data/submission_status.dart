import 'package:equatable/equatable.dart';

/// The status of actions.
/// Including initial, submitting, success and failed status
abstract class SubmissionStatus extends Equatable {
  final String message;
  const SubmissionStatus({String? message}) : message = message ?? "";
  @override
  List<Object?> get props => [];
}

class InitialStatus extends SubmissionStatus {
  const InitialStatus();

  @override
  String toString() {
    return 'InitialStatus{}';
  }
}

class Submitting extends SubmissionStatus {
  const Submitting({String? message}): super(message: message);

  @override
  String toString() {
    return 'Submitting{}';
  }
}

class SubmissionSuccess extends SubmissionStatus {
  const SubmissionSuccess({String? message}): super(message: message);
  @override
  String toString() {
    return 'SubmissionSuccess{}';
  }
}

class SubmissionFailed extends SubmissionStatus {
  const SubmissionFailed({String? message}): super(message: message);
  @override
  String toString() {
    return 'SubmissionFailed{}';
  }
}
