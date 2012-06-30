class TriStateViewModelPropertyBinding extends ViewModelPropertyBindingBase {
  final _valueRotation = const [0, 1, -1];

  TriStateViewModelPropertyBinding(ViewModelBinder viewModelBinder, ViewModel viewModel, ViewModelBindingDescription bindingDescription, Element element)
    : super(viewModelBinder, viewModel, bindingDescription, element)
  {
    element.attributes['data-tristate'] = _mapValueToState(viewModel[bindingDescription.propertyName]);
  }

  void apply() {
    viewModel.addListener(_viewModelChanged);
    element.on.click.add(_elementClicked);
  }

  void unapply() {
    viewModel.removeListener(_viewModelChanged);
    element.on.click.remove(_elementClicked);
  }

  void _viewModelChanged(PropertyChangedEvent event) {
    if (event.propertyName == bindingDescription.propertyName) {
      element.attributes['data-tristate'] = _mapValueToState(viewModel[bindingDescription.propertyName]);
    }
  }

  void _elementClicked(Event event) {
    viewModel[bindingDescription.propertyName] = _toggleValue(viewModel[bindingDescription.propertyName]);
  }

  String _mapValueToState(int value) {
    if (value > 0) {
      return 'yes';
    } else if (value < 0) {
      return 'no';
    } else {
      return 'none';
    }
  }

  int _toggleValue(int value) {
    if (value > 0) {
      return -1;
    } else if (value < 0) {
      return 0;
    } else {
      return 1;
    }
  }
}