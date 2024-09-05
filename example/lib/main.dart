import 'package:flutter/material.dart';
import 'package:klcpopup/klcpopup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KLCPopup Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  KLCPopupHorizontalLayout horizontalLayout = KLCPopupHorizontalLayout.center;
  KLCPopupVerticalLayout verticalLayout = KLCPopupVerticalLayout.center;
  KLCPopupMaskType maskType = KLCPopupMaskType.dimmed;
  KLCPopupShowType showType = KLCPopupShowType.slideInFromTop;
  KLCPopupDismissType dismissType = KLCPopupDismissType.slideOutToTop;
  bool shouldDismissOnBackgroundTouch = true;
  bool shouldDismissOnContentTouch = false;
  bool dismissAfterDelay = false;
  bool useRoute = false;

  late final KLCPopupController popupController = KLCPopupController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('KLCPopup Example'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Horizontal layout'),
            trailing: Text(horizontalLayout.name),
            onTap: () async {
              _showPropertyPicker<KLCPopupHorizontalLayout>(
                title: 'Horizontal Layout',
                initialSelection: horizontalLayout,
                items: KLCPopupHorizontalLayout.values,
                itemBuilder: (item) => Text(item.name),
                onSelected: (item) {
                  setState(() => horizontalLayout = item);
                  popupController.dismiss();
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Vertical layout'),
            trailing: Text(verticalLayout.name),
            onTap: () async {
              _showPropertyPicker<KLCPopupVerticalLayout>(
                title: 'Vertical layout',
                initialSelection: verticalLayout,
                items: KLCPopupVerticalLayout.values,
                itemBuilder: (item) => Text(item.name),
                onSelected: (item) {
                  setState(() => verticalLayout = item);
                  popupController.dismiss();
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Background mask'),
            trailing: Text(maskType.name),
            onTap: () async {
              _showPropertyPicker<KLCPopupMaskType>(
                title: 'Background mask',
                initialSelection: maskType,
                items: KLCPopupMaskType.values,
                itemBuilder: (item) => Text(item.name),
                onSelected: (item) {
                  setState(() => maskType = item);
                  popupController.dismiss();
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Show type'),
            trailing: Text(showType.name),
            onTap: () async {
              _showPropertyPicker<KLCPopupShowType>(
                title: 'Show type',
                initialSelection: showType,
                items: KLCPopupShowType.values,
                itemBuilder: (item) => Text(item.name),
                onSelected: (item) {
                  setState(() => showType = item);
                  popupController.dismiss();
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Dismiss type'),
            trailing: Text(dismissType.name),
            onTap: () async {
              _showPropertyPicker<KLCPopupDismissType>(
                title: 'Dismiss type',
                initialSelection: dismissType,
                items: KLCPopupDismissType.values,
                itemBuilder: (item) => Text(item.name),
                onSelected: (item) {
                  setState(() => dismissType = item);
                  popupController.dismiss();
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Dismiss on background touch'),
            trailing: Switch.adaptive(value: shouldDismissOnBackgroundTouch, onChanged: (value) => setState(() => shouldDismissOnBackgroundTouch = value)),
          ),
          const Divider(),
          ListTile(
            title: const Text('Dismiss on content touch'),
            trailing: Switch.adaptive(value: shouldDismissOnContentTouch, onChanged: (value) => setState(() => shouldDismissOnContentTouch = value)),
          ),
          const Divider(),
          ListTile(
            title: const Text('Dismiss after delay'),
            trailing: Switch.adaptive(value: dismissAfterDelay, onChanged: (value) => setState(() => dismissAfterDelay = value)),
          ),
          const Divider(),
          ListTile(
            title: const Text('Use route'),
            trailing: Switch.adaptive(value: useRoute, onChanged: (value) => setState(() => useRoute = value)),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
final popupController = KLCPopupController();
showKLCPopup(
  context,
  controller: popupController,
  horizontalLayout: KLCPopupHorizontalLayout.center,
  verticalLayout: KLCPopupVerticalLayout.bottom,
  showType: KLCPopupShowType.slideInFromBottom,
  dismissType: KLCPopupDismissType.slideOutToBottom,
  child: Material(
    color: Colors.transparent,
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SafeArea(child: Container()),
          const Text(
            "Hi.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              popupController.dismiss();
            },
            child: const Text("Bye"),
          )
        ],
      ),
    ),
  ),
);
                // showKLCPopup(
                //   context,
                //   controller: popupController,
                //   showType: showType,
                //   dismissType: dismissType,
                //   maskType: maskType,
                //   horizontalLayout: horizontalLayout,
                //   verticalLayout: verticalLayout,
                //   shouldDismissOnContentTouch: shouldDismissOnContentTouch,
                //   shouldDismissOnBackgroundTouch: shouldDismissOnBackgroundTouch,
                //   duration: dismissAfterDelay ? const Duration(seconds: 2) : null,
                //   useRoute: useRoute,
                //   child: Material(
                //     color: Colors.transparent,
                //     child: switch ((horizontalLayout, verticalLayout)) {
                //       (KLCPopupHorizontalLayout.left, _) => _buildLeftContent(context),
                //       (_, KLCPopupVerticalLayout.bottom) => _buildBottomContent(context),
                //       _ => _buildCenterContent(context),
                //     },
                //   ),
                // );
              },
              child: const Text('Show it!'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomContent(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Hi.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              popupController.dismiss();
            },
            child: const Text("Bye"),
          )
        ],
      ),
    );
  }

  Widget _buildLeftContent(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SafeArea(child: Container()),
          const Text(
            "Hi.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              popupController.dismiss();
            },
            child: const Text("Bye"),
          )
        ],
      ),
    );
  }

  Widget _buildCenterContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Hi.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              popupController.dismiss();
            },
            child: const Text("Bye"),
          )
        ],
      ),
    );
  }

  void _showPropertyPicker<T>({
    required String title,
    required T initialSelection,
    required List<T> items,
    required Widget Function(T item) itemBuilder,
    required void Function(T item) onSelected,
  }) {
    showKLCPopup(
      context,
      controller: popupController,
      child: _PropertyPickPage<T>(
        title: title,
        initialSelection: initialSelection,
        items: items,
        itemBuilder: itemBuilder,
        onSelected: onSelected,
        didClickCancel: () => popupController.dismiss(),
      ),
    );
  }
}

class _PropertyPickPage<T> extends StatefulWidget {
  const _PropertyPickPage({
    required this.title,
    required this.initialSelection,
    required this.items,
    required this.itemBuilder,
    this.onSelected,
    this.didClickCancel,
    super.key,
  });
  final String title;
  final T? initialSelection;
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final void Function(T item)? onSelected;
  final void Function()? didClickCancel;

  @override
  State<_PropertyPickPage<T>> createState() => _PropertyPickPageState<T>();
}

class _PropertyPickPageState<T> extends State<_PropertyPickPage<T>> {
  T? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 420,
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).dialogBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      widget.didClickCancel?.call();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: widget.items.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: widget.itemBuilder(widget.items[index]),
                    onTap: () {
                      setState(
                        () {
                          selected = widget.items[index];
                        },
                      );
                      widget.onSelected?.call(widget.items[index]);
                    },
                    trailing: selected == widget.items[index] ? const Icon(Icons.check) : null,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
