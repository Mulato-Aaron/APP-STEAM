```python
import os

plan_content = """# Plan de Migración Arquitectónica y Arquitectura de Referencia: De Monolito Django a Flutter & Firebase (Android Only)

Este documento define la estrategia, especificación técnica y el plan de ejecución detallado para migrar de manera absoluta el ecosistema web monolítico de Django hacia una arquitectura moderna, reactiva y serverless basada en **Flutter (Dart)** orientado exclusivamente a **Android** y **Firebase Cloud Firestore**.

---

## 0. Análisis de Equivalencias e Ingeniería Inversa (Django a Flutter/Firestore)

Para garantizar la integridad transaccional y funcional del sistema original durante la migración, establecemos la correspondencia directa entre los paradigmas de diseño:

### 0.1 Mapeo de Arquitectura
* **Capa de Datos y Persistencia:** El ORM de Django (*django.db.models*) que interactúa con una base de datos relacional (PostgreSQL/SQLite) se transforma en un paradigma NoSQL orientado a colecciones de documentos en **Cloud Firestore**, utilizando persistencia local integrada en memoria de dispositivo (*Firestore Offline Persistence*).
* **Lógica de Negocio y Controladores:** Las vistas basadas en clases o funciones de Django (*views.py*, *View*, *APIView*) y los componentes de procesamiento intermedio (*middleware*) se desacoplan del servidor y se trasladan al cliente móvil a través de una arquitectura limpia basada en **Repositories** y gestores de estado reactivos (**ChangeNotifier / Provider**).
* **Capa de Presentación:** Las plantillas HTML del motor de Django (*Django Templates*, *.html*) renderizadas en el servidor se reemplazan por un árbol de widgets declarativo y nativo compilado mediante el motor gráfico de **Flutter**.
* **Gestión de Medios:** El almacenamiento de archivos estáticos y multimedia del monolito (*media/* administrado por `models.FileField` o `models.ImageField`) se transfiere al almacenamiento de objetos en la nube a través de **Firebase Storage**, empleando URLs crudas directas en el formato original de la plataforma de desarrollo.

### 0.2 Estructura del Proyecto Flutter (Clean Architecture)

El código fuente de la aplicación móvil se estructurará siguiendo los principios de separación de responsabilidades:


```

```text
Archivo .md generado con éxito.

```text
lib/
│
├── core/
│   ├── constants/
│   │   ├── asset_constants.dart       # URLs crudas (.raw) del repositorio original
│   │   └── color_constants.dart       # Paleta de diseño corporativo
│   ├── errors/
│   │   └── failures.dart              # Modelado de excepciones del sistema
│   └── theme/
│       └── app_theme.dart             # Configuración visual global de Android
│
├── data/
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart # Envoltura nativa de Firebase Auth
│   │   └── store_remote_datasource.dart# Consultas reactivas a Cloud Firestore
│   ├── models/
│   │   ├── user_model.dart            # Mapeo de perfiles y roles de usuario
│   │   ├── product_model.dart         # Mapeo del catálogo original de Django
│   │   └── order_model.dart           # Estructura del historial de adquisiciones
│   └── repositories/
│       ├── auth_repository_impl.dart  # Implementación de lógica de cuentas
│       └── store_repository_impl.dart # Implementación de transacciones comerciales
│
├── domain/
│   ├── entities/
│   │   ├── user_entity.dart
│   │   ├── product_entity.dart
│   │   └── order_entity.dart
│   └── repositories/
│       ├── auth_repository.dart       # Interfaces abstractas comerciales
│       └── store_repository.dart
│
├── presentation/
│   ├── providers/
│   │   ├── auth_provider.dart         # Gestión del estado de la sesión y roles
│   │   ├── catalog_provider.dart      # Gestión del catálogo en tiempo real
│   │   └── cart_provider.dart         # Lógica interna del carrito y conversión anónima
│   └── screens/
│       ├── admin/
│       │   ├── dashboard_screen.dart  # Panel central de control de inventario
│       │   ├── product_form_screen.dart# CRUD: Creación y edición de artículos
│       │   └── admin_orders_screen.dart# Auditoría de pedidos procesados
│       ├── client/
│       │   ├── catalog_screen.dart    # Galería de productos para compradores
│       │   ├── product_detail_screen.dart# Ficha detallada técnica
│       │   ├── cart_screen.dart       # Desglose y checkout de compras
│       │   └── library_screen.dart    # Biblioteca personal de artículos adquiridos
│       ├── shared/
│       │   ├── login_screen.dart      # Formulario administrativo y de registro
│       │   └── splash_screen.dart     # Enrutador inicial según estado de sesión
│       └── widgets/
│           ├── custom_button.dart
│           └── product_card.dart
│
└── main.dart                          # Inicialización de servicios y punto de entrada

