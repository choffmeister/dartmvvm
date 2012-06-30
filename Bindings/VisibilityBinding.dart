class VisibilityBinding extends BindingBase {
  VisibilityBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
  }

  void apply() {
    viewModel.addListener(_viewModelChanged);
    _setVisibility();
  }

  void unapply() {
    viewModel.removeListener(_viewModelChanged);
  }

  void _viewModelChanged(PropertyChangedEvent event) {
    _setVisibility();
  }

  void _setVisibility() {
    if (modelValue == true) {
      bindingDescription.element.style.removeProperty('display');
    } else {
      bindingDescription.element.style.display = 'none';
    }
  }
}