class ScopeBinding extends BindingBase {
  BindingGroup _bg;

  ScopeBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
  }

  void apply() {
    viewModel.addListener(_viewModelChanged);
    _refreshBinding();
  }

  void unapply() {
    viewModel.removeListener(_viewModelChanged);
  }

  void _viewModelChanged(PropertyChangedEvent event) {
    if (event.propertyName == propertyName) {
      _refreshBinding();
    }
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