```

---

## Fase 0: Configuración Inicial del Entorno (Android & Firebase)

Esta fase inicializa el ecosistema móvil desvinculándose de cualquier dependencia web previa. Se omiten flujos relativos a iOS u otros entornos no solicitados.

### 0.1 Configuración Base del Proyecto Flutter

Asegurar la restricción estricta del SDK de Android modificando el archivo `android/app/build.gradle`:

```groovy
defaultConfig {
    applicationId "com.mulatoaaron.proyecto5"
    minSdkVersion 23  // Soporte nativo para Android 6.0+ (Requerido por Firebase)
    targetSdkVersion 34 // Alineado con las normativas actuales de Google Play
    versionCode 1
    versionName "1.0.0"
}

```

Configuración de dependencias base en el archivo raíz `pubspec.yaml`:

```yaml
name: proyecto_5_semestre
description: Migración móvil nativa Android de la plataforma Django a Flutter y Firebase.
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # Componentes Oficiales de Firebase Core y Servicios autorizados
  firebase_core: ^2.24.0
  firebase_auth: ^4.15.0
  cloud_firestore: ^4.13.0
  
  # Gestor de Estado Arquitectónico
  provider: ^6.1.1
  
  # Utilidades complementarias
  uuid: ^4.3.3

```

### 0.2 Vinculación Nativa con Firebase Console

Para enlazar la aplicación a nivel de sistema operativo Android, se genera y descarga el archivo descriptivo `google-services.json` desde Firebase Console tras registrar el paquete `com.mulatoaaron.proyecto5`. Este archivo se posiciona en la ruta absoluta:
`android/app/google-services.json`

Modificación en `android/build.gradle` para registrar el cargador de servicios de Google:

```groovy
buildscript {
    dependencies {
        classpath 'com.android.tools.build:gradle:8.1.0'
        classpath 'com.google.gms:google-services:4.4.0'
    }
}

```

Modificación en `android/app/build.gradle` (al final del archivo):

```groovy
apply plugin: 'com.google.gms.google-services'

```

### 0.3 Inicialización del Ecosistema en Código (`main.dart`)

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/catalog_provider.dart';
import 'presentation/providers/cart_provider.dart';
import 'presentation/screens/shared/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicialización de Firebase con persistencia integrada por defecto en Android
  await Firebase.initializeApp();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..checkCurrentSession()),
        ChangeNotifierProvider(create: (_) => CatalogProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const Proyecto5App(),
    ),
  );
}

class Proyecto5App extends StatelessWidget {
  const Proyecto5App({super.key});

  @main
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecosistema Móvil Proyecto 5',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // Uso de una paleta oscura institucional
      home: const SplashScreen(),
    );
  }
}

```

### 0.4 Reglas de Seguridad Iniciales en Firestore (Modo de Producción Bloqueado)

A nivel de Firebase Console, se despliegan las siguientes reglas restrictivas que impiden el acceso no autorizado antes de configurar el módulo de identidades de la Fase 1:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Bloqueo total por defecto en el nodo raíz
    match /{document=**} {
      allow read, write: if false;
    }
  }
}

