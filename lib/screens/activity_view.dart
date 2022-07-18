import 'package:flutter/material.dart';
import 'package:pra_frente_app/db/activity_db_helper.dart';
import 'package:pra_frente_app/models/activity.dart';
import 'package:pra_frente_app/screens/activity_form.dart';

class ActivityView extends StatefulWidget {
  const ActivityView({Key? key}) : super(key: key);

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activities"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: ActivityDbHelper.instance.getActivities(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                case ConnectionState.done:
                  List<Activity> activities = snapshot.data as List<Activity>;
                  return Expanded(
                    child: ListView.builder(
                        itemCount: activities.length,
                        itemBuilder: (context, index) {
                          final Activity activity = activities[index];
                          return Card(
                            child: ListTile(
                              title: Text(activity.name),
                              onLongPress: () async {
                                // await ActivityDbHelper.instance.delete(activity.id!);
                                // setState(() {});
                              },
                              onTap: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => DateView(activity)));
                              },
                            ),
                          );
                        }),
                  );
                default:
                  return const Center(
                    child: Text("Unknown error"),
                  );
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ActivityForm(),
          ));
          setState(() {});
        },
      ),
    );
  }
}
