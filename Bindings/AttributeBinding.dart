class AttributeBinding extends BindingBase {
  AttributeBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
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