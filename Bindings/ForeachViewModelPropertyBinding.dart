class ForeachViewModelPropertyBinding extends ViewModelPropertyBindingBase {
  Iterable _iterable;
  ObservableList _observableList;
  List<Element> _elementTemplate;
  List<ViewModelBindingGroup> _itemViewModelBindingGroups;

  ForeachViewModelPropertyBinding(ViewModelBinder viewModelBinder, ViewModel viewModel, ViewModelBindingDescription bindingDescription, Element element)
    : super(viewModelBinder, viewModel, bindingDescription, element), _itemViewModelBindingGroups = new List<ViewModelBindingGroup>()
  {
      _extractTemplate();
      _bindToList();
  }

  void apply() {
    viewModel.addListener(_viewModelChanged);
  }

  void unapply() {
    viewModel.removeListener(_viewModelChanged);
  }

  void _viewModelChanged(PropertyChangedEvent event) {
    if (event.propertyName == bindingDescription.propertyName) {
      _bindToList();
    }
  }

  void _observableListChanged(ObservableListChangedEvent event) {
    _bindToItems();
  }

  void _extractTemplate() {
    _elementTemplate = new List<Element>();
    element.elements.forEach((Element e) => _elementTemplate.add(e.clone(true)));
    element.elements.clear();
  }

  void _bindToList() {
    var current = viewModel[bindingDescription.propertyName];

    if (_observableList != null) {
      _observableList.removeHandler(_observableListChanged);
      _observableList = null;
    }

    if (current is ObservableList) {
      _observableList = current;
      _observableList.addHandler(_observableListChanged);
      _iterable = current;
    } else if (current is Iterable) {
      _iterable = current;
    } else if (current == null) {
      _iterable = null;
    } else {
      throw 'Foreach binds can only be applied to iterables';
    }

    _bindToItems();
  }

  void _bindToItems() {
    _itemViewModelBindingGroups.forEach((ViewModelBindingGroup vmbg) => vmbg.unapply());
    _itemViewModelBindingGroups.clear();

    List<Element> elements = new List<Element>();

    for (Object item in _iterable) {
      List<Element> newElements = _elementTemplate.map((Element e) => e.clone(true));

      ViewModelBindingGroup vmbg = viewModelBinder.createGroupOnMultipleElements(item, newElements);
      vmbg.apply();
      _itemViewModelBindingGroups.add(vmbg);

      elements.addAll(newElements);
    }

    element.elements = elements;
  }
}