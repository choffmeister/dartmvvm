interface ViewModelBinder default ViewModelBinderImpl {
  ViewModelBinder();

  BindingGroup createGroup(Object model, Element baseElement);

  BindingGroup createGroupOnSubElements(Object model, Element baseElement);

  BindingGroup createGroupOnMultipleElements(Object model, Collection<Element> baseElements);

  BindingBase createBinding(Object model, Element element, BindingDescription bindingDescription);
}

class ViewModelBinderImpl implements ViewModelBinder {
  ViewModel _viewModel;
  Element _element;

  BindingGroup createGroup(Object model, Element baseElement) {
    return new BindingGroup(this, ViewModel.from(model), _searchElements(baseElement));
  }

  BindingGroup createGroupOnSubElements(Object model, Element baseElement) {
    List<Element> elements = new List<Element>();
    baseElement.elements.forEach((e) => elements.addAll(_searchElements(e)));

    return new BindingGroup(this, ViewModel.from(model), elements);
  }

  BindingGroup createGroupOnMultipleElements(Object model, Collection<Element> baseElements) {
    List<Element> elements = new List<Element>();
    baseElements.forEach((e) => elements.addAll(_searchElements(e)));

    return new BindingGroup(this, ViewModel.from(model), elements);
  }

  List<Element> _searchElements(Element baseElement) {
    List<Element> result = new List<Element>();

    result.add(baseElement);

    if (!baseElement.attributes.containsKey('data-bind-foreach') &&
        !baseElement.attributes.containsKey('data-bind-scope') &&
        !baseElement.attributes.containsKey('data-bind-rest'))
    {
      for (Element subElement in baseElement.elements) {
        result.addAll(_searchElements(subElement));
      }
    }

    return result;
  }

  BindingBase createBinding(Object model, Element element, BindingDescription desc) {
    BindingBase binding = null;
    desc.model = model;
    desc.element = element;

    switch (desc.typeName) {
      case 'value': binding = new ValueBinding(this, desc); break;
      case 'click': binding = new ClickBinding(this, desc); break;
      case 'text': binding = new TextBinding(this, desc); break;
      case 'tristate': binding = new TriStateBinding(this, desc); break;
      case 'visibility': binding = new VisibilityBinding(this, desc); break;
      case 'foreach': binding = new ForeachBinding(this, desc); break;
      case 'style': binding = new StyleBinding(this, desc); break;
      case 'enabled': binding = new EnabledBinding(this, desc); break;
      case 'scope': binding = new ScopeBinding(this, desc); break;
      case 'attribute': binding = new AttributeBinding(this, desc); break;
      case 'rest': binding = new RestBinding(this, desc); break;
      default: throw 'Unknown binding type';
    }

    _attachConverters(desc);
    _attachValidators(desc);

    return binding;
  }

  void _attachConverters(BindingDescription desc) {
    for (BindingParameter conv in desc.parameters.filter((bp) => bp.key == 'conv')) {
      switch (conv.value) {
        case 'int': desc.converterInstances.add(new IntegerConverter()); break;
        case 'double': desc.converterInstances.add(new DoubleConverter()); break;
        case 'bool': desc.converterInstances.add(new BooleanConverter()); break;
        case 'guid': desc.converterInstances.add(new GuidConverter()); break;
        case 'not': desc.converterInstances.add(new NotConverter()); break;
        case 'notnull': desc.converterInstances.add(new NotNullConverter()); break;
        case 'stringformat': desc.converterInstances.add(new StringFormatConverter(conv)); break;
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