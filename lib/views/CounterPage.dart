import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});


  // In essence, Block provider allows you to create Cubit that will hold the state of object you give it.
  // The subtree will be able to access it with BlocBuilder (we use this so that we only build the widget that is related to the changed state.)
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: BlocProvider(
        // Nested BlocProvider will work, no problem. But ugly, need to find a way to deal with this.
        create: (_) => NiceObjectCubit(),
        child: const ViewCounter(),
      ),
    );
  }
}


class ViewCounter extends StatelessWidget {
  const ViewCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Our cubit and its state type
    // We have it nested here to test it out, and it works fine.
    return BlocBuilder<CounterCubit, int>(
      builder: (context, counterState) {
        return BlocBuilder<NiceObjectCubit, NiceObject>(
          builder: (context, niceObjectState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('$counterState'),
                ElevatedButton(
                  // When we have a builder up there in the tree, we can access the state using `context.read<CustomCubit>().functions_you_want()
                  onPressed: () => context.read<CounterCubit>().increment(),
                  child: const Icon(Icons.add),
                ),
                ElevatedButton(
                  onPressed: () => context.read<CounterCubit>().decrement(),
                  child: const Icon(Icons.wallet),
                ),
                Text(niceObjectState.sentence),
                ElevatedButton(
                  onPressed: () => context.read<NiceObjectCubit>().update("up"),
                  child: const Icon(Icons.add),
                ),
                ElevatedButton(
                  onPressed: () => context.read<NiceObjectCubit>().append(" bottom"),
                  onLongPress: (){context.read<NiceObjectCubit>().append("long press");},
                  child: const Icon(Icons.wallet),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// Here's the object
class NiceObject extends Object{
  String sentence;

  NiceObject(this.sentence);

}
/// Here's the cubit.
/// The concept here is that `emit()` will take its parameter and set it as the future state.
/// Current state is accesible within the emit as `state`
class NiceObjectCubit extends Cubit<NiceObject> {
  NiceObjectCubit() : super(NiceObject("Initial State"));

  void update(String string) {
    emit(NiceObject(string));
  }

  void append(String string){
    emit(NiceObject('${state.sentence}$string'));
  }
}
// Another cubit from the tutorial
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 2);
  void decrement() => emit(state - 1);
}
