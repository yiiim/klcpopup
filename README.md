# KLCPopup

KLCPopup is a flexible and easy-to-use popup window, Inspired by the iOS native popup package [KLCPopup](https://github.com/jmascia/KLCPopup).

## Usage

This package implements all the features of [KLCPopup](https://github.com/jmascia/KLCPopup) and the API is almost identical.

> This popup can use the `useRoute` parameter to control whether to use route-based popup.

### case 1

<img src="https://raw.githubusercontent.com/yiiim/klcpopup/master/preview1.gif" alt="示例动画" height="500">

```dart
final popupController = KLCPopupController();
showKLCPopup(
  context,
  controller: popupController,
  child: Material(
    color: Colors.transparent,
    child: Container(
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
    ),
  ),
);
```

### case 2

<img src="https://raw.githubusercontent.com/yiiim/klcpopup/master/preview2.gif" alt="示例动画" height="500">

```dart
final popupController = KLCPopupController();
showKLCPopup(
  context,
  controller: popupController,
  horizontalLayout: KLCPopupHorizontalLayout.left,
  verticalLayout: KLCPopupVerticalLayout.center,
  showType: KLCPopupShowType.slideInFromLeft,
  dismissType: KLCPopupDismissType.slideOutToLeft,
  child: Material(
    color: Colors.transparent,
    child: Container(
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
    ),
  ),
);
```

### case 3

<img src="https://raw.githubusercontent.com/yiiim/klcpopup/master/preview3.gif" alt="示例动画" height="500">

```dart
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
```

## Other

> Because this package uses an API almost identical to KLCPopup, I have named it the same. If the author of KLCPopup prefers otherwise, please feel free to contact me for a name change.