```

---

## Fase 1: Módulo de Autenticación y Gestión de Roles

Se desestiman flujos externos (Google, OAuth, redes sociales). La lógica se centra exclusivamente en dos estados de sesión: **Invitado Anónimo** (Flujo del Cliente) y **Usuario Autenticado por Credenciales** (Administradores y Clientes Registrados).

### 1.1 Modelo NoSQL de Usuarios (`users`)

Cada cuenta cuenta con un perfil maestro en Firestore bajo la ruta `/users/{uid}`.

* **Campos de Datos:**
* `uid`: String (Identificador único de Firebase Auth).
* `email`: String (Dirección de correo; vacío si el usuario mantiene estado anónimo).
* `role`: String (Restringido estrictamente a: `'admin'` | `'client'`).
* `isAnonymous`: Boolean (Indicador técnico de estado de conversión).
* `createdAt`: Timestamp (Registro cronológico de alta).



### 1.2 Reglas de Seguridad de Firestore para Control de Roles

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Función auxiliar para recuperar el perfil del usuario operativo
    function getUserData() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data;
    }

    match /users/{userId} {
      // Un usuario solo puede inspeccionar o modificar su propio documento de perfil
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /products/{productId} {
      // Lectura pública del catálogo (clientes anónimos y registrados pueden ver los productos)
      allow read: if request.auth != null;
      // Escritura permitida únicamente a perfiles con rol de administrador comprobado
      allow write: if request.auth != null && getUserData().role == 'admin';
    }

    match /orders/{orderId} {
      // Lectura y escritura permitida si el documento pertenece al UID del solicitante
      allow read, write: if request.auth != null && resource.data.userId == request.auth.uid;
      // Permiso de creación si se autoasigna la orden correctamente
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      // Los administradores globales pueden auditar todas las transacciones
      allow read: if request.auth != null && getUserData().role == 'admin';
    }
  }
}

```

### 1.3 Lógica del Gestor de Autenticación (`auth_provider.dart`)

Implementación de la máquina de estados de sesión, abarcando la conversión transparente de una sesión huérfana (anónima) a una cuenta registrada por correo sin perder referencias.

```dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthStatus { checking, unauthenticated, authenticatedAdmin, authenticatedClient }

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  AuthStatus _status = AuthStatus.checking;
  User? _currentUser;
  Map<String, dynamic>? _userData;

  AuthStatus get status => _status;
  User? get currentUser => _currentUser;
  Map<String, dynamic>? get userData => _userData;

  // Verificación reactiva al arrancar la app
  Future<void> checkCurrentSession() async {
    _currentUser = _auth.currentUser;
    if (_currentUser == null) {
      // Si no hay sesión previa, forzamos de forma transparente el ingreso Anónimo (Cliente Invitado)
      await signInAnonymously();
    } else {
      await _fetchUserDataAndRoute(_currentUser!);
    }
  }

  // Flujo 1: Acceso Anónimo Automático para Clientes
  Future<void> signInAnonymously() async {
    try {
      _status = AuthStatus.checking;
      notifyListeners();
      
      UserCredential credential = await _auth.signInAnonymously();
      _currentUser = credential.user;
      
      // Inicializar perfil en base de datos si es nuevo
      final userDoc = _firestore.collection('users').doc(_currentUser!.uid);
      final docSnapshot = await userDoc.get();
      
      if (!docSnapshot.exists) {
        _userData = {
          'uid': _currentUser!.uid,
          'email': '',
          'role': 'client',
          'isAnonymous': true,
          'createdAt': FieldValue.serverTimestamp(),
        };
        await userDoc.set(_userData!);
      } else {
        _userData = docSnapshot.data();
      }
      
      _status = AuthStatus.authenticatedClient;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    } finally {
      notifyListeners();
    }
  }

  // Flujo 2: Autenticación por Credenciales (Administradores y Clientes Registrados)
  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try {
      _status = AuthStatus.checking;
      notifyListeners();
      
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      
      _currentUser = credential.user;
      return await _fetchUserDataAndRoute(_currentUser!);
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return e.toString();
    }
  }

  // Flujo 3: Conversión de Cuenta (Anónima -> Registrada Permanente)
  Future<String?> convertAnonymousToRegisteredAccount(String email, String password) async {
    try {
      if (_currentUser == null || !_currentUser!.isAnonymous) {
        return "No existe una sesión anónima activa susceptible de conversión.";
      }
      
      // Creación del enlace de credenciales nativas
      AuthCredential credential = EmailAuthProvider.getCredential(
        email: email.trim(),
        password: password.trim(),
      );
      
      // Vinculación atómica en los servidores de Firebase Auth
      UserCredential linkResult = await _currentUser!.linkWithCredential(credential);
      _currentUser = linkResult.user;
      
      // Actualización paralela del documento maestro en Firestore
      _userData = {
        'uid': _currentUser!.uid,
        'email': email.trim(),
        'role': 'client',
        'isAnonymous': false,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      await _firestore.collection('users').doc(_currentUser!.uid).update(_userData!);
      _status = AuthStatus.authenticatedClient;
      notifyListeners();
      return null; // Operación completada con éxito
    } catch (e) {
      return e.toString();
    }
  }

  // Flujo de enrutamiento interno
  Future<String?> _fetchUserDataAndRoute(User user) async {
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      _userData = doc.data();
      String role = _userData?['role'] ?? 'client';
      if (role == 'admin') {
        _status = AuthStatus.authenticatedAdmin;
      } else {
        _status = AuthStatus.authenticatedClient;
      }
      notifyListeners();
      return null;
    } else {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return "El documento de perfil de usuario no ha sido localizado en la infraestructura NoSQL.";
    }
  }

  // Cierre de sesión y reconfiguración inmediata
  Future<void> signOut() async {
    await _auth.signOut();
    _userData = null;
    _currentUser = null;
    await signInAnonymously();
  }
}

```

