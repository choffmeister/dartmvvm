typedef void ClickHandler(MouseEvent event);

class ClickBinding extends BindingBase {
  ClickHandler _clickHandler;

  ClickBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
  }

  void onApply() {
    bindingDescription.element.on.click.add(_elementClicked);
    _clickHandler = modelValue;
  }

  void onUnapply() {
    bindingDescription.element.on.click.remove(_elementClicked);
  }

  void onModelChanged() {

  }

  void _elementClicked(MouseEvent event) {
    if (_clickHandler != null) {
      _clickHandler(event);
      event.preventDefault();
    }
  }
}