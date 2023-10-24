import 'package:flutter/material.dart';
import 'package:todoapp/plan_provider.dart';
import 'package:todoapp/views/plan_screen.dart';
import 'package:todoapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/data_layer.dart';

class PlanCreatorScreen extends StatefulWidget {
  State createState() => _CreatePlanState();
}

class _CreatePlanState extends State<PlanCreatorScreen> {
  final textController = TextEditingController();

  void dispose() {
    textController.dispose();
    super.dispose();
  }

  late SharedPreferences loginData;
  late String username;


  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      username = loginData.getString('username')!;
    });
  }

  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome $username')),
      body: Column(children: <Widget>[
        _buildListCreator(),
        Expanded(child: _buildMasterPlans()),
        ElevatedButton(
          onPressed: (){
            loginData.setBool(("login"), true);
            Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => MyHomePage()));
          },
          child: Text("LogOut"),
        ),
      ]),
    );
  }

  Widget _buildListCreator() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Material(
        color: Theme.of(context).cardColor,
        elevation: 10,
        child: TextField(
          controller: textController,
          decoration: InputDecoration(
            labelText: 'Add a plan',
            contentPadding: EdgeInsets.all(20.0)
          ),
          onEditingComplete: addPlan,
        ),
      ),
    );
  }

  void addPlan() {
    final text = textController.text;
    if (text.isEmpty) {
      return;
    }

    final plan = Plan()..name = text;
    PlanProvider.of(context)!.add(plan);
    textController.clear();
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {});
  }

  Widget _buildMasterPlans() {
    final plans = PlanProvider.of(context);

    if (plans!.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.note, size: 100, color: Colors.grey),
          Text('You do not have any plans yet', style: Theme.of(context).textTheme.headlineSmall),
        ]);
    }

    return ListView.builder(
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return ListTile(
            title: Text(plan.name),
            subtitle: Text(plan.completenessMessage),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => PlanScreen(plan: plan)));
            });
        });
  }
}