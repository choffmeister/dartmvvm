class ValueBinding extends BindingBase {
  InputElement _inputElement;

  ValueBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
    _inputElement = desc.element;
  }

  void apply() {
    bindingDescription.viewModel.addListener(_viewModelChanged);
    _inputElement.on.change.add(_elementChanged);
    _toView();
  }

  void unapply() {
    bindingDescription.viewModel.removeListener(_viewModelChanged);
    _inputElement.on.change.remove(_elementChanged);
  }

  void _viewModelChanged(PropertyChangedEvent event) {
    if (event.propertyName == bindingDescription.propertyName) {
      _toView();
    }
  }

  void _elementChanged(Event event) {
    _toModel();
  }

  void _toView() {
    var converted = convertFromModel(bindingDescription.viewModel[bindingDescription.propertyName]);
    _inputElement.value = converted;
  }

  void _toModel() {
    String newValue = _inputElement.value;

    if (validate(newValue)) {
      bindingDescription.viewModel[bindingDescription.propertyName] = convertToModel(newValue);
      _toView();
    }
  }
}