class TextBinding extends BindingBase {
  TextBinding(ViewModelBinder vmb, BindingGroup bg, BindingDescription desc)
    : super(vmb, bg, desc)
  {
  }

  void onBind() {
    onModelChanged();
  }

  void onUnbind() {
  }

  void onModelChanged() {
    if (bindingDescription.parameters.some((p) => p.key == 'html' && p.value == 'true')) {
      element.innerHTML = modelValue;
    } else {
      element.text = modelValue;
    }
  }
}