class ListViewModel<E> extends ViewModel {
  // due to a bug (see http://code.google.com/p/dart/issues/detail?id=144)
  var _listChanged2;

  int get length() => this['length'];
  bool get empty() => this['empty'];
  ObservableList<E> get items() => this['items'];

  set items(ObservableList<E> value) {
    if (this['items'] != null) {
      this['items'].removeHandler(_listChanged2);
    }
    value.addHandler(_listChanged2);
    this['items'] = value;
    this['length'] = value.length;
    this['empty'] = value.length == 0;
  }

  ListViewModel() {
    _listChanged2 = _listChanged;
    items = new ObservableList<E>();
  }

  void _listChanged(ObservableListChangedEvent event) {
    this['length'] = items.length;
    this['empty'] = items.length == 0;
  }
}