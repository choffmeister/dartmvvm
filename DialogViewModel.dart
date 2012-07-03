class DialogViewModel extends ViewModel {
  final Completer<Object> _completer;

  Future<Object> get result() => _completer.future;

  DialogViewModel() : _completer = new Completer<Object>();

  Future<DialogViewModel> load() {
    return new Future<DialogViewModel>.immediate(this);
  }

  void finish([Object result]) {
    _completer.complete(result);
  }
}