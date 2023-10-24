import 'package:flutter/material.dart';
import 'package:todoapp/plan_provider.dart';
import 'package:todoapp/views/plan_creator_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return PlanProvider(
    child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    ));
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final username_controller = TextEditingController();
  final password_controller = TextEditingController();

  late SharedPreferences loginData;
  late bool newuser;

  @override
  void initState(){
    super.initState();
    check_login();
  }

  void check_login() async {
    loginData = await SharedPreferences.getInstance();
    newuser = (loginData.getBool('login') ?? true);

    print(newuser);
    if(newuser == false){
      Navigator.pushReplacement
        (context, new MaterialPageRoute(builder: (context) => PlanCreatorScreen()));
    }
  }

  @override
  void dispose(){
    username_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shared Preferences"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Login Form",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(
              "Contoh Penggunaan Shared Preferences",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: username_controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "username",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: password_controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "password",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: (){
                String username = username_controller.text;
                String password = password_controller.text;
                if(username != '' && password != ''){
                  loginData.setBool('login', false);
                  loginData.setString('username', username);

                  Navigator.push(context, MaterialPageRoute(builder: (context) => PlanCreatorScreen()));
                }
              },
              child: Text("Log-In"),
            ),
          ],
        ),
      ),
    );
  }
}
