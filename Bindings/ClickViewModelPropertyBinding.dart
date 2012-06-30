typedef void ClickHandler();

class ClickViewModelPropertyBinding extends ViewModelPropertyBindingBase {
  ClickHandler _clickHandler;

  ClickViewModelPropertyBinding(ViewModelBinder viewModelBinder, ViewModel viewModel, ViewModelBindingDescription bindingDescription, Element element)
    : super(viewModelBinder, viewModel, bindingDescription, element)
  {
      _bindElementClickHandler();
  }

  void apply() {
    viewModel.addListener(_viewModelChanged);
    element.on.click.add(_elementClicked);
  }

  void unapply() {
    viewModel.removeListener(_viewModelChanged);
    element.on.click.remove(_elementClicked);
  }

  void _viewModelChanged(PropertyChangedEvent event) {
    if (event.propertyName == bindingDescription.propertyName) {
      _bindElementClickHandler();
    }
  }

  void _elementClicked(Event event) {
    if (_clickHandler != null) {
      _clickHandler();
      event.preventDefault();
    }
  }

  void _bindElementClickHandler() {
    //TODO: reactivate when visitIs is implemented in dart2js
    //if (viewModel[bindingDescription.propertyName] == null) {
    //  _clickHandler = null;
    //} else if (viewModel[bindingDescription.propertyName] is ClickHandler) {
    //  _clickHandler = viewModel[bindingDescription.propertyName];
    //} else {
    //  throw 'Click bindings can only be applied to functions of type void ()';
    //}

    if (viewModel[bindingDescription.propertyName] == null) {
      _clickHandler = null;
    } else  {
      _clickHandler = viewModel[bindingDescription.propertyName];
    }
  }
}