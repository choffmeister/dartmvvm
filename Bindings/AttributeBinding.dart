class AttributeBinding extends BindingBase {
  AttributeBinding(ViewModelBinder vmb, BindingGroup bg, BindingDescription desc)
    : super(vmb, bg, desc)
  {
  }

  void onBind() {
    _applyAttribute();
  }

  void onUnbind() {
  }

  void onModelChanged() {
    _applyAttribute();
  }

  void _applyAttribute() {
    bindingDescription.parameters.filter((p) => p.key == 'name').forEach((p) {
      element.attributes[p.value] = modelValue;
    });
  }
}