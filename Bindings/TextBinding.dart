class TextBinding extends BindingBase {
  TextBinding(ViewModelBinder vmb, BindingGroup bg, BindingDescription desc)
    : super(vmb, bg, desc)
  {
  }

  void onBind() {
    element.text = modelValue;
  }

  void onUnbind() {
  }

  void onModelChanged() {
    element.text = modelValue;
  }
}