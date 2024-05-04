import 'package:flutter/material.dart';
import 'package:inka_challenge/page/page_table_dashoard.dart';
import 'package:inka_challenge/page/page_table_runners.dart';
import 'package:inka_challenge/pages/productos_pages.dart';
import 'package:inka_challenge/pages/t_asistencia_page.dart';
import 'package:inka_challenge/pages2/t_empleado_admin_page.dart';
import 'package:inka_challenge/pages2/t_productos_page.dart';
import 'package:inka_challenge/prueba_files/page_carga_imagenes.dart';

class PageRoutes {
  Widget icon;
  String title;
  Widget path;
  PageRoutes({required this.icon, required this.title, required this.path});
}

List<PageRoutes> routes = [
  //Carrrera
  PageRoutes( icon: _buildIcon(Icons.miscellaneous_services_sharp),title: "Distancias",   path: const PageTablaRunners(),),
  PageRoutes( icon: _buildIcon(Icons.checklist),                   title: "Check List",   path: Container(),),
  PageRoutes( icon: _buildIcon(Icons.checklist_rtl_sharp),         title: "Check Points", path: Container(),),
  PageRoutes( icon: _buildIcon(Icons.people),                      title: "Runners",      path: const ProductosPage(),),
  PageRoutes( icon: _buildIcon(Icons.playlist_add_check),          title: "Participantes",path: const TablaParticipacion(),),
  //Logistica
  PageRoutes(icon: _buildIcon(Icons.store),         title: "Equipo",      path: const CatalogoProductos(),),
  PageRoutes( icon: _buildIcon(Icons.storefront),   title: "Hidratación", path: const ProductosPage(),),
  PageRoutes( icon: _buildIcon(Icons.storefront),   title: "Prendas",     path: const ProductosPage(),),
  PageRoutes(icon: _buildIcon(Icons.category),      title: "Categoria",   path: Container(), ),
  PageRoutes(icon: _buildIcon(Icons.location_on),   title: "Ubicación",   path: Container(), ),
  PageRoutes(icon: _buildIcon(Icons.shopping_cart), title: "Compras",     path: Container(),),
  PageRoutes(icon: _buildIcon(Icons.article),       title: "Articulos",   path: Container(),),
  PageRoutes(icon: _buildIcon(Icons.attach_money),  title: "Stock/Precios",path: Container(), ),
  PageRoutes(icon: _buildIcon(Icons.assignment),    title: "Inventario",   path: Container(),),
  //CONTABILIDAD
  PageRoutes(icon: _buildIcon(Icons.account_balance_wallet), title: "Caja",     path: Container(),),
  PageRoutes(icon: _buildIcon(Icons.payment),                title: "Pagos",    path: Container(),),
  //RRHH
  PageRoutes(icon: _buildIcon(Icons.analytics),              title: "Reportes", path: Container(),),
  PageRoutes( icon: _buildIcon(Icons.admin_panel_settings),  title: "Administración", path: Container(),),
  PageRoutes( icon: _buildIcon(Icons.group),                 title: "Personal", path: Container(),),
    PageRoutes( icon: _buildIcon(Icons.car_repair_rounded),                 title: "Transportes", path: Container(),),
  PageRoutes( icon: _buildIcon(Icons.image),                 title: "Image",    path: const ImageUploadPage(),),
  PageRoutes( icon: _buildIcon(Icons.edit),                  title: "Asistencia",path: const FormularioAsistenciapage(),),
  PageRoutes( icon: _buildIcon(Icons.admin_panel_settings),  title: "Administración", path: const AdministracionPage(),),
];


Widget _buildIcon(IconData iconData) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.5), // Transparente al 50%
      shape: BoxShape.circle,
    ),
    child: Icon(
      iconData,
      color: Colors.white, // Color del icono
    ),
  );
}
