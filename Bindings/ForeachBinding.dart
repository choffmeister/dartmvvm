class ForeachBinding extends BindingBase {
  Iterable _iterable;
  ObservableList _observableList;
  List<Element> _elementTemplate;
  List<BindingGroup> _itemBindingGroups;

  ForeachBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
      _elementTemplate = new List<Element>();
      bindingDescription.element.elements.forEach((Element e) => _elementTemplate.add(e.clone(true)));
      bindingDescription.element.elements.clear();
     _itemBindingGroups = new List<BindingGroup>();
  }

  void apply() {
    bindingDescription.viewModel.addListener(_viewModelChanged);

    _bindToList();
  }

  void unapply() {
    bindingDescription.viewModel.removeListener(_viewModelChanged);
  }

  void _viewModelChanged(PropertyChangedEvent event) {
    if (event.propertyName == bindingDescription.propertyName) {
      _bindToList();
    }
  }

  void _observableListChanged(ObservableListChangedEvent event) {
    _bindToItems();
  }

  void _bindToList() {
    var current = bindingDescription.viewModel[bindingDescription.propertyName];

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
      var newList = new ObservableList<ViewModel>();
      bindingDescription.viewModel[bindingDescription.propertyName] = newList;
      _observableList = newList;
      _iterable = newList;
    } else {
      throw 'Foreach binds can only be applied to iterables';
    }

    _bindToItems();
  }

  void _bindToItems() {
    _itemBindingGroups.forEach((BindingGroup bg) => bg.unapply());
    _itemBindingGroups.clear();

    List<Element> elements = new List<Element>();

    for (Object item in _iterable) {
      List<Element> newElements = _elementTemplate.map((Element e) => e.clone(true));

      BindingGroup bg = viewModelBinder.createGroupOnMultipleElements(item, newElements);
      bg.apply();
      _itemBindingGroups.add(bg);

      elements.addAll(newElements);
    }

    bindingDescription.element.elements = elements;
  }
}