typedef void ClickHandler();

class ClickBinding extends BindingBase {
  ClickHandler _clickHandler;

  ClickBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
  }

  void apply() {
    bindingDescription.element.on.click.add(_elementClicked);
    _clickHandler = modelValue;
  }

  void unapply() {
    bindingDescription.element.on.click.remove(_elementClicked);
  }

  void _elementClicked(Event event) {
    if (_clickHandler != null) {
      _clickHandler();
      event.preventDefault();
    }
  }
}