class RestBinding extends BindingBase {
  RestClient _restClient;

  BindingGroup _bg;
  Future<Object> _requestFuture;


  RestBinding(ViewModelBinder vmb, BindingDescription desc)
    : super(vmb, desc)
  {
    _restClient = ServiceProvider.getService('restClient');
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

  void _subBind() {
    var newUrl = modelValue;
    if (newUrl != null) {
      _requestFuture = _restClient.get(modelValue);

      _requestFuture.then((data) {
        _bg = viewModelBinder.createGroupOnSubElements(ViewModel.dynamicViewModel(data), element);
        _bg.bind();
      });

      _requestFuture.handleException((request) {
        print(request.status);
        return true;
      });
    }
  }

  void _subUnbind() {
    if (_bg != null) {
      _bg.unbind();
      _bg = null;
    }
  }
}