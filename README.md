# Cars Maintenance App 🚗

Una aplicación móvil Flutter para el mantenimiento de vehículos con notificaciones automáticas, autenticación Firebase y persistencia offline.

## 📋 Características Principales

- **Gestión de Actividades de Mantenimiento**: Crear, editar, eliminar y visualizar actividades de mantenimiento
- **Autenticación con Google**: Inicio de sesión seguro usando Firebase Auth
- **Notificaciones Programadas**: Recordatorios automáticos para actividades de mantenimiento
- **Persistencia Offline**: Funciona sin conexión a internet
- **Interfaz Intuitiva**: UI moderna con Material Design 3
- **Categorización**: Organización por categorías (motor, neumáticos, aceite, frenos)

## 🏗️ Arquitectura del Proyecto

### Estructura de Directorios

```
lib/
├── main.dart                   # Punto de entrada de la aplicación
├── components/                 # Componentes reutilizables
│   └── multi_componentes.dart  # DrawerMenu y otros componentes
├── funcionality/              # Funcionalidades específicas
│   └── add_manten.dart        # Pantalla para agregar mantenimiento
├── models/                    # Modelos de datos
│   ├── activity.dart          # Modelo de actividad de mantenimiento
│   ├── user_model.dart        # Modelo de usuario
│   └── index.dart             # Exportaciones de modelos
├── provider/                  # Gestión de estado
│   └── storage_provider.dart  # Provider para datos de usuario
├── router/                    # Configuración de rutas
│   └── router_configure.dart  # Configuración de GoRouter
├── screens/                   # Pantallas de la aplicación
│   ├── login_page.dart        # Pantalla de inicio de sesión
│   ├── maintenance_list_page.dart # Lista de mantenimientos
│   ├── activity_detail_page.dart  # Detalles de actividad
│   ├── edit_manten.dart       # Editar mantenimiento
│   ├── history_page.dart      # Historial
│   ├── settings_page.dart     # Configuraciones
│   └── index.dart             # Exportaciones de pantallas
├── services/                  # Servicios de la aplicación
│   ├── auth_service.dart      # Servicio de autenticación
│   ├── firestore_service.dart # Servicio de Firestore
│   ├── user_service.dart      # Servicio de usuario
│   └── messaging_service.dart # Servicio de mensajería
└── utils/                     # Utilidades
    ├── notifications.dart     # Gestión de notificaciones
    └── category_icon.dart     # Iconos por categoría
```

## 🔧 Servicios

### AuthService
Maneja la autenticación de usuarios:
- Inicio de sesión con Google
- Inicio de sesión con email/contraseña
- Cierre de sesión
- Verificación de estado de autenticación

### ActivityService (FirestoreService)
Gestiona las actividades de mantenimiento:
- CRUD completo de actividades
- Filtrado por usuario
- Persistencia offline
- Sincronización con Firestore

### UserService
Maneja los datos del usuario:
- Crear/actualizar perfil de usuario
- Gestión de horarios de notificación
- Eliminación de datos de usuario

### NotificationService
Sistema de notificaciones:
- Notificaciones programadas
- Configuración de canales
- Permisos de notificación

## 📱 Modelos de Datos

### Activity
```dart
class Activity {
  final String id;
  final String userId;
  String name;
  String description;
  final String category;
  final int rating;
  final int price;
  final int startTimes;
  final DateTime lastPerformed;
  final DateTime nextReminder;
  final List<String> location;
  final List<String> tags;
  final bool? isPending;
}
```

### UserModel
```dart
class UserModel {
  final String id;
  String name;
  String email;
  String photoUrl;
  TimeOfDay? startNotificationTime;
}
```

## 🛣️ Sistema de Rutas

La aplicación utiliza GoRouter para la navegación:

- `/` - Pantalla de login
- `/maintenance` - Lista principal de mantenimientos
- `/details/:id` - Detalles de una actividad
- `/editManten/:id` - Editar mantenimiento
- `/newManten` - Crear nuevo mantenimiento
- `/settings` - Configuraciones
- `/history` - Historial de actividades

## 🔄 Gestión de Estado

Utiliza Provider para la gestión de estado:

### StorageProvider
- Almacena datos del usuario en memoria
- Sincroniza con Firebase Auth
- Gestiona configuraciones de notificación

## 🔐 Configuración de Firebase

La aplicación requiere:
- Firebase Authentication (Google Sign-In)
- Cloud Firestore (base de datos)
- Firebase Messaging (notificaciones push)

### Colecciones de Firestore:
- `activities`: Actividades de mantenimiento por usuario
- `users`: Perfiles de usuario y configuraciones

## 📦 Dependencias Principales

```yaml
dependencies:
  flutter: sdk
  firebase_auth: ^5.2.1
  firebase_core: ^3.4.1
  cloud_firestore: ^5.4.1
  go_router: ^14.2.7
  provider: ^6.1.2
  awesome_notifications: ^0.9.3+1
  google_sign_in: ^6.2.1
  timezone: ^0.9.4
  logger: ^2.4.0
  uuid: ^4.5.0
```

## 🚀 Instalación y Configuración

1. **Clonar el repositorio**
```bash
git clone <repository-url>
cd cars-mantinance
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar Firebase**
   - Crear proyecto en Firebase Console
   - Habilitar Authentication (Google)
   - Habilitar Firestore Database
   - Descargar `google-services.json` para Android
   - Configurar iOS si es necesario

4. **Ejecutar la aplicación**
```bash
flutter run
```

## 🎯 Funcionalidades por Pantalla

### Login Page
- Autenticación con Google
- Validación de usuarios
- Redirección automática

### Maintenance List Page
- Lista de actividades pendientes
- Filtros por categoría
- Navegación a detalles

### Activity Detail Page
- Información completa de la actividad
- Opciones de edición
- Marcar como completada

### Add/Edit Maintenance
- Formularios para crear/editar
- Selección de categorías
- Programación de recordatorios

### Settings Page
- Configuración de notificaciones
- Gestión de perfil
- Cerrar sesión

### History Page
- Historial de mantenimientos completados
- Búsqueda y filtros

## 🔔 Sistema de Notificaciones

- **Canal**: `maintenance_channel`
- **Tipos**: Recordatorios de mantenimiento
- **Programación**: Basada en fechas de `nextReminder`
- **Permisos**: Solicitud automática al usuario

## 🌐 Soporte Offline

- Firestore con persistencia habilitada
- Cache local de datos de usuario
- Sincronización automática al reconectar

## 📱 Compatibilidad

- **Android**: SDK mínimo configurado
- **iOS**: Soporte completo
- **Web**: Parcial (limitaciones de notificaciones)

## 🧪 Testing

```bash
flutter test
```

## 📄 Licencia

Este proyecto es para uso educativo/personal.

---

**Desarrollado con Flutter 💙**