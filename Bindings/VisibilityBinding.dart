class VisibilityBinding extends BindingBase {
  VisibilityBinding(ViewModelBinder vmb, BindingDescription desc)
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
    _toView();
  }

  void _toView() {
    if (convertFromModel(bindingDescription.viewModel[bindingDescription.propertyName]) == true) {
      bindingDescription.element.style.removeProperty('display');
    } else {
      bindingDescription.element.style.display = 'none';
    }
  }
}