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

  void onBind() {
    _subBind();
  }

  void onUnbind() {
    _subUnbind();
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
      _observableList.addHandler(_observableListChanged);
    } else if (newList is ObservableList) {
      _observableList = newList;
      _iterable = newList;
      _observableList.addHandler(_observableListChanged);
    } else if (newList is Iterable) {
      _iterable = newList;

    } else if (newList == null) {
      // do nothing
    } else {
      throw 'Foreach binds can only be applied to iterables';
    }

    _subBindItems();
  }

  void _subUnbind() {
    if (_observableList != null) {
      _observableList.removeHandler(_observableListChanged);
      _observableList = null;
    }

    _subUnbindItems();
  }

  void _subBindItems() {
    if (_iterable != null) {
      List<Element> elements = new List<Element>();

      for (Object item in _iterable) {
        List<Element> newElements = _elementTemplate.map((Element e) => e.clone(true));

        BindingGroup bg = viewModelBinder.createGroupOnMultipleElements(item, newElements);
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