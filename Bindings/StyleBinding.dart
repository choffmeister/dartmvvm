class StyleBinding extends BindingBase {
  StyleBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
  }

  void onApply() {
    _applyStyle();
  }

  void onUnapply() {
  }

  void onModelChanged() {
    _applyStyle();
  }

  void _applyStyle() {
    if (modelValue == true) {
      bindingDescription.parameters.filter((p) => p.key == 'toggleclass').forEach((p) {
        element.classes.add(p.value);
      });
    } else {
      bindingDescription.parameters.filter((p) => p.key == 'toggleclass').forEach((p) {
        element.classes.remove(p.value);
      });
    }
  }
}