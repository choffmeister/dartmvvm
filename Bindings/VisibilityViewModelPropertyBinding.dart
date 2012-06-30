class VisibilityViewModelPropertyBinding extends ViewModelPropertyBindingBase {
  VisibilityViewModelPropertyBinding(ViewModelBinder viewModelBinder, ViewModel viewModel, ViewModelBindingDescription bindingDescription, Element element)
    : super(viewModelBinder, viewModel, bindingDescription, element)
  {
      if (viewModel[bindingDescription.propertyName] == true) {
        element.style.removeProperty('display');
      } else {
        element.style.display = 'none';
      }
  }

  void apply() {
    viewModel.addListener(_viewModelChanged);
  }

  void unapply() {
    viewModel.removeListener(_viewModelChanged);
  }

  void _viewModelChanged(PropertyChangedEvent event) {
    if (event.propertyName == bindingDescription.propertyName) {
      if (event.newValue == true) {
        element.style.removeProperty('display');
      } else {
        element.style.display = 'none';
      }
    }
  }
}