
import 'package:desk/router.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:desk/app_state.dart';

class AppWrapper extends StatefulWidget {
  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  Future<bool> didPopRoute() async {
    if (AppState().rootNavigator.currentState!.canPop()) {
      AppState().rootNavigator.currentState!.pop();
    } else {
      final result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit the App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  Navigator.of(context).pop(false);
                },
                child: Text('Yes'),
              ),
            ],
          );
        },
      );

      return result;
    }
    return true;
  }


  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      key: AppState().globalScaffold,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Navigator(
            onGenerateRoute: AppRouter.generateRoute,
            key: AppState().rootNavigator,
          ),
          // OverlayLoading(),
        ],
      ),
      // bottomNavigationBar: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     PlayerUi(),
      //     BottomNavigation(),
      //   ],
      // ),
    );
  }
}
