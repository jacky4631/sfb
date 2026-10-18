import 'package:flutter_test/flutter_test.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:sufenbao/service.dart';

void main() {
  test('JD search follows a nonconsecutive provider cursor', () {
    final model = DataModel();
    BService.addJdList(model, {'list': [{'goodsId': 'a'}], 'minId': '17'}, 1, true);
    expect(model.page, 17);
    expect(model.hasNext, isTrue);
    BService.addJdList(model, {'list': [{'goodsId': 'b'}], 'minId': '29'}, 17, false);
    expect(model.page, 29);
    expect(model.list.length, 2);
  });

  test('JD search stops on an empty list or repeated cursor', () {
    final model = DataModel();
    BService.addJdList(model, {'list': [1], 'minId': '1'}, 1, true);
    expect(model.hasNext, isFalse);
    BService.addJdList(model, {'list': [], 'minId': '30'}, 17, false);
    expect(model.hasNext, isFalse);
  });

  test('JD rank and brand lists retain total based pagination', () {
    final model = DataModel();
    BService.addJdList(model, {'list': List.filled(10, 1), 'total': 11}, 1, true);
    expect(model.hasNext, isTrue);
    expect(model.page, 2);
    BService.addJdList(model, {'list': [2], 'total': 11}, 2, false);
    expect(model.hasNext, isFalse);
  });
}
