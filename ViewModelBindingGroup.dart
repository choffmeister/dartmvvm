class ViewModelBindingGroup {
  ViewModelBinder _viewModelBinder;
  ViewModel _viewModel;
  List<Element> _baseElements;
  List<Element> _elements;
  List<ViewModelPropertyBindingBase> _bindings;

  ViewModelBindingGroup(ViewModelBinder viewModelBinder, ViewModel viewModel, Iterable<Element> baseElements)
    : _viewModelBinder = viewModelBinder, _viewModel = viewModel
  {
      _baseElements = new List<Element>.from(baseElements);
      _elements = new List<Element>();

      for (Element baseElement in baseElements) {
        _elements.add(baseElement);
        baseElement.queryAll('*').filter((e) => e is Element).forEach((Element e) => _elements.add(e));
      }

      _bindings = new List<ViewModelPropertyBindingBase>();
  }

  void apply() {
    RegExp splitRegex = const RegExp(@"({[^}{]*})");

    for (Element subElement in _elements) {
      String bindString = subElement.attributes['data-bind'];

      if (bindString != null) {
        Iterable<Match> matches = splitRegex.allMatches(bindString);

        for (Match match in matches) {
          ViewModelBindingDescription bindingDescription = new ViewModelBindingDescription.parse(match[0]);

          if (bindingDescription.isValid) {
            String propertyName = bindingDescription.propertyName;

            if (_viewModel.containsKey(propertyName)) {
              ViewModelPropertyBindingBase binding = _viewModelBinder.createBinding(_viewModel, bindingDescription, subElement);

              if (binding != null) {
                binding.apply();
                _bindings.add(binding);
              }
            } else {
              //TODO: make it configurable, if an exception should be thrown
              //throw 'View model does not have a property $propertyName';
            }
          }
        }
      }
    }
  }

  void unapply() {
    _bindings.forEach((ViewModelPropertyBindingBase binding) => binding.unapply());
    _bindings.clear();
  }
}
