class ValueBinding extends BindingBase {
  InputElement _inputElement;
  // due to a bug (see http://code.google.com/p/dart/issues/detail?id=144)
  Function _elementChanged2;
  Function _elementKeyboard2;

  ValueBinding(ViewModelBinder vmb, BindingGroup bg, BindingDescription desc)
    : super(vmb, bg, desc)
  {
    _inputElement = element;
    _elementChanged2 = _elementChanged;
    _elementKeyboard2 = _elementKeyboard;
  }

  void onBind() {
    _inputElement.on.change.add(_elementChanged2);
    _inputElement.value = modelValue;
  }

  void onUnbind() {
    _inputElement.on.change.remove(_elementChanged2);
  }

  void onModelChanged() {
    _inputElement.value = modelValue;
  }

  void _elementChanged(Event event) {
    modelValue = _inputElement.value;
  }

  void _elementKeyboard(KeyboardEvent event) {
    if (event.keyCode == 13) {
      modelValue = _inputElement.value;
    }
  }
}