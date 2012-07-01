class TextBinding extends BindingBase {
  TextBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
  }

  void onApply() {
    element.text = modelValue;
  }

  void onUnapply() {
  }

  void onModelChanged() {
    element.text = modelValue;
  }
}