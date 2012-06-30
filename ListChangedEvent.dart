typedef void ListChangedListener<T>(ListChangedEvent<T> event);

class ListChangedEvent<T> {
   ListViewModel<T> _list;

   ListViewModel<T> get list() => _list;

   ListChangedEvent(ListViewModel<T> list) : _list = list {

   }
}