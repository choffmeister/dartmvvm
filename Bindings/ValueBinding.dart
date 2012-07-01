class ValueBinding extends BindingBase {
  InputElement _inputElement;
  // due to a bug (see http://code.google.com/p/dart/issues/detail?id=144)
  Function _elementChanged2;

  ValueBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
    _inputElement = element;
    _elementChanged2 = _elementChanged;
  }

  void onApply() {
    _inputElement.on.change.add(_elementChanged2);
    _inputElement.value = modelValue;
  }

  void onUnapply() {
    _inputElement.on.change.remove(_elementChanged2);
  }

  void onModelChanged() {
    _inputElement.value = modelValue;
  }

  void _elementChanged(Event event) {
    modelValue = _inputElement.value;
  }
}