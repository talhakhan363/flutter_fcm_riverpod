/*  Houses the StateNotifier and StateNotifierProvider. This is the Riverpod 
    equivalent of the Week 6 provider task, offering immutable state updates and better 
    compile-time safety. 
    DIFFERENCE: Riverpod enforces immutability. Instead of modifying an existing list and yelling 
    notifyListeners() like we did in the standard Provider, Riverpod requires us to create 
    a brand new list every time a state changes. It is safer, faster, and highly preferred 
    in enterprise software. */
