class ValueBinding extends BindingBase {
  InputElement _inputElement;

  ValueBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
    _inputElement = element;
  }

  void onApply() {
    _inputElement.on.change.add(_elementChanged);
    _inputElement.value = modelValue;
  }

  void onUnapply() {
    _inputElement.on.change.remove(_elementChanged);
  }

  void onModelChanged() {
    _inputElement.value = modelValue;
  }

  void _elementChanged(Event event) {
    modelValue = _inputElement.value;
  }
}