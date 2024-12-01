import 'package:cooking_hub/presentation/providers/chat_provider.dart';
import 'package:cooking_hub/widgets/shared/message_field_box.dart';
import 'package:cooking_hub/widgets/styles/containerStyle.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MessageFieldButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const MessageFieldButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        decoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
        child: IconButton(
          icon: Icon(icon),
          onPressed: onTap,
        ),
      ),
    );
  }
}

// Widget principal donde van botones y donde escribe el usuario
class MessageFieldContainer extends StatelessWidget {
  final Function(String) onValue;

  const MessageFieldContainer({
    super.key,
    required this.onValue,
  });

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return Container(
      // margin: const EdgeInsets.only(bottom: 10, right: 10),
      
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          // Boton de adjuntar
          MessageFieldButton(
            icon: Icons.photo_size_select_actual_outlined,
            onTap: () 
              // // TODO: agregar la logica para seleccionar imagen de la galeria
              => chatProvider.sendIngredientsByPhoto(ImageSource.gallery)
            
          ),
          // Boton de abrir camara
          MessageFieldButton(
            icon: Icons.camera_alt_outlined,
            onTap: () => chatProvider.sendIngredientsByPhoto(ImageSource.camera),
          ),
          // Chat
          Expanded(
            child: MessageFieldBox(
              onValue: (value) => onValue(value),
            ),
          ),
          SizedBox(width: 10,)
        ],
      ),
    );
  }
}
