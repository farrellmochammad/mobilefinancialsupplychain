
import 'package:flutter/material.dart';
import 'package:supplychainmobile/approverlist_funder_screen.dart';
import 'package:supplychainmobile/funding_funder_screen.dart';
import 'farmer_input.dart';
import 'approverlist_screen.dart';
import 'approverlist_analysis_screen.dart';
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
          title: Text('Sales Page'),
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

  DefaultTabController _buildAnalystPage(){
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person_pin)),
            ],
          ),
          title: Text('Analysis Page'),
        ),
        body: TabBarView(
          children: [
            ApproverListAnalysis(),
          ],
        ),
      ),
    );
  }

  DefaultTabController _buildFunderPage(){
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person_pin)),
              Tab(icon: Icon(Icons.person_pin)),
            ],
          ),
          title: Text('Funder Page'),
        ),
        body: TabBarView(
          children: [
            ApproverListFunder(),
            FundingList()
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
          if (snapshot.data.toString() == "sales") {
            return _buildSalesPage();
          }

          if (snapshot.data.toString()  == "analyst") {
            return _buildAnalystPage();
          }

          if (snapshot.data.toString()  == "funder") {
            return _buildFunderPage();
          }

          return _buildSalesPage();
        }
    );
  }
}