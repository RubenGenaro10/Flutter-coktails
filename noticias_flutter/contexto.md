# Contexto del Proyecto

Este documento describe la estructura del proyecto Flutter "easy_cocktail", la distribución de carpetas y el propósito de los archivos principales. Al final se incluye un apartado específico sobre el almacenamiento de datos y base de datos.

## Estructura General

- `pubspec.yaml`: Manifiesto del proyecto. Define el nombre, versión, dependencias (`flutter_bloc`, `http`, `sqflite`, `path`, `flutter_launcher_icons`), y recursos de Flutter.
- `analysis_options.yaml`: Reglas de linting/estilo para el análisis estático.
- `README.md`: Información general del proyecto.
- `assets/`: Recursos estáticos (por ejemplo, `assets/icons/icon.png`).
- `android/`, `ios/`, `web/`: Plataformas específicas generadas por Flutter.
- `lib/`: Código fuente principal de la aplicación (Dart). Es el núcleo del proyecto.

## Distribución en `lib/`

- `lib/main.dart`
  - Punto de entrada de la app Flutter. Aquí se inicializa la aplicación y se montan las páginas/blocs principales.

- `lib/core/`
  - `constants/`
    - `api_constants.dart`: Constantes relacionadas a la API remota (URLs, endpoints base, rutas).
    - `database_constants.dart`: Constantes de base de datos (nombre de la BD, nombres de tablas/columnas).
  - `database/`
    - `app_database.dart`: Inicialización y acceso a la base de datos local (SQLite mediante `sqflite`). Maneja apertura de la BD, creación de tablas y provee la instancia para DAOs.
  - `enums/`
    - `status.dart`: Enumeraciones de estados (por ejemplo, `loading`, `success`, `failure`) utilizadas por el BLoC y la UI.

- `lib/data/`
  - `local/`
    - `cocktail_dao.dart`: DAO (Data Access Object) para operaciones locales en SQLite (CRUD sobre la entidad de cócteles).
    - `cocktail_entity.dart`: Representación de la entidad tal como se guarda en BD (mapea columnas a propiedades).
  - `remote/`
    - `cocktail_dto.dart`: Objeto de transferencia de datos (DTO) para datos recibidos/enviados a la API. Normalmente mapea JSON ↔ objeto.
    - `cocktail_service.dart`: Servicio HTTP (`http` package) que llama a la API remota para listar/buscar cócteles.
  - `repositories/`
    - `cocktail_repository_impl.dart`: Implementación del repositorio que orquesta fuentes de datos remotas y locales. Expone métodos de alto nivel para la capa de dominio.

- `lib/domain/`
  - `models/`
    - `cocktail.dart`: Modelo de dominio (forma “limpia” usada por la lógica y la UI).
  - `repositories/`
    - `cocktail_repository.dart`: Contrato abstracto del repositorio (interface) que define qué operaciones están disponibles (por ejemplo, obtener lista de cócteles, guardar favoritos, etc.).

- `lib/presentation/`
  - `blocs/`
    - `cocktails_bloc.dart`: BLoC que gestiona el estado de la lista de cócteles. Recibe eventos, usa el repositorio y emite estados.
    - `cocktails_event.dart`: Eventos que disparan acciones en el BLoC (cargar, refrescar, buscar, etc.).
    - `cocktails_state.dart`: Estados representando la UI (cargando, datos listos, error, vacío, etc.).
  - `pages/`
    - `cocktail_card.dart`: Widget que muestra información de un cóctel individual.
    - `cocktails_list.dart`: Widget/lista que renderiza múltiples `cocktail_card` y maneja interacciones de scroll/refresh.
    - `cocktails_page.dart`: Página principal que consume el BLoC y compone la UI.

## Flujo de Datos y Responsabilidades

1. UI (Widgets en `presentation/pages`) dispara eventos al `cocktails_bloc`.
2. El BLoC usa el `cocktail_repository` para obtener/guardar datos.
3. El repositorio combina `remote` (API vía `cocktail_service`) y `local` (SQLite vía `cocktail_dao`).
4. Los datos se transforman entre `DTO` ↔ `Modelo de dominio` ↔ `Entidad` según el origen/destino.
5. El BLoC emite estados actualizados que la UI renderiza.

