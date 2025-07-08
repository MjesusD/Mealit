import 'package:flutter/material.dart';
import 'dart:io'; // Importa para manejar archivos
import 'package:flutter/services.dart'; // Importa para manejar el portapapeles
import 'package:image_picker/image_picker.dart';
import '../entidades/persistent.dart';
import '../entidades/profile_notifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title});

  final String title;

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

// Enum definition
enum UserType {
  chef,
  cocinero,
  visitante;

  String get displayName { //cambiar a cocinero, visitante, chef
    switch (this) {
      case UserType.chef:
        return 'Chefsito';
      case UserType.cocinero:
        return 'Cocinero Entusiasta';
      case UserType.visitante:
        return 'Visitante';
    }
  }
}

class ProfilePageState extends State<ProfilePage> {
  //aca ira la logica de la card que se mostrara para editar al usuario

  File? profileImage;
  //final String title;
  late String username; // Nombre de usuario por defecto
  late UserType userType = UserType.visitante; // Tipo de usuario por defecto
  final TextEditingController usernameController = TextEditingController();
  //funcion para seleccionar una imagen del perfil

  @override
  void initState() {
    super.initState();
    // Cargar el tipo de usuario guardado al iniciar
    userType = UserPreferences.getUserType();
    username = UserPreferences.getUsername();
    usernameController.text = username;
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final image = UserPreferences.getProfileImage();
    if (image != null && await image.exists()) {
      setState(() {
        profileImage = image;
      });
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      // 1. Selecciona la imagen (de galería o cámara)
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: source == ImageSource.camera ? 50 : 70,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        // 2. Guarda la imagen en un archivo y persiste la ruta
        final imageFile = File(pickedFile.path);
        await UserPreferences.saveProfileImage(imageFile.path);

        // 3. Actualiza el estado con la nueva imagen
        setState(() {
          profileImage = imageFile;
        });
      }
    } on PlatformException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al seleccionar imagen: ${e.message}")),
        );
      }
    }
  }

  //funcion de las cards 0w0
  void editProfile(BuildContext context) {
    usernameController.text =
        username; // Inicializa el controlador con el nombre de usuario actual
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edicion de Perfil'),
        content: SingleChildScrollView(
          // Permite desplazamiento si el contenido es demasiado grande
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SafeArea(
                      // Asegura que el contenido no se superponga con la barra de estado
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.photo_library,
                            ), // Icono para la galería
                            title: const Text('Galería'),
                            onTap: () {
                              pickImage(ImageSource.gallery);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text('Cámara'),
                            onTap: () {
                              pickImage(ImageSource.camera);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                /*child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          profileImage != null
                              ? FileImage(
                                profileImage!,
                              ) // Si hay una imagen seleccionada, la muestra
                              : AssetImage('assets/pictures/p1.jpg')
                                  as ImageProvider, // Imagen por defecto
                    ),*/
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profileImage != null
                      ? FileImage(profileImage!)
                      : const AssetImage('assets/pictures/p1.jpg')
                            as ImageProvider,
                ),
              ),

              // despues de esto vendra una opcion donde se elegira que si es vendedor o productor o solo consumidor
              const SizedBox(
                height: 12,
              ), // Espacio entre el avatar y el campo de texto
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: username, // Muestra el nombre de usuario actual
                  hintText: 'Nombre de Usuario',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Tipo de Usuario:'),

              DropdownButton<UserType>(
                isExpanded: true,
                value: userType,
                items: UserType.values.map(
                  (UserType type) {
                    // Mapea los valores del enum UserType a DropdownMenuItem
                    // Muestra el nombre de usuario en el Dropdown
                    return DropdownMenuItem<UserType>(
                      value: type,
                      child: Text(type.displayName),
                    );
                  },
                ).toList(), // Convierte la lista de UserType a una lista de DropdownMenuItem
                onChanged: (UserType? newValue) {
                  if (newValue != null) {
                    setState(() {
                      userType =
                          newValue; // Actualiza el tipo de usuario seleccionado
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              // Puedes agregar más campos de edición aquí si es necesario
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('¿Cancelar edicion?'),
                  content: const Text('Todos los cambios se perderán.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Si'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('No'),
                    ),
                  ],
                ),
              );
            },
          ),
          ElevatedButton(
            child: const Text('Guardar'),
            onPressed: () async {
              if (profileImage != null) {
                await UserPreferences.saveProfileImage(profileImage!.path);
              }
              final selectedType = UserType.values.firstWhere(
                // Busca el tipo de usuario seleccionado
                (type) =>
                    type.displayName ==
                    usernameController
                        .text, // Compara el displayName del UserType con el texto del controlador
                orElse: () => UserType.visitante,
              );
              setState(() {
                // Actualiza el tipo de usuario
                //userType = selectedType; // Actualiza el tipo de usuario
                UserPreferences.saveUsername(
                  usernameController.text,
                ); // Guardar nombre
                setState(
                  () => username = usernameController.text,
                ); // Actualiza el nombre de usuario

                // puedes aca agregar la logica para guardar los cambios
                // Por ejemplo, enviar los datos a un servidor o guardarlos localmente
                UserPreferences.saveUserType(userType);
                Provider.of<ProfileNotifier>(
                  context,
                  listen: false,
                ).refreshProfile();
              });
              // Muestra un mensaje de éxito
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Perfil actualizado con éxito')),
              );

              Navigator.pop(context); // Cierra el diálogo
            },
          ),
        ],
      ),
      barrierDismissible:
          false, // Evita que se cierre al tocar fuera del diálogo
    );
  }

  //Aqui ira el build de la card que se mostrara para editar al usuario
  @override
  Widget build(BuildContext context) {
    return Vistaprofile(
      //cambiar por vistaprofile y arreglar las variables
      title: widget.title,
      profileImage: profileImage,
      username: username,
      onEditProfilePressed: () => editProfile(context),
    );
  }
}

