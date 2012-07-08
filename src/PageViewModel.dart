class PageViewModel extends ViewModel {
  PageViewModel();

  Future<PageViewModel> load() {
    return new Future<PageViewModel>.immediate(this);
  }
}