class StyleBinding extends BindingBase {
  StyleBinding(ViewModelBinder vmb, BindingGroup bg, BindingDescription desc)
    : super(vmb, bg, desc)
  {
  }

  void onBind() {
    _applyStyle();
  }

  void onUnbind() {
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