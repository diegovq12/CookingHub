import 'package:cooking_hub/domain/entities/recipe_model.dart';
import 'package:cooking_hub/domain/entities/user_model.dart';
import 'package:cooking_hub/presentation/screens/mercados.dart';
import 'package:cooking_hub/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:cooking_hub/widgets/shared/background_image.dart';
import 'package:cooking_hub/widgets/shared/hot_bar.dart';
import 'package:cooking_hub/widgets/styles/textStyles.dart';
import 'package:cooking_hub/widgets/styles/containerStyle.dart';

class RecetasGuardadas extends StatefulWidget{
  const RecetasGuardadas({super.key});

  @override
  State<StatefulWidget> createState() => _RecetasGuardadas();
}

class _RecetasGuardadas extends State<RecetasGuardadas>{

  bool loadedBand = false;

  List<String> recipes = [];

  void loadrecipes() async {
    var user = await UserService.getUsers("673516bd55397c8475000000");

    if (user == null) {
      return;
    }

    for(int i =0;i<user.listFavoriteRecipes.length;i++){
      recipes.add(user.listFavoriteRecipes[i].name);
    }

    loadedBand=true;
    
    setState(() {
      
    });
  }

  Future<void> deleteRecipe(int index)async{
    var user = await UserService.getUsers("673516bd55397c8475000000");

    if (user == null) {
      return;
    }
    await UserService.deleteFavoriteRecipe("673516bd55397c8475000000", user.listFavoriteRecipes[index]);
    recipes.removeAt(index);
    setState(() {
      
    });
  }

  Future<void> addRecipe(String newRecipe)async{
    
    List<String> nulo = [];
    Recipe temp=Recipe(name: newRecipe, region: "", ingredients: nulo, steps: nulo);
    
    await UserService.addFavoriteRecipe("673516bd55397c8475000000", temp);
    recipes.add(newRecipe);
    setState(() {
      
    });
    
  }
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if(!loadedBand) {
      loadrecipes();
    }

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            BackgroundImage(),
            
            // Titulo
            Container(
              decoration: ContainerStyle.topContainerDec(),
              height: screenHeight*0.1,
              width: screenWidth,
              alignment: Alignment.center,
              child: Expanded(child: Center(child: Text("Recetas Guardadas",style: Textstyles.recipesGtitleStyle(),))),
            ),
            
            // Container principal de la lista
            Container(
              decoration: ContainerStyle.genContainerDec(),
              height: screenHeight,
              width: screenWidth,
              margin: EdgeInsets.only(top: screenHeight*0.15,),
              child: 
                recipesList(screenWidth, screenHeight),
            ),

