import 'package:flutter/material.dart';
import '../entidades/persistent.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../entidades/profile_notifier.dart';
import 'package:provider/provider.dart';
import '../pages/profile.dart';
import '../pages/home.dart';
//import 'database_helper.dart';

Drawer obtenerMenuLateral(BuildContext context) {
  final profileNotifier = Provider.of<ProfileNotifier>(context, listen: true);
  String username = UserPreferences.getUsername();
  final profileImage = UserPreferences.getProfileImage();
  return Drawer(
    //añadir a listview al drawer. Esto asegura que el usuario pueda desplazarse
    //a través de las opciones en el cajón si no hay suficiente espacio vertical
    // para encajar todo.
    // El Drawer es un widget que se desliza desde el lado de la pantalla
    //backgroundColor: Color.fromARGB(255, 246, 252, 246),
    child: ListView(
      // Importante: eliminar cualquier relleno de la ListView
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 0,
            right: 0,
            top: 22,
            bottom: 32,
          ),

          child: DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://www.lazayafruits.com/es/wp-content/uploads/sites/2/2020/08/nuevas-tendencias-en-pasteleria-industrial-1.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      profileImage != null
                          ? FileImage(profileImage)
                          : const AssetImage('assets/pictures/p1.jpg')
                              as ImageProvider,
                ),
                SizedBox(height: 2),

                //Text(data: username, style: TextStyle(fontSize: 10, color: Colors.white70)),

                // Nombre de usuario con ajuste automático
                AutoSizeText(
                  //si se demora en cargar el nombre de usuario, se mostrará un texto
                  username == null || username.isEmpty
                      ? 'Cargando nombre...'
                      : username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1, // Máximo de líneas que se mostrarán
                  minFontSize: 6, // Tamaño mínimo al que puede reducir
                  overflow: TextOverflow.ellipsis, // Muestra "..." si no cabe
                ),
                SizedBox(height: 1),
                // Tipo de usuario
                Text(
                  UserPreferences.getUserType().displayName,
                  style: TextStyle(fontSize: 5, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),

        ListTile(
          // de aqui en adelante son los elementos del menu lateral
          leading: const Icon(Icons.food_bank_outlined),
          title: const Text('Inicio'),
          onTap: () {
            // Actualiza el estado de la aplicación
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.person_2_outlined),
          title: const Text('Usuario'),
          onTap: () {
            // Update the state of the app
            //_onItemTapped(1);//------------------------------------------------------poner navegator push
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(title: "Perfil"),
              ),
            );
            // Then close the drawer
            //Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.favorite),
          title: const Text('Favoritos'),
          onTap: () {
            // Update the state of the app
            // _onItemTapped(2);//------------------------------------------------------poner navegator push
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(title: "Recetario"),
                //llamar a _loadPublications() si es necesario
              ),
            );
            // Then close the drawer
            //Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.message),
          title: const Text('Acerca de'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(title: "Acerca de"),
              ),
            );
          },
        ),
      ],
    ),
  );
}
