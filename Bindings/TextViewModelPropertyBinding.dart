class TextViewModelPropertyBinding extends ViewModelPropertyBindingBase {
  TextViewModelPropertyBinding(ViewModelBinder viewModelBinder, ViewModel viewModel, ViewModelBindingDescription bindingDescription, Element element)
    : super(viewModelBinder, viewModel, bindingDescription, element)
  {
      element.text = viewModel[bindingDescription.propertyName].toString();
  }

  void apply() {
    viewModel.addListener(_viewModelChanged);
  }

  void unapply() {
    viewModel.removeListener(_viewModelChanged);
  }

  void _viewModelChanged(PropertyChangedEvent event) {
    if (event.propertyName == bindingDescription.propertyName) {
      element.text = event.newValue;
    }
  }
}