import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myecl/auth/providers/openid_provider.dart';
import 'package:myecl/booking/class/booking.dart';
import 'package:myecl/booking/repositories/booking_repository.dart';
import 'package:myecl/tools/providers/list_notifier.dart';
import 'package:myecl/tools/token_expire_wrapper.dart';

class ConfirmedBookingListProvider extends ListNotifier<Booking> {
  final BookingRepository _bookingRepository = BookingRepository();
  ConfirmedBookingListProvider({required String token})
      : super(const AsyncValue.loading()) {
    _bookingRepository.setToken(token);
  }

  Future<AsyncValue<List<Booking>>> loadConfirmedBooking() async {
    return await loadList(
        () async => _bookingRepository.getConfirmedBookingList());
  }
}

final confirmedBookingListProvider = StateNotifierProvider<
    ConfirmedBookingListProvider, AsyncValue<List<Booking>>>((ref) {
  final token = ref.watch(tokenProvider);
  final provider = ConfirmedBookingListProvider(token: token);
  tokenExpireWrapperAuth(ref, () async {
    await provider.loadConfirmedBooking();
  });
  return provider;
});