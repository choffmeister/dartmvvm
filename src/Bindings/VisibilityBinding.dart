class VisibilityBinding extends BindingBase {
  VisibilityBinding(ViewModelBinder vmb, BindingGroup bg, BindingDescription desc)
    : super(vmb, bg, desc)
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