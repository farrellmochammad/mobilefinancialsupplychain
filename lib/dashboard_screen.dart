
import 'package:flutter/material.dart';
import 'farmer_input.dart';
import 'approverlist_screen.dart';
import 'monitoring_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = const FlutterSecureStorage();


void main() {
  runApp(const DashboardScreen());
}

  class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';

  const DashboardScreen({Key? key}) : super(key: key);

  DefaultTabController _buildSalesPage(){
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

  DefaultTabController _buildApproverPage(){
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person_pin)),
              Tab(icon: Icon(Icons.check))
            ],
          ),
          title: Text('Tabs Demo'),
        ),
        body: TabBarView(
          children: [
            FarmerInput(),
            ApproverList()
          ],
        ),
      ),
    );
  }

  DefaultTabController _buildFunderPage(){
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person_pin)),
            ],
          ),
          title: Text('Tabs Demo'),
        ),
        body: TabBarView(
          children: [
            FarmerInput(),
          ],
        ),
      ),
    );
  }

  Future<String> getPermission() async {
    var permission =  await storage.read(key: 'permission');
    debugPrint("Permission ## : " + permission.toString());
    return permission.toString();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getPermission(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          debugPrint("Permission : " + snapshot.data.toString());
          if (snapshot.data.toString() == "sales") {
            return _buildSalesPage();
          }

          if (snapshot.data.toString()  == "approver") {
            return _buildApproverPage();
          }

          if (snapshot.data.toString()  == "funder") {
            return _buildFunderPage();
          }

          return _buildSalesPage();
        }
    );
  }
}