import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // home: MyHomePage(),
    home: Navigator(
        onGenerateRoute: (settings) => MaterialPageRoute<dynamic>(
            settings: settings, builder: (context) => const CitiesScreen())),
  ));
}

/* class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            Navigator(
                onGenerateRoute: (settings) => MaterialPageRoute<dynamic>(
                    settings: settings, builder: (context) => const CitiesScreen())),
            Navigator(
                onGenerateRoute: (settings) => MaterialPageRoute<dynamic>(
                    settings: settings, builder: (context) => const NotificationsScreen()))
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) => setState(() => _selectedIndex = index),
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.message_outlined),
              selectedIcon: Icon(Icons.message),
              label: 'Cities',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_outlined),
              selectedIcon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text('Notifications')));
} */

class CitiesScreen extends StatelessWidget {
  const CitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.rootNavigator?.push(MaterialPageRoute<dynamic>(
                builder: (context) => Scaffold(appBar: AppBar(title: const Text('Settings'))))),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Semantics(
          container: true,
          label: 'Search for a city',
          // Using a [TextField] instead of a [TypeAheadField] results in no exceptions.
          // child: const TextField(),
          child: TypeAheadField<String>(
            suggestionsCallback: (search) => CityService().find(search),
            builder: (context, controller, focusNode) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: false,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'City'),
              );
            },
            itemBuilder: (context, city) => ListTile(title: Text(city)),
            onSelected: (city) => context.rootNavigator?.push(
              MaterialPageRoute<dynamic>(
                builder: (context) => Scaffold(appBar: AppBar(title: Text(city))),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CityService {
  final cities = ['London', 'Paris', 'Madrid', 'Rome', 'Berlin'];

  List<String> find(String search) {
    return cities.where((city) => city.toLowerCase().contains(search.toLowerCase())).toList();
  }
}

extension on BuildContext {
  /// Returns the root [NavigatorState] of this [BuildContext].
  NavigatorState? get rootNavigator {
    NavigatorState? navigator;
    visitAncestorElements((Element element) {
      if (element is StatefulElement && element.state is NavigatorState) {
        navigator = element.state as NavigatorState;
      }

      // Continue visiting ancestors.
      return true;
    });

    return navigator;
  }
}
