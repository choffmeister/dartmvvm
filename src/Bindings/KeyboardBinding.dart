typedef void KeyboardHandler(Object model, KeyboardEvent event);

class KeyboardBinding extends BindingBase {
  KeyboardHandler _keyboardHandler;
  // due to a bug (see http://code.google.com/p/dart/issues/detail?id=144)
  Function _elementKeyboard2;

  KeyboardBinding(ViewModelBinder vmb, BindingGroup bg, BindingDescription desc)
    : super(vmb, bg, desc)
  {
      _elementKeyboard2 = _elementKeyboard;
  }

  void onBind() {
    bindingDescription.element.on.keyDown.add(_elementKeyboard2);
    bindingDescription.element.on.keyUp.add(_elementKeyboard2);
    bindingDescription.element.on.keyPress.add(_elementKeyboard2);
    _keyboardHandler = modelValue;
  }

  void onUnbind() {
    bindingDescription.element.on.keyDown.remove(_elementKeyboard2);
    bindingDescription.element.on.keyUp.remove(_elementKeyboard2);
    bindingDescription.element.on.keyPress.remove(_elementKeyboard2);
  }

  void onModelChanged() {
    _keyboardHandler = modelValue;
  }

  void _elementKeyboard(KeyboardEvent event) {
    if (_keyboardHandler != null) {
      _keyboardHandler(model, event);
    }
  }
}