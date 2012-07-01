class EnabledBinding extends BindingBase {
  EnabledBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
  }

  void onBind() {
    _setEnabled();
  }

  void onUnbind() {
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