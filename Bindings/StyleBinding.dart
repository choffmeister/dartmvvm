class StyleBinding extends BindingBase {
  StyleBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
  }

  void _applyStyle() {
    if (modelValue == true) {
      bindingDescription.parameters.filter((p) => p.key == 'toggleclass').forEach((p) {
        element.classes.add(p.value);
      });
    } else {
      bindingDescription.parameters.filter((p) => p.key == 'toggleclass').forEach((p) {
        element.classes.remove(p.value);
      });
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