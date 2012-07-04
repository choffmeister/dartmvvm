class BindingGroupCounter {
  static int _count = 0;
  static int get count() => _count;

  static void increaseCounter() {
    _count++;
    print('++ Active bindinggroups: $_count');
  }

  static void decreaseCounter() {
    _count--;
    print('-- Active bindinggroups: $_count');
  }
}

class BindingGroup {
  final ViewModelBinder _viewModelBinder;
  final BindingGroup _parentGroup;
  final Object _model;
  List<Element> _elements;
  List<BindingBase> _bindings;

  BindingGroup(ViewModelBinder viewModelBinder, BindingGroup parentGroup, Object model, Collection<Element> elements)
    : _viewModelBinder = viewModelBinder, _parentGroup = parentGroup, _model = model
  {
      if (model == null) {
        throw new BindingException('The model cannot be null', null);
      }

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
              BindingBase binding = _viewModelBinder.createBinding(this, _model, element, bindingDescription);
              binding.bind();
              _bindings.add(binding);
            }
          }
        }
      });
    }
    //BindingGroupCounter.increaseCounter();
  }

  void unbind() {
    //BindingGroupCounter.decreaseCounter();
    while (_bindings.length > 0) {
      _bindings.removeLast().unbind();
    }
  }
}