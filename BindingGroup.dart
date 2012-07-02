class BindingGroup {
  ViewModelBinder _viewModelBinder;
  Object _model;
  List<Element> _elements;
  List<BindingBase> _bindings;

  BindingGroup(ViewModelBinder viewModelBinder, Object model, Collection<Element> elements)
    : _viewModelBinder = viewModelBinder, _model = model
  {
      _elements = new List<Element>.from(elements);
      _bindings = new List<BindingBase>();
  }

  void bind() {
    RegExp splitRegex = const RegExp(@"({[^}{]*})");

    for (Element element in _elements) {
      element.attributes.forEach((attrKey, attrValue) {
        if (attrKey.startsWith('data-bind')) {
          Iterable<Match> matches = splitRegex.allMatches(attrValue);

          for (Match match in matches) {
            BindingDescription bindingDescription = new BindingDescription.parse(attrKey, match[0]);

            if (bindingDescription.isValid) {
              Object m = _model;

              if (bindingDescription.propertyNamePrecessors.length > 0) {
                if (m is ViewModel) {
                  bindingDescription.propertyNamePrecessors.forEach((s) => m = m[s]);
                } else {
                  throw 'Cannot navigate through properties of non ViewModel classes';
                }
              }

              BindingBase binding = _viewModelBinder.createBinding(m, element, bindingDescription);

              if (binding != null) {
                binding.bind();
                _bindings.add(binding);
              }
            }
          }
        }
      });
    }
  }

  void unbind() {
    while (_bindings.length > 0) {
      _bindings.removeLast().unbind();
    }
  }
}