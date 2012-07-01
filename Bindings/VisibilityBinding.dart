class VisibilityBinding extends BindingBase {
  VisibilityBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
  }

  void onBind() {
    _setVisibility();
  }

  void onUnbind() {
  }

  void onModelChanged() {
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