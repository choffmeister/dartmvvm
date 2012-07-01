class ScopeBinding extends BindingBase {
  BindingGroup _bg;

  ScopeBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
  }

  void onApply() {
    _refreshBinding();
  }

  void onUnapply() {
  }

  void onModelChanged() {
    _refreshBinding();
  }

  void _refreshBinding() {
    if (_bg != null) {
      _bg.unapply();
      _bg = null;
    }

    var newScope = modelValue;
    if (newScope != null) {
      _bg = viewModelBinder.createGroupOnSubElements(newScope, element);
      _bg.apply();
    }
  }
}