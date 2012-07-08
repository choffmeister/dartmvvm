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
    var newValue = modelValue;

    bindingDescription.parameters.filter((p) => p.key == 'toggleclass').forEach((p) {
      if (newValue == true) {
        element.classes.add(p.value);
      } else {
        element.classes.remove(p.value);
      }
    });

    bindingDescription.parameters.filter((p) => p.key == 'name').forEach((p) {
      element.style.setProperty(p.value, newValue);
    });
  }
}