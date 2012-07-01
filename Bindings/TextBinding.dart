class TextBinding extends BindingBase {
  TextBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
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