---

## Almacenamiento de Información y Base de Datos

Este proyecto utiliza SQLite mediante el paquete `sqflite` para persistencia local. A continuación, el esquema funcional típico según los archivos presentes:

- Inicialización
  - `app_database.dart` se encarga de abrir/crear la base de datos. Utiliza `database_constants.dart` para nombres de BD y tablas.
  - En la creación, se ejecutan sentencias `CREATE TABLE` para la(s) tabla(s) necesarias, por ejemplo una tabla de cócteles con columnas como `id`, `name`, `category`, `instructions`, etc. (Los nombres exactos vienen definidos en `cocktail_entity.dart`/`database_constants.dart`).

- Entidad y DAO
  - `cocktail_entity.dart` define el mapeo exacto de un registro en la tabla a un objeto Dart. Incluye métodos para convertir de/para `Map<String, dynamic>` (usado por `sqflite`).
  - `cocktail_dao.dart` implementa las operaciones CRUD:
    - Insertar/actualizar cócteles.
    - Consultar por id o listar todos.
    - Eliminar registros si aplica.

- Repositorio
  - `cocktail_repository_impl.dart` decide cuándo leer desde la API y cuándo desde la BD. Patrones comunes:
    - Cargar desde remoto y cachear localmente (insertar/actualizar entidades en SQLite).
    - Si no hay red, leer desde la BD local para ofrecer datos offline.

- Servicio Remoto
  - `cocktail_service.dart` obtiene datos de la API (`http`). Las respuestas JSON se convierten a `cocktail_dto.dart` y luego al modelo de dominio `cocktail.dart`.

- Conversión de Modelos
  - `cocktail.dart` (dominio) se convierte a `cocktail_entity.dart` (BD) para persistencia, y desde `cocktail_dto.dart` (API) para uso en UI/lógica.

### Ciclo típico de sincronización

1. La UI solicita cócteles → `cocktails_bloc` emite evento.
2. El repositorio llama al servicio remoto; si éxito, guarda/actualiza en SQLite vía `cocktail_dao`.
3. El repositorio devuelve la lista (idealmente desde la fuente local para consistencia), el BLoC emite estado `success` con los datos.
4. Sin conexión, el repositorio retorna lo disponible desde la BD local.

### Notas y dependencias relevantes

- `sqflite`: Motor SQLite para Flutter (Android/iOS). En web, normalmente se usa otra estrategia (el proyecto incluye carpeta `web`, pero la persistencia puede variar).
- `path`: Se usa para componer rutas del archivo de BD en dispositivos.
- `flutter_bloc`: Orquesta el flujo de eventos/estados entre UI y repositorio.
- `http`: Acceso a API remota.

---

## Ejemplos de Código — Plantillas para Nuevos Proyectos

Esta sección contiene ejemplos reales del proyecto que sirven como plantillas para mantener la misma arquitectura y patrones en futuras ampliaciones o nuevos proyectos.

### 1. Modelo de Dominio (`domain/models/cocktail.dart`)

```dart
class Cocktail {
  final String id;
  final String name;
  final String category;
  final String posterPath;
  final String instructions;
  final bool isFavorite;

  const Cocktail({
    required this.id,
    required this.name,
    required this.category,
    required this.posterPath,
    required this.instructions,
    required this.isFavorite,
  });

  Cocktail copyWith({
    String? id,
    String? name,
    String? category,
    String? posterPath,
    String? instructions,
    bool? isFavorite,
  }) {
    return Cocktail(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      posterPath: posterPath ?? this.posterPath,
      instructions: instructions ?? this.instructions,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
```

**Propósito**: Representa la entidad de negocio pura (sin dependencias de BD ni API). Incluye método `copyWith()` para inmutabilidad.

### 2. DTO Remoto (`data/remote/cocktail_dto.dart`)

