interface ViewModelBinder default ViewModelBinderImpl {
  ViewModelBinder();

  BindingGroup createGroup(ViewModel viewModel, Element baseElement);

  BindingGroup createGroupOnMultipleElements(ViewModel viewModel, Collection<Element> baseElements);

  BindingBase createBinding(ViewModel viewModel, Element element, BindingDescription bindingDescription);
}

class ViewModelBinderImpl implements ViewModelBinder {
  ViewModel _viewModel;
  Element _element;

  BindingGroup createGroup(ViewModel viewModel, Element baseElement) {
    return new BindingGroup(this, viewModel, _searchElements(baseElement));
  }

  BindingGroup createGroupOnMultipleElements(ViewModel viewModel, Collection<Element> baseElements) {
    List<Element> elements = new List<Element>();
    baseElements.forEach((e) => elements.addAll(_searchElements(e)));

    return new BindingGroup(this, viewModel, elements);
  }

  List<Element> _searchElements(Element baseElement) {
    List<Element> result = new List<Element>();

    result.add(baseElement);

    if (!baseElement.attributes.containsKey('data-bind-foreach')) {
      for (Element subElement in baseElement.elements) {
        result.addAll(_searchElements(subElement));
      }
    }

    return result;
  }

  BindingBase createBinding(ViewModel viewModel, Element element, BindingDescription desc) {
    BindingBase binding = null;
    desc.viewModel = viewModel;
    desc.element = element;

    if (desc.typeName != null) {
      switch (desc.typeName) {
        case 'value': binding = new ValueBinding(this, desc); break;
        case 'click': binding = new ClickBinding(this, desc); break;
        case 'text': binding = new TextBinding(this, desc); break;
        case 'tristate': binding = new TriStateBinding(this, desc); break;
        case 'visibility': binding = new VisibilityBinding(this, desc); break;
        case 'foreach': binding = new ForeachBinding(this, desc); break;
        case 'style': binding = new StyleBinding(this, desc); break;
        default: throw 'Unknown binding type';
      }
    } else {
      binding = _guessBindingType(desc);
    }

    if (binding != null) {
      _attachConverters(desc);
      _attachValidators(desc);
    }

    return binding;
  }

  BindingBase _guessBindingType(BindingDescription desc) {
    var boundProperty = desc.viewModel[desc.propertyName];

    if (desc.element is InputElement) {
      if (desc.element.attributes['type'].toLowerCase() == 'submit') {
        return new ClickBinding(this, desc);
      } else {
        return new ValueBinding(this, desc);
      }
    } else if (desc.element is ButtonElement) {
      return new ClickBinding(this, desc);
    } else if (boundProperty is ListViewModel || boundProperty is Iterable) {
      return new ForeachBinding(this, desc);
    }

    return new TextBinding(this, desc);
  }

  void _attachConverters(BindingDescription desc) {
    for (BindingParameter conv in desc.parameters.filter((bp) => bp.key == 'conv')) {
      switch (conv.value) {
        case 'int': desc.converterInstances.add(new IntegerConverter()); break;
        case 'double': desc.converterInstances.add(new DoubleConverter()); break;
        case 'bool': desc.converterInstances.add(new BooleanConverter()); break;
        case 'guid': desc.converterInstances.add(new GuidConverter()); break;
        case 'not': desc.converterInstances.add(new NotConverter()); break;
        default: throw 'Unknown converter type';
      }
    }

    if (desc.converterInstances.length == 0) {
      if (desc.bindingInstance is ValueBinding && desc.element is InputElement) {
        desc.converterInstances.add(new NormalizedStringConverter());
      } else if (desc.bindingInstance is TextBinding) {
        desc.converterInstances.add(new NormalizedStringConverter());
      }
    }
  }

  void _attachValidators(BindingDescription desc) {
    for (BindingParameter vali in desc.parameters.filter((bp) => bp.key == 'vali')) {
      switch (vali.value) {
        case 'int': desc.validatorInstances.add(new IntegerValidator()); break;
        case 'double': desc.validatorInstances.add(new DoubleValidator()); break;
        case 'bool': desc.validatorInstances.add(new BooleanValidator()); break;
        default: throw 'Unknown validator type';
      }
    }
  }
}