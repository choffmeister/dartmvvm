class ListViewModel<E> extends ViewModel {
  // due to a bug (see http://code.google.com/p/dart/issues/detail?id=144)
  Function _listChanged2;

  int get length() => this['length'];
  bool get empty() => this['empty'];
  ObservableList<E> get items() => this['items'];

  set items(ObservableList<E> value) {
    if (items != null) {
      items.removeHandler(_listChanged2);
    }
    value.addHandler(_listChanged2);
    this['items'] = value;
    this['length'] = value.length;
    this['empty'] = value.length == 0;
  }

  ListViewModel() {
    _listChanged2 = _listChanged;
    this['items'] = new ObservableList<E>();
    this['length'] = 0;
    this['empty'] = true;
  }

  void _listChanged(ObservableListChangedEvent event) {
    this['length'] = items.length;
    this['empty'] = items.length == 0;
  }
}