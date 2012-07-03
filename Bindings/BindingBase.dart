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
  final ViewModelBinder _viewModelBinder;
  final BindingGroup _bindingGroup;
  final BindingDescription _bindingDescription;
  _BindingTarget _target;
  List<ValidationError> _validationErrors;

  ViewModelBinder get viewModelBinder() => _viewModelBinder;
  BindingGroup get bindingGroup() => _bindingGroup;
  BindingDescription get bindingDescription() => _bindingDescription;
  List<ValidationError> get validationErrors() => _validationErrors;
  bool get hasErrors() => _validationErrors.length > 0;

  Object get model() => _bindingDescription.model;
  Element get element() => _bindingDescription.element;

  // due to a bug (see http://code.google.com/p/dart/issues/detail?id=144)
  Function _viewModelChanged2;

  BindingBase(ViewModelBinder vmb, BindingGroup bg, BindingDescription desc)
    : _viewModelBinder = vmb, _bindingGroup = bg, _bindingDescription = desc, _validationErrors = new List<ValidationError>()
  {
    desc.bindingInstance = this;
    _viewModelChanged2 = _viewModelChanged;
    _target = walkAccessor(_bindingGroup, _bindingDescription.model, _bindingDescription.accessor, _bindingDescription);
  }

  void bind() {
    if (_target.model is ViewModel) {
      ViewModel viewModel = _target.model;
      viewModel.addListener(_viewModelChanged2);
    }
    onBind();
    //BindingCounter.increaseCounter();
  }

  void unbind() {
    //BindingCounter.decreaseCounter();
    onUnbind();
    if (_target.model is ViewModel) {
      ViewModel viewModel = _target.model;
      viewModel.removeListener(_viewModelChanged2);
    }
  }

  void _viewModelChanged(PropertyChangedEvent event) {
    if (event.propertyName == _target.propertyName) {
      onModelChanged();
    }
  }

  abstract void onBind();
  abstract void onUnbind();
  abstract void onModelChanged();

  get modelValue() {
    var value;

    if (_target.propertyName != '\$this') {
      if (_target.model is ViewModel) {
        ViewModel viewModel = _target.model;
        value = viewModel[_target.propertyName];
      } else {
        throw 'Cannot navigate through properties of non ViewModel classes';
      }
    } else {
      value = _target.model;
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

        if (_target.propertyName != '\$this') {
          if (_target.model is ViewModel) {
            ViewModel viewModel = _target.model;
            viewModel[_target.propertyName] = value;
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

  _BindingTarget walkAccessor(BindingGroup startBindingGroup, Object startModel, String accessor, BindingDescription bd) {
    BindingGroup bg = startBindingGroup;
    Object m = startModel;

    List<String> accessorParts = accessor.split('.');
    String propertyName = accessorParts.removeLast();

    if (propertyName != '\$this') {
      bool prevAllowed = true;
      for (String accessorPart in accessorParts) {
        if (accessorPart == '\$this') {
          throw new BindingException('Accessor \'\$this\' is only allowed, if it is the one and only', bd);
        } else if (accessorPart == '\$prev') {
          if (prevAllowed) {
            if (bg._parentGroup != null) {
              bg = bg._parentGroup;
              m = bg._model;
            } else {
              throw new BindingException('Cannot navigate up, since the current binding group is already the root', bd);
            }
          } else {
            throw new BindingException('Acessor \'\$prev\' is only allowed at the beginning (more then one are allowed)', bd);
          }
        } else if (m is ViewModel) {
          prevAllowed = false;
          if (m.containsKey(accessorPart)) {
            m = m[accessorPart];
          } else {
            throw new BindingException('View model ${m} does not have a property \'${accessorPart}\'. It only has properties ${m.getKeys()}', bd);
          }
        } else {
          throw new BindingException('Cannot navigate through properties of Object ${m}, since it does not extend ViewModel', bd);
        }
      }

      if (m is ViewModel) {
        if (!m.containsKey(propertyName)) {
          throw new BindingException('View model ${m} does not have a property \'${propertyName}\'. It only has properties ${m.getKeys()}', bd);
        }
      } else {
        throw new BindingException('Object ${m} does not extend ViewModel', bd);
      }
    }

    return new _BindingTarget(m, propertyName);
  }
}

class _BindingTarget {
  final Object model;
  final String propertyName;

  _BindingTarget(this.model, this.propertyName);
}