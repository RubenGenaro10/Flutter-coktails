# Easy Travel — Contexto del Proyecto

Este documento resume las dependencias usadas, la arquitectura, la distribución de carpetas/archivos y cómo se conectan los componentes del proyecto.

## Dependencias
- **flutter**: SDK base para UI y widgets.
- **http (^)**: Cliente HTTP para consumir APIs REST.
- **flutter_bloc (^)**: Patrón BLoC para gestión de estado reactivo por eventos/estados.
- **sqflite (^)**: Base de datos SQLite local para persistencia estructurada.
- **shared_preferences (^)**: Almacenamiento sencillo de pares clave/valor (preferencias).
- **flutter_secure_storage (^)**: Almacenamiento seguro cifrado (ej. tokens sensibles).
- **path (^)**: Utilidades para manipulación de rutas de archivos.
- **flutter_launcher_icons (dev/tool)**: Generación de íconos de lanzamiento para Android/iOS.
- **flutter_test**: Pruebas unitarias/integración.
- **flutter_lints**: Reglas de linting y buenas prácticas.

Versiones específicas están definidas en [pubspec.yaml](pubspec.yaml).

## Arquitectura
Arquitectura por capas con principios de separación de responsabilidades y BLoC para la presentación:
- **Core**: utilitarios transversales (constantes, enums, base de datos, almacenamiento, tema).
- **Features**: módulos funcionales independientes (auth, favorites, home, main) con subcapas `data`, `domain`, `presentation`.
- **Shared**: modelos/entidades compartidas entre features.
- **Entrypoint**: `lib/main.dart` inicializa la app y el `MainPage`.

Capas por feature:
- **Data**: servicios remotos/locales, DTOs y repositorios concretos.
- **Domain**: contratos (interfaces) y modelos de negocio.
- **Presentation**: BLoCs (eventos/estados) + páginas y widgets.

## Distribución de Carpetas y Archivos
Raíz Flutter estándar (android/, ios/, web/, assets/, build/). En `lib/`:
- `lib/main.dart`: punto de entrada de la app.
- `lib/core/`
  - `constants/api_constants.dart`: URLs/paths base de API.
  - `database/app_database.dart`: configuración y acceso a SQLite.
  - `enums/` (`category_type.dart`, `status.dart`): enumeraciones comunes.
  - `storage/token_storage.dart`: gestión de tokens (Secure Storage/Shared Prefs).
  - `ui/theme.dart`: tema y estilos de la app.
- `lib/features/auth/`
  - `data/auth_service.dart`: servicio de autenticación (HTTP, tokens).
  - `domain/user.dart`: modelo de usuario.
  - `presentation/blocs/` (`auth_bloc.dart`, `auth_event.dart`, `auth_state.dart`, `login_*`): control de sesión/login.
  - `presentation/pages/` (`login_page.dart`, `splash_page.dart`): pantallas de acceso y arranque.
- `lib/features/favorites/`
  - `data/favorite_dao.dart`: acceso local a favoritos (SQLite).
  - `presentation/blocs/` (`favorite_list_*`): estado de la lista de favoritos.
  - `presentation/favorite_list_page.dart`: UI para favoritos.
- `lib/features/home/`
  - `data/` (`destination_service.dart`, `review_service.dart`, `destination_dto.dart`, `destination_repository_impl.dart`): consumo de API, DTOs y repo concreto.
  - `domain/` (`destination_repository.dart`, `review.dart`): contratos y modelos.
  - `presentation/blocs/` (`destinations_*`, `destination_detail_*`): listado y detalle de destinos.
  - `presentation/pages/` (`home_page.dart`, `destination_detail_page.dart`): pantallas.
  - `presentation/widgets/` (`destination_card.dart`, `review_rating.dart`): UI reusable.
- `lib/features/main/main_page.dart`: contenedor principal tras autenticación.
- `lib/shared/domain/destination.dart`: modelo compartido de destino.

