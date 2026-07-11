import 'package:artriapp/database/index.dart';
import 'package:artriapp/services/index.dart';
import 'package:artriapp/view_models/index.dart';
import 'package:artriapp/view_models/remedy_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:artriapp/view_models/diary_view_model.dart';

class GlobalProviders {
  final AppDatabase _database;

  GlobalProviders(this._database);

  List<SingleChildWidget> get _serviceProviders => <SingleChildWidget>[
        Provider(create: (context) => AuthService()),
        Provider(create: (context) => SecurityTokenService()),
        Provider(create: (context) => PhysicalExercisesService()),
        Provider(create: (context) => CustomExercisesService()),
        Provider(create: (context) => SavedPlansService(_database)),
      ];

  List<SingleChildWidget> get _viewModelProviders => <SingleChildWidget>[
        ChangeNotifierProvider(
          create: (context) => LoginViewModel(
            Provider.of<AuthService>(context, listen: false),
            Provider.of<SecurityTokenService>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => PhysicalExercisesViewModel(
            Provider.of<PhysicalExercisesService>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CustomExercisesViewModel(
            Provider.of<CustomExercisesService>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SavedPlansViewModel(
            Provider.of<SavedPlansService>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RemedyViewModel(),
        ),
        ChangeNotifierProvider(create: (_) => DiaryViewModel()),
      ];

  static List<SingleChildWidget> getProviders(AppDatabase database) {
    final instance = GlobalProviders(database);
    return instance._serviceProviders
        .followedBy(instance._viewModelProviders)
        .toList();
  }
}
