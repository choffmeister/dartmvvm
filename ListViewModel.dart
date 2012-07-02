class ListViewModel<E> extends ViewModel {
  int get length() => this['length'];
  set _length(int value) => this['length'] = value;

  // due to a bug (see http://code.google.com/p/dart/issues/detail?id=144)
  var _listChanged2;

  ObservableList<E> get items() => this['items'];
  set items(ObservableList<E> value) {
    if (this['items'] != null) {
      this['items'].removeHandler(_listChanged2);
    }
    value.addHandler(_listChanged2);
    this['items'] = value;
  }

  ListViewModel() {
    _listChanged2 = _listChanged;
    items = new ObservableList<E>();
  }

  ListViewModel.from(List<E> list) {
    _listChanged2 = _listChanged;
    items = new ObservableList<E>.from(list);
  }

  void _listChanged(ObservableListChangedEvent event) {
    _length = items.length;
  }
}