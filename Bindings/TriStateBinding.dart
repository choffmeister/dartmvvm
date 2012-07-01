class TriStateBinding extends BindingBase {
  final _valueRotation = const [0, 1, -1];
  // due to a bug (see http://code.google.com/p/dart/issues/detail?id=144)
  Function _elementClicked2;

  TriStateBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
    _elementClicked2 = _elementClicked;
  }

  void onBind() {
    element.on.click.add(_elementClicked2);

    var curr = modelValue;
    if (curr != 1 && curr != -1 && curr != 0) modelValue = 0;
    element.attributes['data-tristate'] = _mapValueToState(modelValue);
  }

  void onUnbind() {
    element.on.click.remove(_elementClicked2);
  }

  void onModelChanged() {
    element.attributes['data-tristate'] = _mapValueToState(modelValue);
  }

  void _elementClicked(Event event) {
    modelValue = _toggleValue(modelValue);
  }

  String _mapValueToState(int value) {
    if (value > 0) {
      return 'yes';
    } else if (value < 0) {
      return 'no';
    } else {
      return 'none';
    }
  }

  int _toggleValue(int value) {
    if (value > 0) {
      return -1;
    } else if (value < 0) {
      return 0;
    } else {
      return 1;
    }
  }
}