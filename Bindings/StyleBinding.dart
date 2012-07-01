class StyleBinding extends BindingBase {
  String _cssClass;

  StyleBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
      BindingParameter param = null;
      desc.parameters.filter((p) => p.key == 'type').forEach((p) => param = p);

      _cssClass = param.options;
  }

  void _applyStyle() {
    if (modelValue == true) {
      element.classes.add(_cssClass);
    } else {
      element.classes.remove(_cssClass);
    }
  }

  void apply() {
    viewModel.addListener(_viewModelChanged);
    _applyStyle();
  }

  void unapply() {
    viewModel.removeListener(_viewModelChanged);
  }

  void _viewModelChanged(PropertyChangedEvent event) {
    if (event.propertyName == propertyName) {
      _applyStyle();
    }
  }
}