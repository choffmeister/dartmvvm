class TextBinding extends BindingBase {
  TextBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
  }

  void apply() {
    viewModel.addListener(_viewModelChanged);
    element.text = modelValue;
  }

  void unapply() {
    viewModel.removeListener(_viewModelChanged);
  }

  void _viewModelChanged(PropertyChangedEvent event) {
    if (event.propertyName == propertyName) {
      element.text = modelValue;
    }
  }
}