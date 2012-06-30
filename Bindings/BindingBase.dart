abstract class BindingBase {
  ViewModelBinder _viewModelBinder;
  BindingDescription _bindingDescription;
  List<ValidationError> _validationErrors;

  ViewModelBinder get viewModelBinder() => _viewModelBinder;
  BindingDescription get bindingDescription() => _bindingDescription;
  List<ValidationError> get validationErrors() => _validationErrors;
  bool get hasErrors() => _validationErrors.length > 0;

  ViewModel get viewModel() => _bindingDescription.viewModel;
  String get propertyName() => _bindingDescription.propertyName;
  Element get element() => _bindingDescription.element;

  BindingBase(ViewModelBinder vmb, BindingDescription desc)
    : _viewModelBinder = vmb, _bindingDescription = desc, _validationErrors = new List<ValidationError>()
  {
    desc.bindingInstance = this;
  }

  get modelValue() {
    var value = _bindingDescription.viewModel[_bindingDescription.propertyName];

    for (BindingConverter conv in _bindingDescription.converterInstances) {
      value = conv.convertFromModel(value);
    }

    return value;
  }

  set modelValue(var value) {
    bool foundValidationError = false;
    _validationErrors.clear();

    for (BindingValidator vali in _bindingDescription.validatorInstances) {
      try {
        vali.validate(value);
      } catch (ValidationError e) {
        _validationErrors.add(e);
        foundValidationError = true;
        print(e);
      }
    }

    if (!foundValidationError) {
      try {
        for (BindingConverter conv in _bindingDescription.converterInstances) {
          value = conv.convertToModel(value);
        }

        var oldValue = _bindingDescription.viewModel[_bindingDescription.propertyName];
        _bindingDescription.viewModel[_bindingDescription.propertyName] = value;
      } catch (ValidationError e) {
        _validationErrors.add(e);
        print(e);
      }
    }
  }

  abstract void apply();
  abstract void unapply();
}