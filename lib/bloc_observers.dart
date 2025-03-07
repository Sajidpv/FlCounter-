import 'package:flutter_bloc/flutter_bloc.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    print("Created : $bloc");
    super.onCreate(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    print('Change in $bloc: $change');
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('Transition in $bloc: $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onClose(BlocBase bloc) {
    print('Closed: $bloc');
    super.onClose(bloc);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('Error in $bloc:Error is $error : On $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}
