import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myecl/amap/middlewares/amap_middleware.dart';
import 'package:myecl/amap/ui/pages/admin_page/admin_page.dart';
import 'package:myecl/amap/ui/pages/delivery_pages/add_edit_delivery_cmd_page.dart';
import 'package:myecl/amap/ui/pages/detail_delivery_page/detail_page.dart';
import 'package:myecl/amap/ui/pages/detail_page/detail_page.dart';
import 'package:myecl/amap/ui/pages/list_products_page/list_products_page.dart';
import 'package:myecl/amap/ui/pages/presentation_page/text.dart';
import 'package:myecl/amap/ui/pages/product_pages/add_edit_product.dart';
import 'package:qlevar_router/qlevar_router.dart';

class AmapRouter {
  final ProviderRef ref;
  static const String root = '/amap';
  static const String admin = '/admin';
  static const String addEditDelivery = '/add_edit_delivery';
  static const String detailDelivery = '/detail_delivery';
  static const String detailOrder = '/detail_order';
  static const String listProduct = '/list_product';
  static const String presentation = '/presentation';
  static const String addEditProduct = '/add_edit_product';
  late List<QRoute> routes = [];
  AmapRouter(this.ref) {
    routes = [
      QRoute(path: admin, builder: () => const AdminPage(), middleware: [
        AmapAdminMiddleware(ref),
      ], children: [
        QRoute(
            path: addEditDelivery, builder: () => const AddEditDeliveryPage()),
        QRoute(path: addEditProduct, builder: () => const AddEditProduct()),
        QRoute(path: detailDelivery, builder: () => const DetailDeliveryPage()),
      ]),
      QRoute(path: listProduct, builder: () => const ListProductPage()),
      QRoute(path: detailOrder, builder: () => const DetailPage()),
      QRoute(path: presentation, builder: () => const PresentationPage()),
    ];
  }
}
