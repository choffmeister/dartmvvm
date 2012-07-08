class EnabledBinding extends BindingBase {
  EnabledBinding(ViewModelBinder vmb, BindingGroup bg, BindingDescription desc)
    : super(vmb, bg, desc)
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