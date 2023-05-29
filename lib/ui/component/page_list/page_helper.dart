///根据页码分页
typedef PageNumberFutureBuilder<T> = Future<List<T>> Function(int pageNo, int pageSize);

///根据上一个页面的最后一条数据分页
typedef PageTailFutureBuilder<T> = Future<List<T?>> Function(int pageNo, int pageSize, T? tail);

enum PageResult {
  ///刷新成功
  R_SUCCESS,

  ///加载成功
  SUCCESS,

  ///没有数据
  EMPTY,

  ///第一页数据为空
  R_COMPLETED,

  ///没有更多数据了
  COMPLETED,
}

abstract class PageHelper<T> {
  int _pageNo;
  int _pageSize;
  int _initialPageNo;

  List<T?>? _data = [];

  PageHelper({int pageNo = 1, int pageSize = 20, int initialPageNo = 1})
      : _pageNo = pageNo,
        _pageSize = pageSize,
        _initialPageNo = initialPageNo;

  Future<PageResult> load(bool isRefresh) async {
    if (isRefresh) {
      _pageNo = _initialPageNo;
    }

    ///1、接口请求
    final data = await buildFuture();

    ///2、数据分析
    final result = _analysePageResult(data);

    ///3、刷新的时候需要清空集合
    if (isRefresh) {
      _data?.clear();
    }

    ///4、页码处理，数据处理
    _data?.addAll(data);

    if (result == PageResult.SUCCESS || result == PageResult.R_SUCCESS) {
      _pageNo++;
    }

    return result;
  }

  Future<List<T?>> buildFuture();

  PageResult _analysePageResult(List<T?> data) {
    return _pageNo == _initialPageNo ? _onRefresh(data) : _onLoad(data);
  }

  PageResult _onRefresh(List<T?>? result) {
    if (result == null || result.isEmpty) {
      return PageResult.EMPTY;
    } else if (result.length < _pageSize) {
      return PageResult.R_COMPLETED;
    } else {
      return PageResult.R_SUCCESS;
    }
  }

  _onLoad(List<T?>? result) {
    if (result == null || result.length < _pageSize) {
      return PageResult.COMPLETED;
    } else {
      return PageResult.SUCCESS;
    }
  }

  List<T?>? get data => _data;

  factory PageHelper.num(PageNumberFutureBuilder<T> builder, {int pageNo = 1, int pageSize = 20, int initialPageNo = 1}) =>
      _PageNumberHelper<T>(builder, pageNo: pageNo, pageSize: pageSize, initialPageNo: initialPageNo);

  factory PageHelper.tail(PageTailFutureBuilder<T> builder, {int pageNo = 1, int pageSize = 20, int initialPageNo = 1}) =>
      _PageTailHelper<T>(builder, pageNo: pageNo, pageSize: pageSize, initialPageNo: initialPageNo);
}

class _PageNumberHelper<T> extends PageHelper<T> {
  final PageNumberFutureBuilder<T> builder;

  _PageNumberHelper(this.builder, {int pageNo = 1, int pageSize = 20, int initialPageNo = 1})
      : super(pageNo: pageNo, pageSize: pageSize, initialPageNo: initialPageNo);

  @override
  Future<List<T?>> buildFuture() => builder(_pageNo, _pageSize);
}

class _PageTailHelper<T> extends PageHelper<T> {
  final PageTailFutureBuilder<T> builder;

  _PageTailHelper(this.builder, {int pageNo = 1, int pageSize = 20, int initialPageNo = 1})
      : super(pageNo: pageNo, pageSize: pageSize, initialPageNo: initialPageNo);

  @override
  Future<List<T?>> buildFuture() => builder(_pageNo, _pageSize, _data == null || _data!.isEmpty ? null : _data?.last);
}
