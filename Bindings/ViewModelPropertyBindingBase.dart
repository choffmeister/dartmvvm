abstract class ViewModelPropertyBindingBase {
  ViewModelBinder _viewModelBinder;
  ViewModel _viewModel;
  ViewModelBindingDescription _bindingDescription;
  Element _element;

  ViewModelBinder get viewModelBinder() => _viewModelBinder;
  ViewModel get viewModel() => _viewModel;
  ViewModelBindingDescription get bindingDescription() => _bindingDescription;
  Element get element() => _element;

  ViewModelPropertyBindingBase(ViewModelBinder viewModelBinder, ViewModel viewModel, ViewModelBindingDescription bindingDescription, Element element)
    : _viewModelBinder = viewModelBinder, _viewModel = viewModel, _bindingDescription = bindingDescription, _element = element
  {
  }

  abstract void apply();
  abstract void unapply();
}