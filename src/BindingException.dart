class BindingException implements Exception {
  final String _msg;
  final BindingDescription _bd;
  final Exception _inner;

  const BindingException(String msg, BindingDescription bd, [Exception inner = null]) : _msg = msg, _bd = bd, _inner = inner;

  String toString() {
    if (_inner != null) {
      return 'Exception: $_msg\nBinding: ${_bd.toString()}\n${_inner.toString()}';
    } else {
      return 'Exception: $_msg\nBinding: ${_bd.toString()}';
    }
  }
}