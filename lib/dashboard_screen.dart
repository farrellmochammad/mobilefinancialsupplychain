
import 'package:flutter/material.dart';
import 'farmer_input.dart';
import 'approverlist_screen.dart';
import 'monitoring_screen.dart';


void main() {
  runApp(const DashboardScreen());
}

  class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person_pin)),
              Tab(icon: Icon(Icons.check)),
              Tab(icon: Icon(Icons.directions_car)),
            ],
          ),
          title: Text('Tabs Demo'),
        ),
        body: TabBarView(
          children: [
            FarmerInput(),
            ApproverList(),
            MonitoringScreen(),
          ],
        ),
      ),
    );
  }
}