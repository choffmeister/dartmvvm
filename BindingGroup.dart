class BindingGroup {
  ViewModelBinder _viewModelBinder;
  Object _model;
  List<Element> _elements;
  List<BindingBase> _bindings;

  BindingGroup(ViewModelBinder viewModelBinder, Object model, Collection<Element> elements)
    : _viewModelBinder = viewModelBinder, _model = model
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
              Object m = _model;

              if (bindingDescription.propertyName != '\$this') {
                for (String pnp in bindingDescription.propertyNamePrecessors) {
                  if (pnp == '\$this') {
                    throw new BindingException('Accessor \'\$this\' is only allowed, if it is the one and only', bindingDescription);
                  } else if (m is ViewModel) {
                    if (m.containsKey(pnp)) {
                      m = m[pnp];
                    } else {
                      throw new BindingException('View model ${m} does not have a property \'${pnp}\'. It only has properties ${m.getKeys()}', bindingDescription);
                    }
                  } else {
                    throw new BindingException('Cannot navigate through properties of Object ${m}, since it does not extend ViewModel', bindingDescription);
                  }
                }

                if (m is ViewModel) {
                  if (!m.containsKey(bindingDescription.propertyName)) {
                    throw new BindingException('View model ${m} does not have a property \'${bindingDescription.propertyName}\'. It only has properties ${m.getKeys()}', bindingDescription);
                  }
                } else {
                  throw new BindingException('Object ${m} does not extend ViewModel', bindingDescription);
                }
              } else if (bindingDescription.propertyNamePrecessors.length > 0) {
                throw new BindingException('Accessor \'\$this\' is only allowed, if it is the one and only', bindingDescription);
              }

              BindingBase binding = _viewModelBinder.createBinding(m, element, bindingDescription);
              binding.bind();
              _bindings.add(binding);
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