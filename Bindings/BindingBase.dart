abstract class BindingBase implements BindingConverter, BindingValidator {
  ViewModelBinder _viewModelBinder;
  BindingDescription _bindingDescription;
  List<ValidationError> _validationErrors;

  ViewModelBinder get viewModelBinder() => _viewModelBinder;
  BindingDescription get bindingDescription() => _bindingDescription;
  List<ValidationError> get validationErrors() => _validationErrors;
  bool get hasErrors() => _validationErrors.length > 0;

  BindingBase(ViewModelBinder vmb, BindingDescription desc)
    : _viewModelBinder = vmb, _bindingDescription = desc, _validationErrors = new List<ValidationError>()
  {
    desc.bindingInstance = this;
  }

  bool validate(Object value) {
    bool foundError = false;
    _validationErrors.clear();

    for (BindingValidator vali in _bindingDescription.validatorInstances) {
      try {
        vali.validate(value);
      } catch (ValidationError e) {
        _validationErrors.add(e);
        foundError = true;
        print(e);
      }
    }

    return !foundError;
  }

  Object convertFromModel(Object value) {
    for (BindingConverter conv in _bindingDescription.converterInstances) {
      value = conv.convertFromModel(value);
    }
    return value;
  }

  Object convertToModel(Object value) {
    for (BindingConverter conv in _bindingDescription.converterInstances) {
      value = conv.convertToModel(value);
    }
    return value;
  }

  abstract void apply();
  abstract void unapply();
}