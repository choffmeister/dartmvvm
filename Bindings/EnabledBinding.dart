class EnabledBinding extends BindingBase {
  EnabledBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
  }

  void onApply() {
    _setEnabled();
  }

  void onUnapply() {
  }

  void onModelChanged() {
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