```dart
import 'package:easy_cocktail/domain/models/cocktail.dart';

class CocktailDto {
  final String id;
  final String name;
  final String category;
  final String posterPath;
  final String instructions;

  const CocktailDto({
    required this.id,
    required this.name,
    required this.category,
    required this.posterPath,
    required this.instructions,
  });

  factory CocktailDto.fromJson(Map<String, dynamic> json) {
    return CocktailDto(
      id: json['idDrink'] as String,
      name: json['strDrink'] as String,
      category: json['strCategory'] as String,
      posterPath: json['strDrinkThumb'] as String,
      instructions: json['strInstructions'] as String,
    );
  }

  Cocktail toDomain() {
    return Cocktail(
      id: id,
      name: name,
      category: category,
      posterPath: posterPath,
      instructions: instructions,
      isFavorite: false,
    );
  }
}
```

**Propósito**: Mapea respuestas JSON de la API a objetos Dart. Convierte campos JSON a propiedades locales y ofrece método `toDomain()` para transformar a modelo de dominio.

### 3. Entidad Local (`data/local/cocktail_entity.dart`)

```dart
import 'package:easy_cocktail/domain/models/cocktail.dart';

class CocktailEntity {
  final String id;
  final String name;
  final String posterPath;

  const CocktailEntity({
    required this.id,
    required this.name,
    required this.posterPath,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'poster_path': posterPath};
  }

  factory CocktailEntity.fromMap(Map<String, dynamic> map) {
    return CocktailEntity(
      id: map['id'] as String,
      name: map['name'] as String,
      posterPath: map['poster_path'] as String,
    );
  }

  factory CocktailEntity.fromDomain(Cocktail cocktail) {
    return CocktailEntity(
      id: cocktail.id,
      name: cocktail.name,
      posterPath: cocktail.posterPath,
    );
  }
}
```

**Propósito**: Mapea registros de SQLite a objetos. Métodos `toMap()`/`fromMap()` para conversión con `sqflite`.

### 4. Base de Datos (`core/database/app_database.dart`)

```dart
import 'package:easy_cocktail/core/constants/database_constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();
  static final _instance = AppDatabase._();
  factory AppDatabase() => _instance;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database as Database;
  }

  Database? _database;

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), DatabaseConstants.databaseName);
        
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cocktails (
            id TEXT PRIMARY KEY,
            name TEXT,
            poster_path TEXT
          )
        ''');
      },
    );
  }
}
```

**Propósito**: Singleton que gestiona la única instancia de BD SQLite. `onCreate` define el esquema de tablas.

### 5. DAO — Data Access Object (`data/local/cocktail_dao.dart`)

```dart
import 'package:easy_cocktail/core/constants/database_constants.dart';
import 'package:easy_cocktail/core/database/app_database.dart';
import 'package:easy_cocktail/data/local/cocktail_entity.dart';

class CocktailDao {
  Future<void> insert(CocktailEntity cocktail) async {
    final db = await AppDatabase().database;
    await db.insert(DatabaseConstants.cocktailsTable, cocktail.toMap());
  }

  Future<void> delete(String id) async {
    final db = await AppDatabase().database;
    await db.delete(
      DatabaseConstants.cocktailsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Set<String>> getAllFavoriteIds() async {
    final db = await AppDatabase().database;
    final List maps = await db.query(DatabaseConstants.cocktailsTable);
    return maps.map((map) => map['id'] as String).toSet();
  }
}
```

**Propósito**: Operaciones CRUD en SQLite. Abstrae detalles de BD.

### 6. Servicio Remoto (`data/remote/cocktail_service.dart`)

```dart
import 'dart:convert';
import 'dart:io';
import 'package:easy_cocktail/core/constants/api_constants.dart';
import 'package:easy_cocktail/data/remote/cocktail_dto.dart';
import 'package:http/http.dart' as http;

class CocktailService {
  Future<List<CocktailDto>> getAllCocktails(String query) async {
    final Uri uri = Uri.parse(ApiConstants.baseUrl).replace(
      path: ApiConstants.cocktailsEndpoint,
      queryParameters: {'s': query},
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        final map = jsonDecode(response.body);
        final List jsons = map["drinks"];
        return jsons.map((json) => CocktailDto.fromJson(json)).toList();
      }
      return Future.error('Failed to search cocktails: ${response.statusCode}');
    } catch (e) {
      return Future.error('Failed to search cocktails: ${e.toString()}');
    }
  }
}
```

