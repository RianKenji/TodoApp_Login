import 'package:flutter/material.dart';
import 'package:todoapp/models/data_layer.dart';
import '../plan_provider.dart';

class PlanScreen extends StatefulWidget {
  final Plan plan;
  const PlanScreen({Key? key, required this.plan}) : super (key: key);

  State createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late ScrollController scrollController;
  Plan get plan => widget.plan;

  void initState(){
    super.initState();
    scrollController = ScrollController()..addListener(() {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  Widget build (BuildContext context) {
  //  final plan = PlanProvider.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Master Plan')),
      body: Column(children: <Widget>[
        Expanded(child: _buildList()),
        SafeArea(child: Text(plan!.completenessMessage))
      ]),
      floatingActionButton: _buildAddTaskButton(),
    );
  }

  Widget _buildAddTaskButton() {
 //   final plan = PlanProvider.of(context);
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        setState(() {
          plan!.tasks.add(Task());
        });
      }
    );
  }

  Widget _buildList() {
 //   final plan = PlanProvider.of(context);
    return ListView.builder(
        controller: scrollController,
        itemCount: plan!.tasks.length,
        itemBuilder: (context, index) => _buildTaskTile(plan.tasks[index]),
    );
  }

  Widget _buildTaskTile(Task task) {
    return ListTile(
      leading: Checkbox(
        value: task.complete,
        onChanged: (selected) {
          setState(() {
            task.complete = selected!;
          });
        }),
      title: TextFormField(
        initialValue: task.description,
        onFieldSubmitted: (text) {
          setState(() {
            task.description = text;
          });
        },
      ),
    );
  }
}