            InkWell(
              onTap: (){
                createNewRecipe(screenWidth, screenHeight);
              },
              child: Container(
                decoration: ContainerStyle.buttonContainerDec(),
                padding: EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 8
                ),
                margin: EdgeInsets.only(
                  top: screenHeight*0.13,
                  left: screenWidth*0.03
                ),
                child: Icon(Icons.add,color: Colors.white,),
              ),
            ),

            HotBar(),
          ],
        ),
      )
    );
  }

  Container recipesList(double screenWidth, double screenHeight) {
    return Container(
                margin: EdgeInsets.only(left: screenWidth*0.02),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: screenHeight*0.02,),
                    Expanded(
                      child: ListView.builder(
                        itemCount: recipes.length,
                        itemBuilder: (context,index){
                          return ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RecetaGS(index)));
                                    },
                                    child: Text("• ${recipes[index]}", style: Textstyles.normalStyle(),)
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    confirmDelete(context, screenWidth, screenHeight, index);
                                  },
                                  child: Container(
                                    decoration: ContainerStyle.buttonContainerDec(),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 8
                                    ),
                                    child: Image.asset("assets/icons/delete.png",width: screenHeight*0.02,),
                                  )
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                    )
                  ],
                ),
              );
  }

  final TextEditingController nameController = TextEditingController();

  String newRecipe = "";

  void createRecipe(){
    setState(() {
      newRecipe = nameController.text.toString();
      if(newRecipe == ""){
        newRecipe = "Receta nueva";
      }
      nameController.clear();
    });
  }

  void createNewRecipe(double screenWidth, double screenHeight){
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: true,
      builder: (BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32))
          ),
          backgroundColor: Color(0xFFFF8330),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: screenHeight*0.01,),
                Text("Titulo de la receta",style: Textstyles.normalStyle(),),
                SizedBox(height: screenHeight*0.02,),
                TextField(
                  controller: nameController,
                  decoration: inputBoxName(),
                ),
                SizedBox(height: screenHeight*0.02,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pop(true);
                      },
                      child: Text("Cancelar",style: Textstyles.normalStyle(),),
                    ),
                    
                    InkWell(
                      onTap: (){
                        setState(() {  
                          // createNewRecipe(screenWidth, screenHeight);
                          if(nameController.text.toString() != "")
                          {
                            addRecipe(nameController.text.toString());
                            // Navigator.of(context).pop(true);
                            recipeOK(context, screenWidth, screenHeight);
                          }
                          else{
                            Navigator.of(context).pop(true);
                          }
                        });
                      },
                      child: Text("Confirmar",style: Textstyles.normalStyle(),),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight*0.02,),
              ],
            ),
          ),
        );
      }
    );
  }
  
  void errorNewRecipe(double screenWidth, double screenHeight){
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: true,
      builder: (BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32))
          ),
          backgroundColor: Color(0xFFFF8330),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: screenHeight*0.01,),
                Text("Hubo un error al crear la receta",style: Textstyles.normalStyle(),),
                SizedBox(height: screenHeight*0.02,),
                
                InkWell(
                  onTap: (){
                    Navigator.of(context).pop(true);
                  },
                  child: Text("Continuar",style: Textstyles.normalStyle(),),
                ),
                SizedBox(height: screenHeight*0.02,),
              ],
            ),
          ),
        );
      }
    );
  }

  void recipeOK(BuildContext context,double screenWidth, double screenHeight) { 
    setState(() {
      Navigator.of(context).pop(true);
    });
    
    showDialog(
      context: context,
      barrierDismissible: true, // Permite cerrar el diálogo al tocar fuera
      barrierColor: Colors.black.withOpacity(0.5), // Oscurece el fondo
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Bordes redondeados
          ),
          backgroundColor: Color(0xFFFF8330), // Color de fondo del diálogo
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Receta creada exitosamente', style: Textstyles.normalStyle(),textAlign: TextAlign.center,),
                const SizedBox(height: 20),
                InkWell(
                  onTap: (){
                    setState(() {
                      Navigator.of(context).pop(true);
                    });
                  },
                  child: Container(
                    decoration: ContainerStyle.buttonContainerDec(),
                    padding: EdgeInsets.all(5),
                    child: Text("Continuar",style: Textstyles.normalStyle(),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void confirmDelete(BuildContext context,double screenWidth, double screenHeight,int index) {
    showDialog(
      context: context,
      barrierDismissible: true, // Permite cerrar el diálogo al tocar fuera
      barrierColor: Colors.black.withOpacity(0.5), // Oscurece el fondo
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Bordes redondeados
          ),
          backgroundColor: Color(0xFFFF8330), // Color de fondo del diálogo
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('¿Seguro que quieres borrar esta lista?', style: Textstyles.normalStyle(),textAlign: TextAlign.center,),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pop(true);
                      },
                      child: Container(
                        decoration: ContainerStyle.buttonContainerDec(),
                        padding: EdgeInsets.all(5),
                        child: Text("Cancelar",style: Textstyles.normalStyle(),),
                      ),
                    ),
                    InkWell(
                      onTap: ()async{
                        setState(() async{
                          // recipes.removeAt(index);
                          await deleteRecipe(index);
                          Navigator.of(context).pop(true);
                        });
                      },
                      child: Container(
                        decoration: ContainerStyle.buttonContainerDec(),
                        padding: EdgeInsets.all(5),
                        child: Text("Confirmar",style: Textstyles.normalStyle(),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InputDecoration inputBoxName() {
    return const InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: "Nombre",
      hintStyle: TextStyle(
        color: Colors.grey
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(32)),
        borderSide: BorderSide.none   
      )
    );
  }

}


class RecetaGS extends StatefulWidget{
  final int selected;

  RecetaGS(this.selected);
  // const RecetaGS({super.key,});

  @override
  State<StatefulWidget> createState() => _RecetaGS();
}

class _RecetaGS extends State<RecetaGS>{

  List<String>ingredients=[];
  List<String>tutorial=[];
  String title="Cargando...";

  int selected=0;

  bool loadedBand=false;

  void loadData(int index)async{
    var usuario = await UserService.getUsers("673516bd55397c8475000000");
    
    if(usuario == null){
      return;
    }

    title= usuario.listFavoriteRecipes[index].name;

    for(int i=0;i<usuario.listFavoriteRecipes[index].ingredients.length;i++){
      ingredients.add(usuario.listFavoriteRecipes[index].ingredients[i]);
    }
    
    for(int i=0;i<usuario.listFavoriteRecipes[index].steps.length;i++){
      tutorial.add(usuario.listFavoriteRecipes[index].steps[i]);
    }

    loadedBand=true;

    setState(() {
      
    });
  }

  Future<void> addIngredient(String newIng)async{
    var usuario = await UserService.getUsers("673516bd55397c8475000000");

    if(usuario == null){
      return;
    }

    await UserService.addOfIngredients_Steps("673516bd55397c8475000000", selected, "ingredients", newIng);
    ingredients.add(newIng);
    setState(() {
      
    });
  }

  Future<void> modifyIngredient(int index ,String newIng)async{
    var usuario = await UserService.getUsers("673516bd55397c8475000000");
    if(usuario == null){
      return;
    }

    await UserService.modifyElementOfFavoriteList("673516bd55397c8475000000", selected, "ingredients", newIng,index);
    ingredients[index]=newIng;
    setState(() {
      
    });
  }

  Future<void> deleteIngredient(int index)async{
    var usuario = await UserService.getUsers("673516bd55397c8475000000");
    if(usuario == null){
      return;
    }

    await UserService.deleteOfListIngredients_Steps("673516bd55397c8475000000", selected, "ingredients", ingredients[index]);
    ingredients.removeAt(index);
    setState(() {
      
    });
  }
  
  Future<void> addStep(String step)async{
    var usuario = await UserService.getUsers("673516bd55397c8475000000");
    if(usuario == null){
      return;
    }

    await UserService.addOfIngredients_Steps("673516bd55397c8475000000", selected, "steps", step);
    tutorial.add(step);
    setState(() {
      
    });
  }

  Future<void> modifyStep(int index ,String newStep)async{
    var usuario = await UserService.getUsers("673516bd55397c8475000000");
    if(usuario == null){
      return;
    }

    await UserService.modifyElementOfFavoriteList("673516bd55397c8475000000", selected, "steps", newStep,index);
    tutorial[index]=newStep;
    setState(() {
      
    });
  }

  Future<void> deleteStep(int index)async{
    var usuario = await UserService.getUsers("673516bd55397c8475000000");
    if(usuario == null){
      return;
    }

    await UserService.deleteOfListIngredients_Steps("673516bd55397c8475000000", selected, "steps", tutorial[index]);
    tutorial.removeAt(index);
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
    selected = widget.selected;

    if(!loadedBand){
      loadData(selected);
    }

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            BackgroundImage(),

            Container(
              decoration: ContainerStyle.topContainerDec(),
              height: screenHeight*0.1,
              width: screenWidth,
              alignment: Alignment.center,
              child: Text(title,style: Textstyles.recipesGtitleStyle(),),
            ),

            Container(
              decoration: ContainerStyle.genContainerDec(),
              height: screenHeight*0.9,
              width: screenWidth,
              margin: EdgeInsets.only(top: screenHeight*0.15),
              child: Container(
                margin: EdgeInsets.only(bottom: screenHeight*0.15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: screenHeight*0.03,),
                
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: screenWidth*0.04,),
                          child: Text("Ingredientes",style: Textstyles.recipesGtitleStyle(),),
                        ),
                      ],
                    ),
                    
                    ingredientsList(screenHeight,screenWidth),
                
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: screenWidth*0.04,
                          bottom: screenWidth*0.03),
                          child: Text("Procedimiento",style: Textstyles.recipesGtitleStyle(),),
                        ),
                      ],
                    ),
                
                    tutorialList(screenHeight,screenWidth),
                  ],
                ),
              ),
            ),

            cotizarButton(screenWidth, screenHeight),

            HotBar()
          ],
        ),
      )
    );
  }

  // ------------ Editar ---------------- //

  final TextEditingController ingNameControl = TextEditingController();
  final TextEditingController ingAmountControl = TextEditingController();
  
  final TextEditingController instController = TextEditingController();

  void limpiarIng() {
    setState(() {
      ingNameControl.clear();
      ingAmountControl.clear();
    });
  }

  void deleteIng(int index,double screenWidth, double screenHeight){
    setState(() {
      ingredients.removeAt(index);
    });
  }
  
  void deleteInst(int index,double screenWidth, double screenHeight){
    setState(() {
      tutorial.removeAt(index);
    });
  }
  
  void limpiarTut() {
    setState(() {
      instController.clear();
    });
  }
  

  // ----------------- Estilos --------------- //
  Padding editarIngredienteTitle(double screenHeight, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.1,
        right: screenWidth * 0.1,
      ),
      child: const Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Editar Ingrediente",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Poppins",
              fontSize: 26,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
  
  Padding editarProcTitle(double screenHeight, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.1,
        right: screenWidth * 0.1,
      ),
      child: const Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Editar instruccion",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Poppins",
              fontSize: 26,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Padding addProcTitle(double screenHeight, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.1,
        right: screenWidth * 0.1,
      ),
      child: const Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Agregar instruccion",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Poppins",
              fontSize: 26,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Padding addIngredienteTitle(double screenHeight, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.1,
        right: screenWidth * 0.1,
      ),
      child: const Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Agregar Ingrediente",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Poppins",
              fontSize: 26,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  InputDecoration inputBoxAmountIng() {
    return const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: "Cantidad",
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none));
  }

  InputDecoration inputBoxNameIng() {
    return const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: "Ingrediente",
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none));
  }
  
  InputDecoration inputBoxNameTut() {
    return const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: "Instruccion",
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none));
  }

  // ----------------- -------- --------------- //

  // ------- Ventanas emergentes ---------- //

  void confirmDeleteIng(BuildContext context,double screenWidth, double screenHeight,int index) {
    showDialog(
      context: context,
      barrierDismissible: true, // Permite cerrar el diálogo al tocar fuera
      barrierColor: Colors.black.withOpacity(0.5), // Oscurece el fondo
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Bordes redondeados
          ),
          backgroundColor: Color(0xFFFF8330), // Color de fondo del diálogo
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('¿Seguro que quieres borrar este ingrediente?', style: Textstyles.normalStyle(),textAlign: TextAlign.center,),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pop(true);
                      },
                      child: Container(
                        decoration: ContainerStyle.buttonContainerDec(),
                        padding: EdgeInsets.all(5),
                        child: Text("Cancelar",style: Textstyles.normalStyle(),),
                      ),
                    ),
                    InkWell(
                      onTap: ()async{
                        // deleteIng(index,screenWidth,screenHeight);
                        await deleteIngredient(index);
                        Navigator.of(context).pop(true);
                        deleteOk(context, screenWidth, screenHeight);
                      },
                      child: Container(
                        decoration: ContainerStyle.buttonContainerDec(),
                        padding: EdgeInsets.all(5),
                        child: Text("Confirmar",style: Textstyles.normalStyle(),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  void confirmDeleteIns(BuildContext context,double screenWidth, double screenHeight,int index) {
    showDialog(
      context: context,
      barrierDismissible: true, // Permite cerrar el diálogo al tocar fuera
      barrierColor: Colors.black.withOpacity(0.5), // Oscurece el fondo
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Bordes redondeados
          ),
          backgroundColor: Color(0xFFFF8330), // Color de fondo del diálogo
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('¿Seguro que quieres borrar esta instruccion?', style: Textstyles.normalStyle(),textAlign: TextAlign.center,),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pop(true);
                      },
                      child: Container(
                        decoration: ContainerStyle.buttonContainerDec(),
                        padding: EdgeInsets.all(5),
                        child: Text("Cancelar",style: Textstyles.normalStyle(),),
                      ),
                    ),
                    InkWell(
                      onTap: ()async{
                        // deleteInst(index,screenWidth,screenHeight);
                        await deleteStep(index);
                        Navigator.of(context).pop(true);
                        deleteOk(context, screenWidth, screenHeight);
                      },
                      child: Container(
                        decoration: ContainerStyle.buttonContainerDec(),
                        padding: EdgeInsets.all(5),
                        child: Text("Confirmar",style: Textstyles.normalStyle(),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  void deleteOk(BuildContext context,double screenWidth, double screenHeight) {
    showDialog(
      context: context,
      barrierDismissible: true, // Permite cerrar el diálogo al tocar fuera
      barrierColor: Colors.black.withOpacity(0.5), // Oscurece el fondo
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Bordes redondeados
          ),
          backgroundColor: Color(0xFFFF8330), // Color de fondo del diálogo
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Borrada exitosamente', style: Textstyles.normalStyle(),textAlign: TextAlign.center,),
                const SizedBox(height: 20),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pop(true);
                  },
                  child: Container(
                    decoration: ContainerStyle.buttonContainerDec(),
                    padding: EdgeInsets.all(5),
                    child: Text("Continuar",style: Textstyles.normalStyle(),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  void campoVacio(BuildContext context,double screenWidth, double screenHeight) {
    showDialog(
      context: context,
      barrierDismissible: true, // Permite cerrar el diálogo al tocar fuera
      barrierColor: Colors.black.withOpacity(0.5), // Oscurece el fondo
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Bordes redondeados
          ),
          backgroundColor: Color(0xFFFF8330), // Color de fondo del diálogo
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Favor de no dejar campos vacios en las instrucciones', style: Textstyles.normalStyle(),textAlign: TextAlign.center,),
                const SizedBox(height: 20),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pop(true);
                  },
                  child: Container(
                    decoration: ContainerStyle.buttonContainerDec(),
                    padding: EdgeInsets.all(5),
                    child: Text("Continuar",style: Textstyles.normalStyle(),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// ----------------------------------------- //

  Future<dynamic> ingEditSection(BuildContext context, double screenHeight,double screenWidth, int index) {
    ingNameControl.text = ingredients[index].substring(2);
    ingAmountControl.text = ingredients[index][0];

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite que el teclado suba el BottomSheet
      builder: (BuildContext context) {
        return FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // Ajuste del espacio con el teclado
            ),
            
            child: Container(
              alignment: Alignment.bottomLeft,
              height: screenHeight * 0.35,
              decoration: ContainerStyle.bottomContainerDec(),
              
              child: Column(
                mainAxisSize: MainAxisSize.min, // Permite que el contenido se ajuste al teclado
                children: [
                  editarIngredienteTitle(screenHeight, screenWidth),

                  Row(
                    children: [
                      SizedBox(height: screenHeight * 0.1),
                      Container(
                        width: screenWidth * 0.2,
                        margin: EdgeInsets.only(
                          left: screenWidth * 0.08,
                          right: screenWidth * 0.02,
                        ),
                        child: TextField(
                          controller: ingAmountControl,
                          decoration: inputBoxAmountIng(),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.6,
                        child: TextField(
                          controller: ingNameControl,
                          decoration: inputBoxNameIng(),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              limpiarIng();
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: ContainerStyle.buttonContainerDec(),
                            width: screenWidth*0.4,
                            child: Center(child: Text("Cancelar", style: Textstyles.buttonStyle())),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(()async {
                              String newKey = ingNameControl.text.toString();
                              String newAmo = ingAmountControl.text.toString();
                              String newIng = "$newAmo $newKey";
                              // ingredients[index] = newIng;
                              await modifyIngredient(index, newIng);
                              limpiarIng();
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: ContainerStyle.buttonContainerDec(),
                            width: screenWidth*0.4,
                            child: Center(child: Text("Continuar", style: Textstyles.buttonStyle())),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      limpiarIng();
                      Navigator.pop(context);
                      confirmDeleteIng(context, screenWidth, screenHeight,index);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                      width: screenWidth*0.4,
                      decoration: ContainerStyle.buttonContainerDec(),
                      child: Center(child: Text("Borrar", style: Textstyles.buttonStyle())),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> tutEditSection(BuildContext context, double screenHeight,double screenWidth, int index) {
    instController.text = tutorial[index];

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite que el teclado suba el BottomSheet
      builder: (BuildContext context) {
        return FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // Ajuste del espacio con el teclado
            ),
            
            child: Container(
              alignment: Alignment.bottomLeft,
              height: screenHeight * 0.35,
              decoration: ContainerStyle.bottomContainerDec(),
              
              child: Column(
                mainAxisSize: MainAxisSize.min, // Permite que el contenido se ajuste al teclado
                children: [
                  editarProcTitle(screenHeight, screenWidth),

                  Row(
                    children: [
                      SizedBox(height: screenHeight * 0.1),
                      Container(
                        width: screenWidth * 0.8,
                        margin: EdgeInsets.only(
                          left: screenWidth * 0.08,
                        ),
                        child: TextField(
                          controller: instController,
                          decoration: inputBoxNameTut(),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              limpiarTut();
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: ContainerStyle.buttonContainerDec(),
                            width: screenWidth*0.4,
                            child: Center(child: Text("Cancelar", style: Textstyles.buttonStyle())),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() async{
                              String newIng = instController.text.toString();
                              if(newIng == ''){
                                campoVacio(context, screenWidth, screenHeight);
                              }
                              else
                              {
                                // tutorial[index] = newIng;
                                await modifyStep(index, newIng);
                                limpiarTut();
                                Navigator.pop(context);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: ContainerStyle.buttonContainerDec(),
                            width: screenWidth*0.4,
                            child: Center(child: Text("Continuar", style: Textstyles.buttonStyle())),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      limpiarTut();
                      Navigator.pop(context);
                      confirmDeleteIns(context, screenWidth, screenHeight, index);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                      decoration: ContainerStyle.buttonContainerDec(),
                      width: screenWidth*0.4,
                      child: Center(child: Text("Borrar", style: Textstyles.buttonStyle())),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> tutAddSection(BuildContext context, double screenHeight,double screenWidth, int length) {
    limpiarTut();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite que el teclado suba el BottomSheet
      builder: (BuildContext context) {
        return FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // Ajuste del espacio con el teclado
            ),
            
            child: Container(
              alignment: Alignment.bottomLeft,
              height: screenHeight * 0.35,
              decoration: ContainerStyle.bottomContainerDec(),
              
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Permite que el contenido se ajuste al teclado
                  children: [
                    addProcTitle(screenHeight, screenWidth),
                
                    Row(
                      children: [
                        SizedBox(height: screenHeight * 0.1),
                        Container(
                          width: screenWidth * 0.8,
                          margin: EdgeInsets.only(
                            left: screenWidth * 0.08,
                          ),
                          child: TextField(
                            controller: instController,
                            decoration: inputBoxNameTut(),
                          ),
                        ),
                      ],
                    ),
                    
                    Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                limpiarTut();
                                Navigator.pop(context);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: ContainerStyle.buttonContainerDec(),
                              width: screenWidth*0.4,
                              child: Center(child: Text("Cancelar", style: Textstyles.buttonStyle())),
                            ),
                          ),
                          InkWell(
                            onTap: () async{
                              setState(()async {
                                String newIng = instController.text.toString();
                                if(newIng == ''){
                                  campoVacio(context, screenWidth, screenHeight);
                                }
                                else
                                {
                                  // tutorial.add(newIng);
                                  await addStep(newIng);
                                  limpiarTut();
                                  Navigator.pop(context);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: ContainerStyle.buttonContainerDec(),
                              width: screenWidth*0.4,
                              child: Center(child: Text("Continuar", style: Textstyles.buttonStyle())),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> ingAddSection(BuildContext context, double screenHeight,double screenWidth, int length) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite que el teclado suba el BottomSheet
      builder: (BuildContext context) {
        return FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // Ajuste del espacio con el teclado
            ),
            
            child: Container(
              alignment: Alignment.bottomLeft,
              height: screenHeight * 0.35,
              decoration: ContainerStyle.bottomContainerDec(),
              
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Permite que el contenido se ajuste al teclado
                  children: [
                    addIngredienteTitle(screenHeight, screenWidth),
                
                    Row(
                    children: [
                      SizedBox(height: screenHeight * 0.1),
                      Container(
                        width: screenWidth * 0.2,
                        margin: EdgeInsets.only(
                          left: screenWidth * 0.08,
                          right: screenWidth * 0.02,
                        ),
                        child: TextField(
                          controller: ingAmountControl,
                          decoration: inputBoxAmountIng(),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.6,
                        child: TextField(
                          controller: ingNameControl,
                          decoration: inputBoxNameIng(),
                        ),
                      ),
                    ],
                    ),
                    
                    Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                limpiarIng();
                                Navigator.pop(context);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: ContainerStyle.buttonContainerDec(),
                              width: screenWidth*0.4,
                              child: Center(child: Text("Cancelar", style: Textstyles.buttonStyle())),
                            ),
                          ),
                          InkWell(
                            onTap: () async{
                              setState(() async{
                                String newIng = ingAmountControl.text.toString() + " "+ ingNameControl.text.toString();
                                if(ingNameControl.text.toString() == "" || ingAmountControl.text.toString() == "" ){
                                  campoVacio(context, screenWidth, screenHeight);
                                }
                                else
                                {
                                  // ingredients.add(newIng);
                                  await addIngredient(newIng);
                                  limpiarIng();
                                  Navigator.pop(context);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: ContainerStyle.buttonContainerDec(),
                              width: screenWidth*0.4,
                              child: Center(child: Text("Continuar", style: Textstyles.buttonStyle())),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Expanded ingredientsList(double screenHeight,double screenWidth) {
    return Expanded(
                  child: ListView.builder(
                    itemCount: ingredients.length+1,
                    itemBuilder: (context,index){
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if(index <= ingredients.length-1)...[
                              Text("• ${ingredients[index]}",style: Textstyles.normalStyle(),),
                              InkWell(
                                onTap: (){
                                  ingEditSection(context, screenHeight, screenWidth, index);
                                },
                                child: Container(
                                  decoration: ContainerStyle.buttonContainerDec(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8
                                  ),
                                  child: Image.asset("assets/icons/edit2.png",width: screenHeight*0.02,),
                                )
                              ),
                            ],
                            if(index == ingredients.length)...[
                              InkWell(
                                onTap: (){
                                  int length = ingredients.length;
                                  limpiarIng();
                                  ingAddSection(context, screenHeight, screenWidth, length);
                                },
                                child: Text("+ Agregar",style: Textstyles.addStyle(),)
                              )
                            ]
                            
                          ],
                        ),
                      );
                    }
                  ),
                );
  }

  Expanded tutorialList(double screenHeight,double screenWidth) {
    return Expanded(
                  child: ListView.builder(
                    itemCount: tutorial.length+1,
                    itemBuilder: (context,index){
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if(index <= tutorial.length-1)...[
                              Expanded(child: Text("${index+1} ${tutorial[index]}",style: Textstyles.normalStyle(),)),
                              InkWell(
                                onTap: (){
                                  tutEditSection(context, screenHeight, screenWidth, index);
                                },
                                child: Container(
                                  decoration: ContainerStyle.buttonContainerDec(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8
                                  ),
                                  child: Image.asset("assets/icons/edit2.png",width: screenHeight*0.02,),
                                )
                              ),
                            ],
                            if(index == tutorial.length)...[
                              InkWell(
                                onTap: () {
                                  int length = tutorial.length;
                                  tutAddSection(context, screenHeight, screenWidth, length);
                                },
                                child: Text("+ Agregar",style: Textstyles.addStyle(),)
                              ),
                            ],
                            
                          ],
                        ),
                      );
                    }
                  ),
                );
  }

  Align cotizarButton(double screenWidth, double screenHeight) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
          onTap: () {},
          child: InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Mercados(ingredients: ingredients,)));
            },
              child: Container(
                decoration: ContainerStyle.buttonContainerDec(),
                margin: EdgeInsets.only(bottom: screenHeight*0.07),
                width: screenWidth*0.5,
                height: screenHeight*0.05,
                alignment: Alignment.center,
                child: Text("Cotizar",style: Textstyles.normalStyle(),),
              ),
            ),
          )
        );
  }

}
