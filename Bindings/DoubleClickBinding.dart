typedef void DoubleClickHandler(Object model, MouseEvent event);

class DoubleClickBinding extends BindingBase {
  DoubleClickHandler _doubleClickHandler;
  // due to a bug (see http://code.google.com/p/dart/issues/detail?id=144)
  Function _elementDoubleClicked2;

  DoubleClickBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
    _elementDoubleClicked2 = _elementClicked;
  }

  void onBind() {
    bindingDescription.element.on.doubleClick.add(_elementDoubleClicked2);
    _doubleClickHandler = modelValue;
  }

  void onUnbind() {
    bindingDescription.element.on.doubleClick.remove(_elementDoubleClicked2);
  }

  void onModelChanged() {
    _doubleClickHandler = modelValue;
  }

  void _elementClicked(MouseEvent event) {
    if (_doubleClickHandler != null) {
      _doubleClickHandler(model, event);
      event.preventDefault();
    }
  }
}