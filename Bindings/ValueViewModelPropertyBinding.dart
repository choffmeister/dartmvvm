class ValueViewModelPropertyBinding extends ViewModelPropertyBindingBase {
  InputElement _inputElement;

  ValueViewModelPropertyBinding(ViewModelBinder viewModelBinder, ViewModel viewModel, ViewModelBindingDescription bindingDescription, Element element)
    : super(viewModelBinder, viewModel, bindingDescription, element)
  {
    if (element is InputElement) {
      _inputElement = element;
      _inputElement.value = viewModel[bindingDescription.propertyName];
    } else {
      throw 'Value bindings can only be applied to input elements';
    }
  }

  void apply() {
    viewModel.addListener(_viewModelChanged);
    _inputElement.on.change.add(_elementChanged);
  }

  void unapply() {
    viewModel.removeListener(_viewModelChanged);
    _inputElement.on.change.remove(_elementChanged);
  }

  void _viewModelChanged(PropertyChangedEvent event) {
    if (event.propertyName == bindingDescription.propertyName) {
      _inputElement.value = event.newValue;
    }
  }

  void _elementChanged(Event event) {
    viewModel[bindingDescription.propertyName] = _inputElement.value;
  }
}