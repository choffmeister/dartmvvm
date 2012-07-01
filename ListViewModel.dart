class ListViewModel<E> extends ViewModelImpl {
  int get length() => this['length'];
  set _length(int value) => this['length'] = value;

  ObservableList<E> get items() => this['items'];
  set items(ObservableList<E> value) {
    if (this['items'] != null) {
      this['items'].removeHandler(_listChanged);
    }
    value.addHandler(_listChanged);
    this['items'] = value;
  }

  ListViewModel() {
    items = new ObservableList<E>();
  }

  ListViewModel.from(List<E> list) {
    items = new ObservableList<E>.from(list);
  }

  void _listChanged(ObservableListChangedEvent event) {
    _length = items.length;
  }
}