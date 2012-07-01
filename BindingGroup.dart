class BindingGroup {
  ViewModelBinder _viewModelBinder;
  ViewModel _viewModel;
  List<Element> _elements;
  List<BindingBase> _bindings;

  BindingGroup(ViewModelBinder viewModelBinder, ViewModel viewModel, Collection<Element> elements)
    : _viewModelBinder = viewModelBinder, _viewModel = viewModel
  {
      _elements = new List<Element>.from(elements);
      _bindings = new List<BindingBase>();
  }

  void apply() {
    RegExp splitRegex = const RegExp(@"({[^}{]*})");

    for (Element element in _elements) {
      element.attributes.forEach((attrKey, attrValue) {
        if (attrKey.startsWith('data-bind')) {
          Iterable<Match> matches = splitRegex.allMatches(attrValue);

          for (Match match in matches) {
            BindingDescription bindingDescription = new BindingDescription.parse(attrKey, match[0]);

            if (bindingDescription.isValid) {
              ViewModel vm = _viewModel;

              if (bindingDescription.propertyNamePrecessors.length > 0) {
                bindingDescription.propertyNamePrecessors.forEach((s) => vm = vm[s]);
              }

              BindingBase binding = _viewModelBinder.createBinding(vm, element, bindingDescription);

              if (binding != null) {
                binding.apply();
                _bindings.add(binding);
              }
            }
          }
        }
      });
    }
  }

  void unapply() {
    _bindings.forEach((BindingBase binding) => binding.unapply());
    _bindings.clear();
  }
}