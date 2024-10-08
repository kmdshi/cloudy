import 'package:cloudy/core/gen/assets.gen.dart';
import 'package:cloudy/core/presentation/keep_alive_widget.dart';
import 'package:cloudy/features/user_data/presentation/widgets/custom_icon_button_widget.dart';
import 'package:cloudy/features/user_data/presentation/widgets/custom_tabbar_widget.dart';
import 'package:cloudy/features/user_data/presentation/widgets/user_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GeneralScreen extends StatefulWidget {
  const GeneralScreen({super.key});

  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> {
  // late final AppLinks _appLinks;
  // late final StreamSubscription<Uri?> _sub;

  // @override
  // void initState() {
  //   super.initState();
  //   _appLinks = getIt<AppLinks>();
  //   handleLink();
  // }

  // @override
  // void dispose() {
  //   _sub.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 20.0,
          title: const Text(
            'Cloudy',
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(75),
            child: CustomTabbarWidget(),
          ),
          actions: [
            CustomIconButtonWidget(
              iconPath: Assets.icons.searchIcon.path,
              onTap: () {},
            ),
            const SizedBox(width: 5),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: CustomIconButtonWidget(
                iconPath: Assets.icons.settingIcon.path,
                onTap: () => context.push('/messages/settings'),
                // onTap: () => Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => TempScreen())),
              ),
            ),
          ],
        ),
        body: const SizedBox(
          width: double.maxFinite,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 35),
            child: TabBarView(
              children: [
                // Center(
                //   child: Text('1'),
                // ),
                KeepAliveWrapper(child: MessagesScreen()),
                Center(
                  child: Text('Not ready yet...'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void handleLink() {
  //   _sub = _appLinks.uriLinkStream.listen((uri) {
  //     print(uri);
  //   }, onError: (err) {
  //     print('Ошибка при обработке диплинка: $err');
  //   });
  // }
}
