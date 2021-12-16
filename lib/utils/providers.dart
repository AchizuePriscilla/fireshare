import 'package:fireshare/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  static final providers = <SingleChildWidget>[
    ChangeNotifierProvider(
      create: (context) => UserViewodel(),
    ),
  ];
}
