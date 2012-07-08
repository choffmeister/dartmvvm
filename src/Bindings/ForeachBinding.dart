class ForeachBinding extends BindingBase {
  Iterable _iterable;
  ObservableList _observableList;
  List<Element> _elementTemplate;
  List<BindingGroup> _itemBindingGroups;
  // due to a bug (see http://code.google.com/p/dart/issues/detail?id=144)
  Function _observableListChanged2;

  ForeachBinding(ViewModelBinder vmb, BindingGroup bg, BindingDescription desc)
    : super(vmb, bg, desc)
  {
     _itemBindingGroups = new List<BindingGroup>();
     _observableListChanged2 = _observableListChanged;
  }

  void onBind() {
    _elementTemplate = new List<Element>();
    element.elements.forEach((Element e) => _elementTemplate.add(e.clone(true)));
    element.elements.clear();
    _subBind();
  }

  void onUnbind() {
    _subUnbind();
    element.elements = _elementTemplate;
  }

  void onModelChanged() {
    _subUnbind();
    _subBind();
  }

  void _observableListChanged(ObservableListChangedEvent event) {
    _subUnbindItems();
    _subBindItems();
  }

  void _subBind() {
    var newList = modelValue;

    if (newList is ListViewModel) {
      _observableList = newList.items;
      _iterable = newList.items;
      _observableList.addHandler(_observableListChanged2);
    } else if (newList is ObservableList) {
      _observableList = newList;
      _iterable = newList;
      _observableList.addHandler(_observableListChanged2);
    } else if (newList is Iterable) {
      _iterable = newList;
    } else if (newList == null) {
      // do nothing
    } else {
      throw new BindingException('Foreach binds can only be applied to iterables', _bindingDescription);
    }

    _subBindItems();
  }

  void _subUnbind() {
    if (_observableList != null) {
      _observableList.removeHandler(_observableListChanged2);
      _observableList = null;
    }
    _iterable = null;

    _subUnbindItems();
  }

  void _subBindItems() {
    if (_iterable != null) {
      List<Element> elements = new List<Element>();

      for (Object item in _iterable) {
        List<Element> newElements = _elementTemplate.map((Element e) => e.clone(true));

        BindingGroup bg = viewModelBinder.createGroupOnMultipleElements(bindingGroup, item, newElements);
        bg.bind();
        _itemBindingGroups.add(bg);

        elements.addAll(newElements);
      }

      element.elements = elements;
    }
  }

  void _subUnbindItems() {
    while (_itemBindingGroups.length > 0) {
      _itemBindingGroups.removeLast().unbind();
    }
  }
}