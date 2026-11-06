import 'package:catalogo_senati/main.dart';
import 'package:catalogo_senati/modelos/componente.dart';
import 'package:catalogo_senati/pantallas/catalogo_page.dart';
import 'package:catalogo_senati/pantallas/detalle_page.dart';
import 'package:catalogo_senati/pantallas/login_page.dart';
import 'package:catalogo_senati/rutas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('protege las rutas y permite el acceso con la clave correcta', (
    tester,
  ) async {
    final plataforma = tester.binding.platformDispatcher;
    plataforma.defaultRouteNameTestValue = rutaDetalle;
    addTearDown(plataforma.clearDefaultRouteNameTestValue);
    await tester.pumpWidget(const CatalogoApp());
    await tester.pumpAndSettle();

    final login = tester.element(find.byType(LoginPage));
    expect(ModalRoute.of(login)?.settings.name, rutaLogin);
    Navigator.of(login).pushNamed<void>(rutaCatalogo);
    await tester.pumpAndSettle();
    expect(find.byType(CatalogoPage), findsNothing);

    await _ingresar(tester, clave: 'incorrecta');
    expect(find.text('Usuario o contraseña incorrectos.'), findsOneWidget);
    expect(find.byType(CatalogoPage), findsNothing);

    await _ingresar(tester);
    final catalogo = tester.element(find.byType(CatalogoPage));
    expect(ModalRoute.of(catalogo)?.settings.name, rutaCatalogo);
    expect(Navigator.of(catalogo).canPop(), isFalse);
  });

  testWidgets('combina búsqueda y categoría y las conserva al volver', (
    tester,
  ) async {
    await tester.pumpWidget(const CatalogoApp());
    await tester.pumpAndSettle();
    await _ingresar(tester);

    final perifericos = find.widgetWithText(FilterChip, 'Periféricos');
    await tester.ensureVisible(perifericos);
    await tester.pumpAndSettle();
    await tester.tap(perifericos);
    await tester.tap(find.byTooltip('Buscar'));
    await tester.pumpAndSettle();
    final buscador = find.byType(TextField);
    await tester.enterText(buscador, 'SSD');
    await tester.pumpAndSettle();
    expect(
      find.textContaining('No se encontraron componentes'),
      findsOneWidget,
    );

    await tester.enterText(buscador, 'PARLANTES');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Parlantes Profesionales'));
    await tester.pumpAndSettle();

    final detalle = tester.element(find.byType(DetallePage));
    expect(ModalRoute.of(detalle)?.settings.name, '/details');
    expect(find.textContaining('Bluetooth'), findsOneWidget);
    expect(find.text('Stock disponible en almacén'), findsOneWidget);
    expect(find.text('S/. 450.00'), findsOneWidget);

    await tester.tap(find.text('Volver al Catálogo'));
    await tester.pumpAndSettle();
    expect(find.text('PARLANTES'), findsOneWidget);
    expect(tester.widget<FilterChip>(perifericos).selected, isTrue);
    expect(find.text('1 componente'), findsOneWidget);
  });

  testWidgets('valida el registro y muestra la ficha guardada en móvil', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CatalogoApp());
    await tester.pumpAndSettle();
    await _ingresar(tester);
    await tester.tap(find.text('Nuevo Componente'));
    await tester.pumpAndSettle();
    final guardar = find.text('Guardar Componente');
    await tester.tap(guardar);
    await tester.pumpAndSettle();
    expect(find.text('Escribe el nombre del componente.'), findsOneWidget);
    expect(find.text('Selecciona una categoría.'), findsOneWidget);
    expect(find.text('Escribe el precio.'), findsOneWidget);
    expect(find.text('Escribe la descripción técnica.'), findsOneWidget);

    final campos = find.byType(TextFormField);
    await tester.enterText(campos.at(0), 'Disco de laboratorio');
    await tester.enterText(campos.at(1), '12.999');
    await tester.enterText(campos.at(2), 'Unidad SSD para pruebas.');
    await tester.tap(find.byType(DropdownButtonFormField<Categoria>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Almacenamiento').last);
    await tester.pumpAndSettle();
    await tester.tap(guardar);
    await tester.pumpAndSettle();
    expect(find.textContaining('Ingresa un precio positivo'), findsOneWidget);

    await tester.enterText(campos.at(1), '450,50');
    await tester.tap(guardar);
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    await tester.tap(find.text('Disco de laboratorio'));
    await tester.pumpAndSettle();
    expect(find.text('Unidad SSD para pruebas.'), findsOneWidget);
    expect(find.text('S/. 450.50'), findsOneWidget);
    await tester.tap(find.text('Volver al Catálogo'));
    await tester.pumpAndSettle();
    expect(find.text('Disco de laboratorio'), findsOneWidget);
  });
}

Future<void> _ingresar(WidgetTester tester, {String clave = 'guapo'}) async {
  final campos = find.byType(TextFormField);
  await tester.enterText(campos.at(0), 'senatino');
  await tester.enterText(campos.at(1), clave);
  await tester.tap(find.text('Ingresar'));
  await tester.pumpAndSettle();
}
