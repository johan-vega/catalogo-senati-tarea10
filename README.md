# Catálogo SENATI

Aplicación web en Flutter para consultar y registrar componentes de laboratorio. La interfaz usa Material Design 3 y se adapta al ancho del navegador.

## Ejecutar el proyecto

Abre una terminal nueva de PowerShell y ejecuta estos comandos. El proyecto requiere Flutter 3.47 o superior. [Guía oficial de instalación](https://docs.flutter.dev/install)

```powershell
cd C:\idaw4\Flutter\tarea12
flutter pub get
flutter run -d web-server --release --no-web-resources-cdn --web-hostname 127.0.0.1 --web-port 8080
```

Cuando Flutter termine de iniciar, abre [Catálogo SENATI en localhost](http://localhost:8080/#/login) en Chrome o Edge. Ingresa con el usuario `senatino` y la contraseña `guapo`. Flutter sirve la aplicación desde tu PC. Si ejecutaste el servidor en la terminal, pulsa `Ctrl+C` allí para detenerlo.

## Cómo se relacionan los módulos

| Archivo o carpeta | Función |
| --- | --- |
| [`lib/main.dart`](lib/main.dart) | Inicia la app y habilita las rutas `/#/home` y `/#/details` después de iniciar sesión. |
| [`lib/pantallas/login_page.dart`](lib/pantallas/login_page.dart) | Comprueba las credenciales de demostración en el navegador. |
| [`lib/datos/catalogo_inicial.dart`](lib/datos/catalogo_inicial.dart) | Define las seis fichas de ejemplo que se cargan al abrir el catálogo. Sus precios y stock son referenciales. |
| [`lib/datos/filtrar_catalogo.dart`](lib/datos/filtrar_catalogo.dart) | Combina el chip y el buscador con `List.where()`. La búsqueda ignora mayúsculas y tildes. |
| [`lib/modelos/componente.dart`](lib/modelos/componente.dart) | Define los datos de cada ficha y convierte precios a céntimos para mostrarlos como `S/. 450.00`. |
| [`lib/pantallas/catalogo_page.dart`](lib/pantallas/catalogo_page.dart) | Mantiene la lista en memoria y actualiza la vista con `setState()`. Al guardar, vuelve a Todos, limpia el buscador y muestra el nuevo registro al inicio. |
| [`lib/widgets/formulario_componente.dart`](lib/widgets/formulario_componente.dart) | Valida nombre, categoría, precio y descripción. Admite punto o coma decimal y devuelve el componente al catálogo cuando se pulsa Guardar. |
| [`lib/pantallas/detalle_page.dart`](lib/pantallas/detalle_page.dart) | Muestra el componente recibido por `Navigator.pushNamed()` y vuelve al catálogo con `Navigator.pop()`. |
| [`web/index.html`](web/index.html) | Es la página de entrada del navegador. Carga `flutter_bootstrap.js`, que Flutter genera para iniciar el código Dart compilado. |

Las credenciales están en el código compilado para esta demostración local. El acceso y las altas se guardan en memoria. Si recargas la página o abres directamente una ruta del catálogo, la aplicación vuelve a pedir el acceso y luego muestra las fichas de ejemplo. Los íconos Material se empaquetan con Flutter mediante `pubspec.yaml` y los registros nuevos muestran stock disponible por defecto.

## Verificación

```powershell
flutter analyze
flutter test
flutter build web --no-web-resources-cdn
```

Las pruebas cubren el inicio de sesión, el bloqueo de rutas, la búsqueda combinada con los filtros, la navegación de ida y vuelta y el registro con un precio decimal. La compilación web deja el resultado en `build/web/` e incluye los recursos del motor para servirlos desde el mismo sitio.
