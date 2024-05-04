import 'dart:math';
import 'dart:ui';

Color getRandomColor() {
  final Random random = Random();

  // Generar valores aleatorios para los componentes RGB
  final int red = random.nextInt(256); // Rojo en el rango 0-255
  final int green = random.nextInt(256); // Verde en el rango 0-255
  final int blue = random.nextInt(256); // Azul en el rango 0-255

  // Crear un color con los valores aleatorios generados
  return Color.fromARGB(255, red, green, blue);
}
