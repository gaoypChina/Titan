import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:myecl/amap/tools/constants.dart';
import 'package:myecl/amap/ui/pages/list_produits_page/boutons_choix_produits.dart';
import 'package:myecl/amap/ui/pages/list_produits_page/list_produits.dart';
import 'package:myecl/amap/ui/pages/list_produits_page/point_affichage.dart';

/// La page affichant la liste des produits
class ListProduitPage extends HookConsumerWidget {
  const ListProduitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
        child: Column(
          children: [
            const SizedBox(
              height: 35,
            ),
            Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorConstants.background2.withOpacity(0.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [ListProduits(), Dots(), Boutons()],
                  ))),
          ],
        ));
  }
}