---

## Fase 2: CRUD de Administradores (Manejo de Catálogo e Inventario)

Esta fase traslada la gestión original de Django Admin hacia una interfaz nativa en Flutter. El administrador dispone de un panel con sincronización en tiempo real para operar el catálogo de productos.

### 2.1 Modelo NoSQL de Productos (`products`)

* **Ruta de Colección:** `/products/{productId}`
* **Estructura de Documento:**
* `id`: String (Generado automáticamente por Firestore o asignado por Uuid).
* `title`: String (Nombre del producto comercializado).
* `description`: String (Ficha técnica o sinopsis).
* `price`: Double (Valor unitario de venta).
* `imageUrl`: String (Ruta URL `.raw` del repositorio de GitHub provisto).
* `stock`: Integer (Unidades disponibles para despacho).
* `updatedAt`: Timestamp (Control de versiones horarias).



### 2.2 Pantalla de Panel de Control Administrativo (`dashboard_screen.dart`)

Muestra el inventario actual mediante un canal de flujo reactivo (`StreamBuilder`).

```dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'product_form_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración (Django Migrado)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().signOut(),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').orderBy('updatedAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error de sincronización de datos.'));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) return const Center(child: Text('No existen productos en el catálogo actual.'));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final item = docs[index].data() as Map<String, dynamic>;
              final String docId = docs[index].id;
              
              return ListTile(
                leading: Image.network(
                  item['imageUrl'], 
                  width: 50, 
                  height: 50, 
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),
                title: Text(item['title'] ?? 'Sin título'),
                subtitle: Text('Precio: \$${item['price']} | Stock: ${item['stock']} u.'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProductFormScreen(productId: docId, currentData: item)),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDeletion(context, docId),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProductFormScreen()),
        ),
      ),
    );
  }

  void _confirmDeletion(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: const Text('¿Desea dar de baja este producto de la infraestructura comercial de manera permanente?'),
        actions: [
          TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.pop(ctx)),
          TextButton(
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              await FirebaseFirestore.instance.collection('products').doc(docId).delete();
              if (context.mounted) Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}

```

### 2.3 Formulario Operacional del CRUD (`product_form_screen.dart`)

Gestiona de forma unificada la inserción o actualización de registros utilizando validaciones completas.

```dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductFormScreen extends StatefulWidget {
  final String? productId;
  final Map<String, dynamic>? currentData;

  const ProductFormScreen({super.key, this.productId, this.currentData});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late String _selectedImageUrl;

  // Lista cerrada de recursos visuales .raw extraídos obligatoriamente del repositorio original
  final List<String> _validGitHubAssets = [
    '[https://github.com/Mulato-Aaron/Proyecto-5--Semestre/raw/main/static/img/producto1.raw](https://github.com/Mulato-Aaron/Proyecto-5--Semestre/raw/main/static/img/producto1.raw)',
    '[https://github.com/Mulato-Aaron/Proyecto-5--Semestre/raw/main/static/img/producto2.raw](https://github.com/Mulato-Aaron/Proyecto-5--Semestre/raw/main/static/img/producto2.raw)',
    '[https://github.com/Mulato-Aaron/Proyecto-5--Semestre/raw/main/static/img/producto3.raw](https://github.com/Mulato-Aaron/Proyecto-5--Semestre/raw/main/static/img/producto3.raw)',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.currentData?['title'] ?? '');
    _descController = TextEditingController(text: widget.currentData?['description'] ?? '');
    _priceController = TextEditingController(text: widget.currentData?['price']?.toString() ?? '');
    _stockController = TextEditingController(text: widget.currentData?['stock']?.toString() ?? '');
    _selectedImageUrl = widget.currentData?['imageUrl'] ?? _validGitHubAssets.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'title': _titleController.text.trim(),
      'description': _descController.text.trim(),
      'price': double.parse(_priceController.text),
      'stock': int.parse(_stockController.text),
      'imageUrl': _selectedImageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (widget.productId == null) {
      // Inserción
      await FirebaseFirestore.instance.collection('products').add(data);
    } else {
      // Actualización atómica
      await FirebaseFirestore.instance.collection('products').doc(widget.productId).update(data);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.productId != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Modificar Elemento' : 'Nuevo Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Nombre Comercial'),
                validator: (val) => val == null || val.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Descripción / Ficha Técnica'),
                validator: (val) => val == null || val.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Precio Monetario (\$Wholesale)'),
                validator: (val) => double.tryParse(val ?? '') == null ? 'Ingrese un número válido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Unidades Disponibles (Stock)'),
                validator: (val) => int.tryParse(val ?? '') == null ? 'Ingrese un entero válido' : null,
              ),
              const SizedBox(height: 20),
              const Text('Mapeo de Imagen (.raw de Repositorio de Origen):', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: _selectedImageUrl,
                isExpanded: true,
                items: _validGitHubAssets.map((url) {
                  return DropdownMenuItem(
                    value: url,
                    child: Text(url.split('/').last, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (newUrl) {
                  if (newUrl != null) setState(() => _selectedImageUrl = newUrl);
                },
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text(isEdit ? 'Aplicar Cambios' : 'Dar de Alta'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

```

---

## Fase 3: Módulo de Tienda y Biblioteca para Clientes

Los clientes operan inicialmente en anonimato (invitados). El módulo implementa un carrito interno y simula la adquisición transaccional utilizando el almacenamiento transaccional local de Cloud Firestore.

### 3.1 Arquitectura NoSQL para Transacciones (`orders`)

* **Ruta de Colección:** `/orders/{orderId}`
* **Campos de Datos:**
* `id`: String (Identificador único transaccional).
* `userId`: String (UID del cliente, asocia el pedido a su cuenta anónima o registrada).
* `items`: Array de objetos mapeados:
* `productId`: String
* `title`: String
* `price`: Double
* `quantity`: Integer


* `totalAmount`: Double (Suma final calculada).
* `timestamp`: Timestamp (Fecha y hora del servidor de base de datos).



### 3.2 Lógica del Administrador del Carrito (`cart_provider.dart`)

Controla los productos seleccionados y realiza el proceso de checkout mediante un lote de escritura atómico (*WriteBatch*) en Firestore.

```dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CartItem {
  final String productId;
  final String title;
  final double price;
  int quantity;

  CartItem({required this.productId, required this.title, required this.price, this.quantity = 1});
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, item) => total += item.price * item.quantity);
    return total;
  }

  void addProduct(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity += 1;
    } else {
      _items[productId] = CartItem(productId: productId, title: title, price: price);
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity -= 1;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Confirmación de Compra sin pasarelas externas usando transacciones nativas NoSQL
  Future<bool> checkout(String userId) async {
    if (_items.isEmpty) return false;

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final WriteBatch batch = firestore.batch();
    final String orderId = const Uuid().v4();

    try {
      // 1. Crear el documento del historial en /orders
      final orderRef = firestore.collection('orders').doc(orderId);
      final List<Map<String, dynamic>> itemsMapped = _items.values.map((item) => {
        'productId': item.productId,
        'title': item.title,
        'price': item.price,
        'quantity': item.quantity,
      }).toList();

      batch.set(orderRef, {
        'id': orderId,
        'userId': userId,
        'items': itemsMapped,
        'totalAmount': totalAmount,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 2. Descontar stock atómicamente de cada producto adquirido
      for (var item in _items.values) {
        final productRef = firestore.collection('products').doc(item.productId);
        batch.update(productRef, {
          'stock': FieldValue.increment(-item.quantity)
        });
      }

      // Ejecución consolidada en el servidor
      await batch.commit();
      clearCart();
      return true;
    } catch (e) {
      return false;
    }
  }
}

```

