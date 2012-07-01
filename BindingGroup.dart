class BindingGroup {
  ViewModelBinder _viewModelBinder;
  ViewModel _viewModel;
  List<Element> _baseElements;
  List<Element> _elements;
  List<BindingBase> _bindings;

  BindingGroup(ViewModelBinder viewModelBinder, ViewModel viewModel, Iterable<Element> baseElements)
    : _viewModelBinder = viewModelBinder, _viewModel = viewModel
  {
      _baseElements = new List<Element>.from(baseElements);
      _elements = new List<Element>();

      for (Element baseElement in baseElements) {
        _elements.add(baseElement);
        baseElement.queryAll('*').filter((e) => e is Element).forEach((Element e) => _elements.add(e));
      }

      _bindings = new List<BindingBase>();
  }

  void apply() {
    RegExp splitRegex = const RegExp(@"({[^}{]*})");

    for (Element subElement in _elements) {
      String bindString = subElement.attributes['data-bind'];

      if (bindString != null) {
        Iterable<Match> matches = splitRegex.allMatches(bindString);

        for (Match match in matches) {
          BindingDescription bindingDescription = new BindingDescription.parse(match[0]);

          if (bindingDescription.isValid) {
            ViewModel vm = _viewModel;

            if (bindingDescription.propertyNamePrecessors.length > 0) {
              bindingDescription.propertyNamePrecessors.forEach((s) => vm = vm[s]);
            }

            BindingBase binding = _viewModelBinder.createBinding(vm, subElement, bindingDescription);

            if (binding != null) {
              binding.apply();
              _bindings.add(binding);
            }
          }
        }
      }
    }
  }

  void unapply() {
    _bindings.forEach((BindingBase binding) => binding.unapply());
    _bindings.clear();
  }
}
