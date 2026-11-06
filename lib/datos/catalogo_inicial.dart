import '../modelos/componente.dart';

// Fichas de demostración incluidas en el código. Los precios y el stock son
// referenciales. La pantalla del catálogo copia esta lista al iniciar.
const catalogoInicial = [
  Componente(
    nombre: 'Tarjeta Madre ASUS B650',
    categoria: Categoria.hardware,
    precioCentimos: 89900,
    descripcion:
        'Placa base con socket AM5, ranuras para memoria DDR5 y '
        'conectores M.2 para unidades de estado sólido.',
  ),
  Componente(
    nombre: 'Procesador Intel Core i7',
    categoria: Categoria.procesadores,
    precioCentimos: 145000,
    descripcion:
        'Procesador de escritorio para tareas de programación, '
        'virtualización y trabajo simultáneo con varias aplicaciones.',
  ),
  Componente(
    nombre: 'Memoria RAM 16 GB DDR4',
    categoria: Categoria.hardware,
    precioCentimos: 17990,
    descripcion:
        'Módulo DIMM de 16 GB para equipos de escritorio con '
        'placa base compatible con DDR4.',
  ),
  Componente(
    nombre: 'Unidad SSD NVMe 1 TB',
    categoria: Categoria.almacenamiento,
    precioCentimos: 32990,
    descripcion:
        'Unidad de estado sólido M.2 de 1 TB con interfaz NVMe '
        'para alojar el sistema operativo y los proyectos del laboratorio.',
  ),
  Componente(
    nombre: 'Monitor Gamer 27 pulgadas',
    categoria: Categoria.perifericos,
    precioCentimos: 89000,
    descripcion:
        'Monitor de 27 pulgadas con panel IPS y conexiones HDMI '
        'y DisplayPort para estaciones de escritorio.',
  ),
  Componente(
    nombre: 'Parlantes Profesionales',
    categoria: Categoria.perifericos,
    precioCentimos: 45000,
    descripcion:
        'Parlantes estéreo con conectividad Bluetooth, entrada '
        'auxiliar de 3.5 mm y control de volumen integrado.',
  ),
];
