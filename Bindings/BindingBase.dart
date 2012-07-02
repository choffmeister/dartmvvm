class BindingCounter {
  static int _count = 0;
  static int get count() => _count;

  static void increaseCounter() {
    _count++;
    print('++ Active bindings: $_count');
  }

  static void decreaseCounter() {
    _count--;
    print('-- Active bindings: $_count');
  }
}

abstract class BindingBase {
  ViewModelBinder _viewModelBinder;
  BindingDescription _bindingDescription;
  List<ValidationError> _validationErrors;

  ViewModelBinder get viewModelBinder() => _viewModelBinder;
  BindingDescription get bindingDescription() => _bindingDescription;
  List<ValidationError> get validationErrors() => _validationErrors;
  bool get hasErrors() => _validationErrors.length > 0;

  Object get model() => _bindingDescription.model;
  String get propertyName() => _bindingDescription.propertyName;
  Element get element() => _bindingDescription.element;

  // due to a bug (see http://code.google.com/p/dart/issues/detail?id=144)
  Function _viewModelChanged2;

  BindingBase(ViewModelBinder vmb, BindingDescription desc)
    : _viewModelBinder = vmb, _bindingDescription = desc, _validationErrors = new List<ValidationError>()
  {
    desc.bindingInstance = this;
    _viewModelChanged2 = _viewModelChanged;
  }

  void bind() {
    if (model is ViewModel) {
      ViewModel viewModel = model;
      viewModel.addListener(_viewModelChanged2);
    }
    onBind();
    BindingCounter.increaseCounter();
  }

  void unbind() {
    BindingCounter.decreaseCounter();
    onUnbind();
    if (model is ViewModel) {
      ViewModel viewModel = model;
      viewModel.removeListener(_viewModelChanged2);
    }
  }

  void _viewModelChanged(PropertyChangedEvent event) {
    if (event.propertyName == propertyName) {
      onModelChanged();
    }
  }

  abstract void onBind();
  abstract void onUnbind();
  abstract void onModelChanged();

  get modelValue() {
    var value;

    if (_bindingDescription.propertyName != '\$this') {
      if (model is ViewModel) {
        ViewModel viewModel = model;
        value = viewModel[_bindingDescription.propertyName];
      } else {
        throw 'Cannot navigate through properties of non ViewModel classes';
      }
    } else {
      value = model;
    }

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

        if (_bindingDescription.propertyName != '\$this') {
          if (model is ViewModel) {
            ViewModel viewModel = model;
            viewModel[_bindingDescription.propertyName] = value;
          } else {
            throw 'Cannot navigate through properties of non ViewModel classes';
          }
        } else {
          throw 'Cannot write to \$this binding';
        }
      } catch (ValidationError e) {
        _validationErrors.add(e);
        print(e);
      }
    }
  }
}