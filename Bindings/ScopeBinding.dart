class ScopeBinding extends BindingBase {
  BindingGroup _bg;

  ScopeBinding(ViewModelBinder vmb, BindingGroup bg, BindingDescription desc)
    : super(vmb, bg, desc)
  {
  }

  void onBind() {
    _subBind();
  }

  void onUnbind() {
    _subUnbind();
  }

  void onModelChanged() {
    _subUnbind();
    _subBind();
  }

  void _subBind() {
    var newScope = modelValue;
    if (newScope != null) {
      _bg = viewModelBinder.createGroupOnSubElements(bindingGroup, newScope, element);
      _bg.bind();
    }
  }

  void _subUnbind() {
    if (_bg != null) {
      _bg.unbind();
      _bg = null;
    }
  }
}