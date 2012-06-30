interface ViewModelBinder default ViewModelBinderImpl {
  ViewModelBinder();

  ViewModelBindingGroup createGroup(ViewModel viewModel, Element baseElement);

  ViewModelBindingGroup createGroupOnMultipleElements(ViewModel viewModel, Iterable<Element> baseElements);

  ViewModelPropertyBindingBase createBinding(ViewModel viewModel, ViewModelBindingDescription bindingDescription, Element element);
}

class ViewModelBinderImpl implements ViewModelBinder {
  ViewModel _viewModel;
  Element _element;

  ViewModelBindingGroup createGroup(ViewModel viewModel, Element baseElement) {
    List<Element> baseElements = new List<Element>();
    baseElements.add(baseElement);

    return new ViewModelBindingGroup(this, viewModel, baseElements);
  }

  ViewModelBindingGroup createGroupOnMultipleElements(ViewModel viewModel, Iterable<Element> baseElements) {
    return new ViewModelBindingGroup(this, viewModel, baseElements);
  }

  ViewModelPropertyBindingBase createBinding(ViewModel viewModel, ViewModelBindingDescription bindingDescription, Element element) {
    ViewModelPropertyBindingBase binding = null;

    if (bindingDescription.type != null) {
      switch (bindingDescription.type) {
        case 'value': binding = new ValueViewModelPropertyBinding(this, viewModel, bindingDescription, element); break;
        case 'click': binding = new ClickViewModelPropertyBinding(this, viewModel, bindingDescription, element); break;
        case 'text': binding = new TextViewModelPropertyBinding(this, viewModel, bindingDescription, element); break;
        case 'tristate': binding = new TriStateViewModelPropertyBinding(this, viewModel, bindingDescription, element); break;
        case 'visibility': binding = new VisibilityViewModelPropertyBinding(this, viewModel, bindingDescription, element); break;
        case 'foreach': binding = new ForeachViewModelPropertyBinding(this, viewModel, bindingDescription, element); break;
      }
    } else {
      binding = _guessBindingType(viewModel, bindingDescription, element);
    }

    if (binding == null) {
      //TODO: make it configurable, if an exception should be thrown
      //throw 'Could not guess binding type, so please specify explicitly';
    }

    return binding;
  }

  ViewModelPropertyBindingBase _guessBindingType(ViewModel viewModel, ViewModelBindingDescription bindingDescription, Element element) {
    if (element is InputElement) {
      return new ValueViewModelPropertyBinding(this, viewModel, bindingDescription, element);
    } else if (element is ButtonElement) {
      return new ClickViewModelPropertyBinding(this, viewModel, bindingDescription, element);
    } else {
      return null;
    }
  }
}