**Propósito**: Llamadas HTTP a la API. Convierte respuestas JSON a DTOs.

### 7. Repositorio Interface (`domain/repositories/cocktail_repository.dart`)

```dart
import 'package:easy_cocktail/domain/models/cocktail.dart';

abstract class CocktailRepository {
  Future<List<Cocktail>> getAllCocktails(String query);
  Future<void> toggleFavoriteCocktail(Cocktail cocktail);
}
```

**Propósito**: Contrato que define qué operaciones están disponibles. Separa dominio de implementación.

### 8. Repositorio Implementación (`data/repositories/cocktail_repository_impl.dart`)

```dart
import 'package:easy_cocktail/data/local/cocktail_dao.dart';
import 'package:easy_cocktail/data/local/cocktail_entity.dart';
import 'package:easy_cocktail/data/remote/cocktail_dto.dart';
import 'package:easy_cocktail/data/remote/cocktail_service.dart';
import 'package:easy_cocktail/domain/models/cocktail.dart';
import 'package:easy_cocktail/domain/repositories/cocktail_repository.dart';

class CocktailRepositoryImpl implements CocktailRepository {
  final CocktailService service;
  final CocktailDao dao;
  const CocktailRepositoryImpl({required this.service, required this.dao});

  @override
  Future<List<Cocktail>> getAllCocktails(String query) async {
    try {
      final List<CocktailDto> dtos = await service.getAllCocktails(query);
      final favoriteIds = await dao.getAllFavoriteIds();

      return dtos
          .map(
            (dto) => dto.toDomain().copyWith(
              isFavorite: favoriteIds.contains(dto.id),
            ),
          )
          .toList();
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> toggleFavoriteCocktail(Cocktail cocktail) async {
    if (cocktail.isFavorite) {
      await dao.delete(cocktail.id);
    } else {
      await dao.insert(CocktailEntity.fromDomain(cocktail));
    }
  }
}
```

**Propósito**: Orquesta datos remotos y locales. Maneja conversiones entre DTOs, Entidades y Modelos.

### 9. Estados del BLoC (`presentation/blocs/cocktails_state.dart`)

```dart
import 'package:easy_cocktail/core/enums/status.dart';
import 'package:easy_cocktail/domain/models/cocktail.dart';

class CocktailsState {
  final Status status;
  final List<Cocktail> cocktails;
  final String query;
  final String? message;

  const CocktailsState({
    this.status = Status.initial,
    this.cocktails = const [],
    this.query = '',
    this.message,
  });

  CocktailsState copyWith({
    Status? status,
    List<Cocktail>? cocktails,
    String? query,
    String? message,
  }) {
    return CocktailsState(
      status: status ?? this.status,
      cocktails: cocktails ?? this.cocktails,
      query: query ?? this.query,
      message: message ?? this.message,
    );
  }
}
```

**Propósito**: Representa el estado de la UI. `Status` indica si está cargando, completado, etc.

### 10. Eventos del BLoC (`presentation/blocs/cocktails_event.dart`)

```dart
import 'package:easy_cocktail/domain/models/cocktail.dart';

abstract class CocktailsEvent {
  const CocktailsEvent();
}

class GetAllCocktails extends CocktailsEvent {
  const GetAllCocktails();
}

class QueryChanged extends CocktailsEvent {
  final String query;
  const QueryChanged({required this.query});
}

class ToggleFavoriteCocktail extends CocktailsEvent {
  final Cocktail cocktail;
  const ToggleFavoriteCocktail({required this.cocktail});
}
```

**Propósito**: Eventos que disparan cambios en el BLoC.

### 11. BLoC (`presentation/blocs/cocktails_bloc.dart`)

