typedef void ClickHandler(Object model, MouseEvent event);

class ClickBinding extends BindingBase {
  ClickHandler _clickHandler;
  // due to a bug (see http://code.google.com/p/dart/issues/detail?id=144)
  Function _elementClicked2;
  Function _elementDoubleClicked2;
  Function _elementMouseDown2;
  Function _elementMouseUp2;
  Function _elementContextMenu2;

  ClickBinding(ViewModelBinder vmb, BindingGroup bg, BindingDescription desc)
    : super(vmb, bg, desc)
  {
    _elementClicked2 = _elementClicked;
    _elementDoubleClicked2 = _elementDoubleClicked;
    _elementMouseDown2 = _elementMouseDown;
    _elementMouseUp2 = _elementMouseUp;
    _elementContextMenu2 = _elementContextMenu;
  }

  void onBind() {
    bindingDescription.element.on.click.add(_elementClicked2);
    bindingDescription.element.on.doubleClick.add(_elementDoubleClicked2);
    bindingDescription.element.on.mouseDown.add(_elementMouseDown2);
    bindingDescription.element.on.mouseUp.add(_elementMouseUp2);
    bindingDescription.element.on.contextMenu.add(_elementContextMenu2);
    bindingDescription.element.style.setProperty('cursor', 'pointer');
    _clickHandler = modelValue;
  }

  void onUnbind() {
    bindingDescription.element.style.removeProperty('cursor');
    bindingDescription.element.on.contextMenu.remove(_elementContextMenu2);
    bindingDescription.element.on.mouseUp.remove(_elementMouseUp2);
    bindingDescription.element.on.mouseDown.remove(_elementMouseDown2);
    bindingDescription.element.on.doubleClick.remove(_elementDoubleClicked2);
    bindingDescription.element.on.click.remove(_elementClicked2);
  }

  void onModelChanged() {
    _clickHandler = modelValue;
  }

  void _elementClicked(MouseEvent event) {
    if (_clickHandler != null) {
      if (bindingDescription.parameters.some((p) => p.key == 'type' && p.value == 'left') || !bindingDescription.parameters.some((p) => p.key == 'type')) {
        _clickHandler(model, event);
        event.preventDefault();
      }
    }
  }

  void _elementDoubleClicked(MouseEvent event) {
    if (_clickHandler != null) {
      if (bindingDescription.parameters.some((p) => p.key == 'type' && p.value == 'double')) {
        _clickHandler(model, event);
        event.preventDefault();
      }
    }
  }

  void _elementMouseDown(MouseEvent event) {
  }

  void _elementMouseUp(MouseEvent event) {
    if (_clickHandler != null) {
      if (bindingDescription.parameters.some((p) => p.key == 'type' && p.value == 'right') && event.button == 2) {
        _clickHandler(model, event);
        event.preventDefault();
      }
    }
  }

  void _elementContextMenu(MouseEvent event) {
    if (_clickHandler != null) {
      if (bindingDescription.parameters.some((p) => p.key == 'type' && p.value == 'contextmenu')) {
        _clickHandler(model, event);
        event.preventDefault();
      }
    }
  }
}