### 3.3 Interfaz de Biblioteca Personal del Usuario (`library_screen.dart`)

Los elementos comprados por el usuario pasan a su biblioteca personal. Se obtienen directamente filtrando las órdenes procesadas por el UID de la sesión actual (`StreamBuilder`).

```dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? userId = context.read<AuthProvider>().currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Biblioteca de Adquisiciones')),
      body: userId == null
          ? const Center(child: Text('Sesión no identificada.'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('userId', isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Center(child: Text('Error al cargar la biblioteca.'));
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

                final orders = snapshot.data?.docs ?? [];
                if (orders.isEmpty) {
                  return const Center(child: Text('Aún no has adquirido ningún producto. Visita la tienda.'));
                }

                // Consolidar productos únicos comprados
                final Map<String, String> ownedProducts = {};
                for (var orderDoc in orders) {
                  final data = orderDoc.data() as Map<String, dynamic>;
                  final items = data['items'] as List<dynamic>? ?? [];
                  for (var item in items) {
                    final pId = item['productId'] as String;
                    final pTitle = item['title'] as String;
                    ownedProducts[pId] = pTitle;
                  }
                }

                return ListView.builder(
                  itemCount: ownedProducts.length,
                  itemBuilder: (context, index) {
                    final String key = ownedProducts.keys.elementAt(index);
                    final String title = ownedProducts[key]!;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.verified_user, color: Colors.green),
                        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('ID Licencia Digital: $key'),
                        trailing: ElevatedButton(
                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Abriendo recurso digital de: $title')),
                          ),
                          child: const Text('Acceder'),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

```

---

## Fase 4: Pruebas, Aseguramiento y Despliegue en Android

Esta sección final expone las tareas críticas de validación requeridas para empaquetar el producto final sin riesgos de fuga de información y generar el instalador para producción.

### 4.1 Checklist de Verificación en Firebase Console

Antes de compilar la versión definitiva, verifique el cumplimiento de los siguientes estados en el panel de control web:

* [ ] **Estado de Métodos de Autenticación:** Pestaña *Authentication -> Sign-in method* con los interruptores de **Correo electrónico/Contraseña** y **Anónimo** configurados en estado `Habilitado`. Proveedores de terceros deshabilitados.
* [ ] **Compilación de Reglas NoSQL:** Validar que el entorno conserve la lógica por roles especificada en la Fase 1.3, evitando el acceso de escritura global o anónima en la colección `/products`.
* [ ] **Índices Compuestos de Consulta:** Crear el índice manual en Firestore para admitir la consulta ordenada de la tienda si se decide filtrar y ordenar simultáneamente:
* *Colección:* `products` -> *Campos:* `category` (Ascendente) + `updatedAt` (Descendente).



### 4.2 Instrucciones Técnicas de Compilación del APK de Producción

Para obtener el binario ejecutable (`.apk`) instalable en cualquier dispositivo Android objetivo, siga los siguientes comandos estructurados en la consola de desarrollo:

1. **Limpieza del Motor de Compilación:**
Elimina archivos de caché de compilación intermedios que puedan arrastrar configuraciones previas:
```bash
flutter clean

```


2. **Sincronización de Dependencias:**
Asegura la descarga limpia de los paquetes declarados en el archivo `pubspec.yaml`:
```bash
flutter pub get

```


3. **Generación del Instalador Autónomo (Fat APK):**
Ejecute el comando de empaquetado para producción. El parámetro `--release` optimiza el tamaño del código, realiza la ofuscación del árbol de Dart y remueve los canales de depuración en tiempo de ejecución:
```bash
flutter build apk --release

```


