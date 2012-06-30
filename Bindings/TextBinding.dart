class TextBinding extends BindingBase {
  TextBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
  }

  void apply() {
    bindingDescription.viewModel.addListener(_viewModelChanged);
    _toView();
  }

  void unapply() {
    bindingDescription.viewModel.removeListener(_viewModelChanged);
  }

  void _viewModelChanged(PropertyChangedEvent event) {
    if (event.propertyName == bindingDescription.propertyName) {
      _toView();
    }
  }

  void _toView() {
    bindingDescription.element.text = convertFromModel(bindingDescription.viewModel[bindingDescription.propertyName]);
  }
}