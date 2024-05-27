
import 'package:inka_challenge/api/path_key_api.dart';

class TCategoria {
  
  static getCategoriaAlmacen() async {
    // final pb = PocketBase('https://planet-broken.pockethost.io');

    final records = await ar.collection('productos_categoria').getFullList(
    sort: '-created',
    );
    return records;
  }
}