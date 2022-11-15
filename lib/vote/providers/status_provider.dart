import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myecl/auth/providers/openid_provider.dart';
import 'package:myecl/tools/providers/single_notifier.dart';
import 'package:myecl/vote/repositories/status_repository.dart';

class StatusNotifier extends SingleNotifier<bool> {
  final statusRepository = StatusRepository();
  StatusNotifier({required String token}) : super(const AsyncValue.loading()) {
    statusRepository.setToken(token);
  }

  Future<AsyncValue<bool>> loadStatus() async {
    return await load(statusRepository.getStatus);
  }

  Future<bool> updateStatus(bool status) async {
    return await update(statusRepository.updateStatus, status);
  }
}

final statusProvider =
    StateNotifierProvider<StatusNotifier, AsyncValue<bool>>((ref) {
  final token = ref.watch(tokenProvider);
  final statusNotifier =  StatusNotifier(token: token);
  statusNotifier.loadStatus();
  return statusNotifier;
});