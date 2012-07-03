class FocusBinding extends BindingBase {
  InputElement _inputElement;
  // due to a bug (see http://code.google.com/p/dart/issues/detail?id=144)
  Function _elementFocusChanged2;

  FocusBinding(ViewModelBinder vmb, BindingGroup bg, BindingDescription desc)
    : super(vmb, bg, desc)
  {
    _inputElement = bindingDescription.element;
    _elementFocusChanged2 = _elementFocusChanged;
  }

  void onBind() {
    _inputElement.on.focus.add(_elementFocusChanged2);
    if (modelValue == true) {
      _inputElement.autofocus = true;
    }
  }

  void onUnbind() {
    _inputElement.on.focus.remove(_elementFocusChanged2);
  }

  void onModelChanged() {
    if (modelValue == true) {
      _inputElement.focus();
    } else {
      _inputElement.blur();
    }
  }

  void _elementFocusChanged(Event event) {
    //TODO: implement
  }
}