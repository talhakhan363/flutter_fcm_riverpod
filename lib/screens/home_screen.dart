/*  A ConsumerWidget that listens to the Riverpod state and renders 
    the high-contrast dark mode UI, swipe-to-delete animations, and the task list. 
    NOTE:
    When moving from standard Provider to Riverpod, the UI layer requires a few specific 
    but powerful syntax changes:
    1) We change StatelessWidget to a ConsumerWidget.
    2) The build method now takes a second parameter called WidgetRef ref. This ref is your 
       UI's direct line of communication to the Riverpod providers.
    3) Instead of context.watch(), we use ref.watch() to listen to data.
    4) Instead of context.read(), we use ref.read(taskProvider.notifier) to trigger functions. */
