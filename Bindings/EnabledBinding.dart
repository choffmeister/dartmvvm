class EnabledBinding extends BindingBase {
  EnabledBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
  }

  void apply() {
    viewModel.addListener(_viewModelChanged);
    _setEnabled();
  }

  void unapply() {
    viewModel.removeListener(_viewModelChanged);
  }

  void _viewModelChanged(PropertyChangedEvent event) {
    _setEnabled();
  }

  void _setEnabled() {
    if (modelValue == true) {
      bindingDescription.element.attributes.remove('disabled');
    } else {
      bindingDescription.element.attributes['disabled'] = 'disabled';
    }
  }
}