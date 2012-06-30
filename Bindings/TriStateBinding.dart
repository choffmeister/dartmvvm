class TriStateBinding extends BindingBase {
  final _valueRotation = const [0, 1, -1];

  TriStateBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
  }

  void apply() {
    viewModel.addListener(_viewModelChanged);
    element.on.click.add(_elementClicked);

    var curr = modelValue;
    if (curr != 1 && curr != -1 && curr != 0) modelValue = 0;
    element.attributes['data-tristate'] = _mapValueToState(modelValue);
  }

  void unapply() {
    viewModel.removeListener(_viewModelChanged);
    element.on.click.remove(_elementClicked);
  }

  void _viewModelChanged(PropertyChangedEvent event) {
    if (event.propertyName == propertyName) {
      element.attributes['data-tristate'] = _mapValueToState(modelValue);
    }
  }

  void _elementClicked(Event event) {
    modelValue = _toggleValue(modelValue);
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