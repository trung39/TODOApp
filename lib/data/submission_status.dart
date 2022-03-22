
/// The status of actions.
/// Including initial, submitting, success and failed status
abstract class SubmissionStatus {
  const SubmissionStatus();
}

class InitialStatus extends SubmissionStatus {
  const InitialStatus();

  @override
  String toString() {
    return '';
  }
}

class Submitting extends SubmissionStatus {
  final String message;

  Submitting({this.message = ''});

  @override
  String toString() {
    return message;
  }
}

class SubmissionSuccess extends SubmissionStatus {
  String? message;

  SubmissionSuccess({this.message});

  @override
  String toString() {
    return message ?? '';
  }
}

class SubmissionFailed extends SubmissionStatus {
  final String? message;

  SubmissionFailed({this.message});

  @override
  String toString() {
    return message ?? '';
  }
}