class Vistaprofile extends StatelessWidget {
  final String title;
  final File? profileImage;
  final String username;
  final VoidCallback onEditProfilePressed;

  const Vistaprofile({
    super.key,
    required this.title,
    required this.profileImage,
    required this.username,
    required this.onEditProfilePressed,
  });

  void _showAccountSettings(BuildContext context) {
    // Aquí puedes implementar la lógica para mostrar la configuración de la cuenta
    showDialog(
      context: context,
      builder: (context) {
        Color currentColor = UserPreferences.getBackgroundColor();
        double currentFontSizeFactor = UserPreferences.getFontSizeFactor();
        bool isRound = UserPreferences.isProfileImageRound();
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Configuración de Cuenta'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.color_lens),
                      title: const Text('Color de fondo'),
                      trailing: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: currentColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onTap: () async {
                        final Color? pickedColor = await showDialog<Color>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Selecciona un color'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: currentColor,
                                onColorChanged: (color) {
                                  currentColor = color;
                                },
                                showLabel: true,
                                pickerAreaHeightPercent: 0.7,
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Cancelar'),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                child: const Text('Aceptar'),
                                onPressed: () =>
                                    Navigator.pop(context, currentColor),
                              ),
                            ],
                          ),
                        );

                        if (pickedColor != null) {
                          setState(() => currentColor = pickedColor);
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.format_size),
                      title: const Text('Tamaño fuente'),
                      subtitle: Slider(
                        value: currentFontSizeFactor,
                        min: 0.8,
                        max: 1.5,
                        divisions: 7,
                        label: '${(currentFontSizeFactor * 100).round()}%',
                        onChanged: (value) {
                          setState(() => currentFontSizeFactor = value);
                        },
                      ),
                    ),
                    //switch para cambiar la foto de perfil redonda o cuadrada
                    SwitchListTile(
                      title: const Text('Foto de perfil redonda'),
                      value: isRound,
                      onChanged: (value) {
                        setState(() {
                          isRound = value;
                          UserPreferences.saveProfileImageShape(value);
                        });
                      },
                      secondary: const Icon(Icons.account_circle_outlined),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: const Text('Guardar'),
                  onPressed: () async {
                    await UserPreferences.saveBackgroundColor(currentColor);
                    await UserPreferences.saveFontSizeFactor(
                      currentFontSizeFactor,
                    );
                    await UserPreferences.saveProfileImageShape(isRound);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Configuración guardada con éxito LOS DATOS TARDAN EN CARGAR',
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileImage = UserPreferences.getProfileImage();
    final isRound = UserPreferences.isProfileImageRound();
    final backgroundColor = UserPreferences.getBackgroundColor();
    final sizeFont = UserPreferences.getFontSizeFactor();
    return Scaffold(
      appBar: AppBar(
        //barra superior
        title: Text(title),
      ),
      backgroundColor: backgroundColor,

      body: Column(
        children: <Widget>[
          Padding(
            // Padding para el espacio alrededor del avatar
            // Espacio alrededor del avatar
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                isRound
                    ?
                      //----------------------------Fila para el avatar y el nombre
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage)
                            : const AssetImage('assets/pictures/p1.jpg')
                                  as ImageProvider,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(
                          10,
                        ), // Bordes redondeados
                        child: Image(
                          image:
                              profileImage !=
                                  null // Si hay una imagen de perfil, la muestra
                              ? FileImage(profileImage)
                              : const AssetImage('assets/pictures/p1.jpg')
                                    as ImageProvider, // Imagen de perfil
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover, // Ajusta la imagen al contenedor
                        ),
                      ),
                const SizedBox(width: 16), // Espacio entre el avatar y el texto
                //--------------------------- Expanded permite que el texto ocupe el espacio restante
                Expanded(
                  child: Column(
                    // Columna para el nombre y recetas
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '$username', // Reemplaza con el nombre del usuario
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.fastfood,
                            size: 16,
                            color: Color.fromARGB(255, 238, 205, 17),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '123 Recetas',
                            style: TextStyle(fontSize: 14),
                          ), // Reemplaza con el número de recetas),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Expanded(child: Divider(thickness: 1)),
                //aqui debe ir otro padding para el icono de la camara y la linea
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.exit_to_app,
                    size: 32,
                    color: Color.fromARGB(255, 197, 1, 1),
                  ),
                ),
                const Expanded(child: Divider(thickness: 1)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              // Lista de elementos
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.key_outlined),
                  title: const Text('Configuración de Cuenta'),
                  // Puedes agregar un onTap para la acción
                  onTap: () => _showAccountSettings(context),
                ),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text(
                    'Editar Perfil',
                  ), //                           AQUI SE LLAMA A LA CLASE DE ALLA ARRIBA QUE EDITA EL PERFIL
                  onTap: onEditProfilePressed,
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacidad'),
                  // Puedes agregar un onTap para la acción
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
