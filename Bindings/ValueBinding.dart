class ValueBinding extends BindingBase {
  InputElement _inputElement;

  ValueBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
    _inputElement = element;
  }

  void apply() {
    viewModel.addListener(_viewModelChanged);
    _inputElement.on.change.add(_elementChanged);
    _inputElement.value = modelValue;
  }

  void unapply() {
    viewModel.removeListener(_viewModelChanged);
    _inputElement.on.change.remove(_elementChanged);
  }

  void _viewModelChanged(PropertyChangedEvent event) {
    if (event.propertyName == propertyName) {
      _inputElement.value = modelValue;
    }
  }

  void _elementChanged(Event event) {
    modelValue = _inputElement.value;
  }
}