import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListEditingScreen(),
    );
  }
}

class ListEditingScreen extends StatefulWidget {
  @override
  _ListEditingScreenState createState() => _ListEditingScreenState();
}

class _ListEditingScreenState extends State<ListEditingScreen> {
  List<String> items = ['Item 1', 'Item 2', 'Item 3'];
  TextEditingController _controller = TextEditingController();

  void _editItem(int index) {
    // Inicializa el controlador de texto con el valor del elemento seleccionado
    _controller.text = items[index];
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edita el elemento'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: "Nuevo texto"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Actualiza el elemento en la lista
                setState(() {
                  items[index] = _controller.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Guardar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista con edición')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _editItem(index), // Llama a la función con el índice
            ),
          );
        },
      ),
    );
  }
}
