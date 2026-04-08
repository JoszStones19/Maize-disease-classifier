import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/router.dart';
import 'constants/theme.dart';
import 'providers/history_provider.dart';
import 'providers/scan_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final historyProvider = HistoryProvider();
  await historyProvider.init();

  runApp(MaizeDoctorApp(historyProvider: historyProvider));
}

class MaizeDoctorApp extends StatelessWidget {
  const MaizeDoctorApp({super.key, required this.historyProvider});

  final HistoryProvider historyProvider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HistoryProvider>.value(value: historyProvider),
        ChangeNotifierProvider(create: (_) => ScanProvider()),
      ],
      child: MaterialApp.router(
        title: 'Maize Doctor',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        routerConfig: appRouter,
      ),
    );
  }
}
