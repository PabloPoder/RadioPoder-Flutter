import 'package:flutter/material.dart';

import '../models/noticia.dart';

class Noticias with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Noticia> _items = [
    Noticia(
      id: 1,
      titulo: "La administracion publica cobrara este viernes 29 de abril",
      texto:
          "El día viernes 29 se hará efectivo el pago de haberes a todos los empleados públicos del Gobierno provincial, es decir personal docente, profesionales y técnicos de la salud, fuerzas de seguridad, escalafón general, y de otros poderes del Estado. \n\nCobrarán sus sueldos el personal de: Secretaría General de la Gobernación; Ministerio de Hacienda Pública; Ministerio de Gobierno, Justicia y Culto; Ministerio de Seguridad; Ministerio de Obras Públicas e Infraestructura; Ministerio de Educación; Ministerio de Desarrollo Social; Ministerio de Ciencia y Tecnología;  Ministerio de Salud;  Ministerio de Producción; Secretaría de Estado de la Mujer, Diversidad, e Igualdad; Secretaría de Estado de San Luis Logística; Secretaría de Estado de Ambiente; Secretaría de Estado de Turismo; Secretaría de Estado de Deportes;  Secretaría de Estado de Cultura;  Secretaría de Estado de Las Juventudes; Secretaría de Estado de Transporte; Secretaría de Estado de Comunicación;  Secretaría de Estado de Finanzas; Secretaría de Estado de Vivienda; Honorable Tribunal de Cuentas; Fiscalía de Estado; Poder Legislativo y Poder Judicial.",
      fecha: DateTime(2020, 2, 29),
      foto:
          "http://agenciasanluis.com/wp-content/uploads/2022/04/unnamed-4-768x448-1.jpg",
      autor: "Pablo Poder",
    ),
    Noticia(
      id: 2,
      titulo:
          "Denuncian otro golpe del Poder Ejecutivo a la Justicia Provincial",
      texto:
          "A través de una carta pública, un grupo de profesionales del foro local expresó su repudio a los nombramientos por parte del gobierno provincial de fiscales y defensores adjuntos del Poder Judicial sin evaluación previa.\n\n“Repudiamos dichas designaciones y el accionar de todos los poderes públicos que convalidaron esta grosería institucional e instamos como ciudadanos a que se dé cumplimiento a los procesos evaluatorios dispuestos por las leyes vigentes” expresa el documento que lleva la firma de más de una docena de profesionales.\n\nEse documento advierte que “la discrecionalidad manifiesta de hoy”, puede derivar “en procesos arbitrarios e ilegales el día de mañana, teniendo como principal víctima de ello al ciudadano de a pie”.\n\n“Con profunda preocupación advertimos un nuevo atropello a la Justicia Provincial y a la ciudadanía en general por parte del Poder Ejecutivo de la Provincia, al pretender designar nuevos funcionarios judiciales (fiscales y defensores adjuntos) sin mediar el proceso de evaluación previsto por la Ley Nº VI-615-2008 para aspirantes a cargos de Magistrados y Funcionarios del Poder Judicial, el cual procura —nada más y nada menos— garantizar la idoneidad de los mismos y la legalidad de dichas designaciones en rigor de lo dispuesto por el Art. 23 de la Constitución Provincial”\n\nLa carta pública lleva las firmas de los abogados Francisco Guiñazú, Rafael Berruezo, María Cecilia Hissa, Valentín Laborda Claverie, Santiago Calderón Salomón, Victoria Robledo, Héctor Cangiano (h), Nasrin El Chaer, Eduardo Brizuela, Samar El Chaer, Enrique Ipiña, Claudia Farabelli  y Katherina Lecumberry.",
      fecha: DateTime(7 - 06 - 2022),
      foto:
          "https://i0.wp.com/depolitica.com.ar/wp-content/uploads/2022/06/Superior-Tribunal.webp?w=1383&ssl=1",
      autor: "Lucille Poder",
    ),
    Noticia(
      id: 3,
      titulo: "Otra escuela de Juana Koslay ya tiene su Corazon Recolector",
      texto:
          "La Municipalidad de Juana Koslay continúa con esta iniciativa para juntar tapitas plásticas para el Hospital de Pediatría Garrahan. Esta vez fue el turno del Jardín Huellitas de Colores del barrio 274 Viviendas.\n\n «Es una iniciativa muy especial de la que ya forman parte distintas instituciones educativas de Juana Koslay y nos pone contentos que los más pequeños puedan participar y ayudar desde su jardín. Felicitaciones a las maestras por transmitirles a nuestros chicos estos valores… A juntar tapitas», escribió la Municipalidad de Juana Koslay en sus redes sociales. \n\n El objetivo del Corazón Recolector es llenarlo de tapitas plásticas que luego serán donadas a la Fundación Garrahan para comprar los insumos que necesite el hospital y colaborar con las familias y chicos que asisten a diario o están internados allí. \n\n El instituto San Francisco de Asís, la Escuela Pueyrredón y el Colegio San Vicente también tienen uno en sus instalaciones. Además, los vecinos que quieran sumarse y juntar tapitas pueden acercarse al Parque Urbano, sobre la costanera del barrio Los Eucaliptos, y dejarlas en el gran corazón.",
      fecha: DateTime(12 - 08 - 2022),
      foto:
          "https://i0.wp.com/infojuanakoslay.com.ar/wp-content/uploads/2022/04/278358312_345947210896541_4121887055379682200_n.jpg?w=1280",
      autor: "Pablo Poder",
    ),
  ];

  List<Noticia> get items {
    return [..._items];
  }

  Noticia fetchById(int id) {
    return _items.firstWhere((noticia) => noticia.id == id);
  }
}