```dart
import 'dart:async';
import 'package:easy_cocktail/core/enums/status.dart';
import 'package:easy_cocktail/domain/models/cocktail.dart';
import 'package:easy_cocktail/domain/repositories/cocktail_repository.dart';
import 'package:easy_cocktail/presentation/blocs/cocktails_event.dart';
import 'package:easy_cocktail/presentation/blocs/cocktails_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CocktailsBloc extends Bloc<CocktailsEvent, CocktailsState> {
  final CocktailRepository repository;
  CocktailsBloc({required this.repository}) : super(CocktailsState()) {
    on<GetAllCocktails>(_getAllCocktails);
    on<QueryChanged>(_queryChanged);
    on<ToggleFavoriteCocktail>(_toggleFavoriteCocktail);
  }

  FutureOr<void> _getAllCocktails(
    GetAllCocktails event,
    Emitter<CocktailsState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final List<Cocktail> cocktails = await repository.getAllCocktails(state.query);
      emit(state.copyWith(status: Status.success, cocktails: cocktails));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  FutureOr<void> _queryChanged(
    QueryChanged event,
    Emitter<CocktailsState> emit,
  ) {
    emit(state.copyWith(query: event.query));
  }

  FutureOr<void> _toggleFavoriteCocktail(
    ToggleFavoriteCocktail event,
    Emitter<CocktailsState> emit,
  ) async {
    await repository.toggleFavoriteCocktail(event.cocktail);
    final List<Cocktail> updatedCocktails = state.cocktails.map((cocktail) {
      if (cocktail.id == event.cocktail.id) {
        return cocktail.copyWith(isFavorite: !cocktail.isFavorite);
      }
      return cocktail;
    }).toList();
    emit(state.copyWith(cocktails: updatedCocktails));
  }
}
```

**Propósito**: Orquesta eventos, usa el repositorio, y emite estados. Maneja toda la lógica de negocio.

### Resumen de Patrones Clave

1. **Singleton para BD**: `AppDatabase` asegura una única conexión.
2. **Conversión en Capas**: `DTO → Modelo Dominio → Entidad` según flujo.
3. **BLoC para Estado**: Los widgets consumen `CocktailsBloc` para reactividad.
4. **Inyección de Dependencias**: El repositorio recibe `service` y `dao` en constructor.
5. **Inmutabilidad**: Los modelos usan `copyWith()` para copias seguras.

---

## Navegación: `MainPage` con BottomNavigationBar

Para proyectos futuros con múltiples secciones, ubica el contenedor de navegación en `lib/presentation/pages/main_page.dart`. Este widget administra la navegación por pestañas usando `BottomNavigationBar` y delega a páginas existentes como `CocktailsPage`.

### Ubicación

- Archivo: `lib/presentation/pages/main_page.dart`

### Plantilla de código

```dart
import 'package:easy_cocktail/presentation/pages/cocktails_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  final List<Widget> pages = const [
    CocktailsPage(),
    Center(child: Text('Favoritos')), // Reemplazar por página real
    Center(child: Text('Perfil')),    // Reemplazar por página real
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages[selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_bar_outlined),
            activeIcon: Icon(Icons.local_bar),
            label: 'Cócteles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
```

### Integración en `main.dart`

Usa `MainPage` como `home` de tu `MaterialApp` y provee los BLoCs necesarios con `BlocProvider` o `MultiBlocProvider`:

```dart
import 'package:easy_cocktail/data/local/cocktail_dao.dart';
import 'package:easy_cocktail/data/remote/cocktail_service.dart';
import 'package:easy_cocktail/data/repositories/cocktail_repository_impl.dart';
import 'package:easy_cocktail/presentation/blocs/cocktails_bloc.dart';
import 'package:easy_cocktail/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = CocktailRepositoryImpl(
      service: CocktailService(),
      dao: CocktailDao(),
    );
    return BlocProvider(
      create: (context) => CocktailsBloc(repository: repository),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainPage(),
      ),
    );
  }
}

// Si necesitas múltiples BLoCs:
// return MultiBlocProvider(
//   providers: [
//     BlocProvider(create: (_) => CocktailsBloc(repository: repository)),
//     // Otros BlocProvider(...)
//   ],
//   child: const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: MainPage(),
//   ),
// );

```
