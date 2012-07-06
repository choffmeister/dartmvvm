typedef void ClickHandler(Object model, MouseEvent event);

class ClickBinding extends BindingBase {
  ClickHandler _clickHandler;
  // due to a bug (see http://code.google.com/p/dart/issues/detail?id=144)
  Function _elementClicked2;

  ClickBinding(ViewModelBinder vmb, BindingGroup bg, BindingDescription desc)
    : super(vmb, bg, desc)
  {
    _elementClicked2 = _elementClicked;
  }

  void onBind() {
    bindingDescription.element.on.click.add(_elementClicked2);
    bindingDescription.element.style.setProperty('cursor', 'pointer');
    _clickHandler = modelValue;
  }

  void onUnbind() {
    bindingDescription.element.style.removeProperty('cursor');
    bindingDescription.element.on.click.remove(_elementClicked2);
  }

  void onModelChanged() {
    _clickHandler = modelValue;
  }

  void _elementClicked(MouseEvent event) {
    if (_clickHandler != null) {
      _clickHandler(model, event);
      event.preventDefault();
    }
  }
}