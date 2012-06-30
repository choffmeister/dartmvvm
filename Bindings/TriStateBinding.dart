class TriStateBinding extends BindingBase {
  final _valueRotation = const [0, 1, -1];

  TriStateBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
  }

  void apply() {
    bindingDescription.viewModel.addListener(_viewModelChanged);
    bindingDescription.element.on.click.add(_elementClicked);
    _toView();
  }

  void unapply() {
    bindingDescription.viewModel.removeListener(_viewModelChanged);
    bindingDescription.element.on.click.remove(_elementClicked);
  }

  void _viewModelChanged(PropertyChangedEvent event) {
    if (event.propertyName == bindingDescription.propertyName) {
      _toView();
    }
  }

  void _elementClicked(Event event) {
    _toModel();
  }

  void _toModel() {
    bindingDescription.viewModel[bindingDescription.propertyName] = _toggleValue(bindingDescription.viewModel[bindingDescription.propertyName]);
  }

  void _toView() {
    bindingDescription.element.attributes['data-tristate'] = _mapValueToState(bindingDescription.viewModel[bindingDescription.propertyName]);
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