import 'package:myecl/tools/repository/repository.dart';
import 'package:myecl/vote/class/result.dart';

class ResultRepository extends Repository {
  @override
  // ignore: overridden_fields
  final ext = 'campaign/results';

  Future<List<Result>> getResult() async {
    return List<Result>.from((await getList()).map((e) => Result.fromJson(e)));
  }
}