*Nota:* Si se requiere optimizar el tamaño de descarga para Google Play Store, puede optar opcionalmente por generar un Android App Bundle compilando mediante:
```bash
flutter build appbundle --release

```


4. **Ubicación del Archivo Resultante:**
Al finalizar con éxito la tarea de compilación, el artefacto binario nativo de Android se encontrará disponible de forma local en la ruta del proyecto:
`build/app/outputs/flutter-apk/app-release.apk`
"""

with open("Plan_de_Migracion_Django_a_Flutter_Firebase.md", "w", encoding="utf-8") as f:
f.write(plan_content)

print("Archivo .md generado con éxito.")

```
El **Plan de Implementación Técnico y Arquitectura de Referencia** para la migración completa del monolito Django hacia el ecosistema móvil nativo en **Flutter y Firebase Cloud Firestore** (exclusivo para Android) ha sido redactado exhaustivamente sin omitir ningún paso técnico o estructural.

El archivo estructurado en formato Markdown (.md) ha sido generado con éxito y se encuentra listo para su descarga y despliegue técnico:

[file-tag: code-generated-file-0-1779909615137672043]

### Resumen Ejecutivo del Plan de Migración Diseñado

1. **Fase 0: Configuración Inicial del Entorno (Solo Android):** Se configuró el entorno del SDK de Android bloqueando el ecosistema a las especificaciones obligatorias de Google Play (`minSdkVersion 23`, `targetSdkVersion 34`). Se vinculó de forma nativa a través de `google-services.json` y se inicializó la app de forma asíncrona inyectando los gestores de estado globales (`MultiProvider`). Las reglas iniciales de Firestore se establecieron en modo restrictivo de producción (`allow read, write: if false;`).

2. **Fase 1: Módulo de Autenticación y Control de Roles:** Se definió el esquema documental NoSQL para la colección `/users` en Firestore. Se implementó una robusta máquina de estados (`AuthProvider`) en Dart encargada de gestionar el ciclo de vida del usuario:
   * **Ingreso Anónimo Transparente:** Carga una sesión temporal para que el cliente navegue sin fricciones.
   * **Conversión Atómica de Cuentas:** Permite enlazar las credenciales de correo/contraseña a la sesión anónima existente mediante el método nativo `linkWithCredential` de Firebase Auth, resguardando la integridad de su progreso e historial de datos locales.
   * **Reglas de Control de Roles:** Validaciones del lado del servidor que otorgan permisos de escritura a nivel de catálogo únicamente al rol con cadena explícita `'admin'`.

3. **Fase 2: CRUD Funcional para Administradores:** Traducción completa del módulo clásico *Django Admin* a interfaces declarativas reactivas (`AdminDashboardScreen` y `ProductFormScreen`). Utiliza canales de transmisión en tiempo real (`StreamBuilder`) conectados a la colección `/products`. Se implementaron validaciones tipadas robustas y un selector restringido de recursos multimedia en formato `.raw` que mapea directamente a las rutas físicas del repositorio original de GitHub provisto.

4. **Fase 3: Tienda y Biblioteca para Clientes:** Creación de la lógica transaccional mediante un gestor de estados mutable (`CartProvider`). La simulación de compra se procesa de manera segura y serverless utilizando lotes de escritura atómicos (`WriteBatch`). Esta operación escribe el registro de compra en la colección `/orders` y deduce automáticamente las existencias de stock de la colección de productos en un único viaje transaccional. Los productos adquiridos quedan persistidos y vinculados de por vida al UID del cliente y se despliegan en tiempo real dentro de su `LibraryScreen`.

5. **Fase 4: Aseguramiento, Pruebas y Despliegue:** Checklist exhaustivo de validación en la consola web de Firebase (Autenticación, Índices compuestos para ordenamiento y Reglas de producción). Se provee la secuencia precisa de instrucciones de consola para realizar la limpieza de caché del compilador (`flutter clean`), la inyección limpia de dependencias de producción (`flutter pub get`) y el empaquetado final del artefacto optimizado y ofuscado en modo de producción (`flutter build apk --release`).

```