## Conexiones Entre Componentes
- **Servicios (Data) ↔ API/DB**:
  - `auth_service.dart` usa **http** y `api_constants.dart` para login/refresh; guarda/lee tokens con `token_storage.dart` (Secure Storage/Shared Prefs).
  - `destination_service.dart` y `review_service.dart` consumen endpoints REST con **http**.
  - `favorite_dao.dart` persiste y consulta favoritos en **sqflite** vía `app_database.dart`.

- **Repositorios (Data) ↔ Dominio**:
  - `destination_repository_impl.dart` implementa `destination_repository.dart`, mapea `destination_dto.dart` a modelos del dominio (`shared/domain/destination.dart`) y expone métodos que usa la capa de presentación.

- **BLoC (Presentation) ↔ Data/Dominio**:
  - `auth_bloc.dart` orquesta sesión: emite `AuthState` ante `AuthEvent` usando `auth_service.dart` y `token_storage.dart`.
  - `login_bloc.dart` maneja credenciales y resultados de `auth_service.dart`.
  - `destinations_bloc.dart` consulta `destination_repository_impl.dart` para listar destinos.
  - `destination_detail_bloc.dart` trae detalle y reseñas desde servicios/repos.
  - `favorite_list_bloc.dart` interactúa con `favorite_dao.dart` para CRUD de favoritos.

- **UI (Pages/Widgets) ↔ BLoC**:
  - `login_page.dart` y `splash_page.dart` despachan eventos a `auth_bloc.dart`/`login_bloc.dart` y reaccionan a estados.
  - `home_page.dart` consume `destinations_bloc.dart` (lista) y navega a `destination_detail_page.dart`.
  - `destination_card.dart` muestra datos del destino; `review_rating.dart` renderiza puntuaciones.

- **Core** soporta transversalmente:
  - `theme.dart` aplicado globalmente.
  - `app_database.dart` inicializa SQLite para DAOs.
  - `api_constants.dart` centraliza rutas.
  - `token_storage.dart` abstrae almacenamiento seguro.

## Flujo de Datos (Resumen)
1. UI dispara eventos BLoC (ej. cargar destinos, login).
2. BLoC usa repos/servicios para obtener datos (HTTP/SQLite).
3. Data retorna DTOs/modelos; repos mapean a dominio.
4. BLoC emite estados; UI se reconstruye con los nuevos datos.
5. Almacenamiento: tokens en `token_storage`, favoritos en SQLite vía `favorite_dao`.

## Notas de Desarrollo
- Configurar ícono de app con `flutter_launcher_icons` (ya definido en `pubspec.yaml`).
- Mantener separación entre `data` (fuentes/DTOs), `domain` (contratos/modelos) y `presentation` (BLoC/UI).
- Reutilizar `shared/domain` para entidades comunes.

## Archivos Clave
- Entrypoint: [lib/main.dart](lib/main.dart)
- Tema: [lib/core/ui/theme.dart](lib/core/ui/theme.dart)
- Base de datos: [lib/core/database/app_database.dart](lib/core/database/app_database.dart)
- Constantes API: [lib/core/constants/api_constants.dart](lib/core/constants/api_constants.dart)
- Auth: [lib/features/auth/data/auth_service.dart](lib/features/auth/data/auth_service.dart), [lib/features/auth/presentation/pages/login_page.dart](lib/features/auth/presentation/pages/login_page.dart)
- Favoritos: [lib/features/favorites/data/favorite_dao.dart](lib/features/favorites/data/favorite_dao.dart), [lib/features/favorites/presentation/favorite_list_page.dart](lib/features/favorites/presentation/favorite_list_page.dart)
- Destinos: [lib/features/home/data/destination_repository_impl.dart](lib/features/home/data/destination_repository_impl.dart), [lib/features/home/presentation/pages/home_page.dart](lib/features/home/presentation/pages/home_page.dart)
