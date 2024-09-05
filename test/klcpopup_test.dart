import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:klcpopup/klcpopup.dart';

void main() {
  testWidgets(
    "test klcpopup show and dismiss",
    (tester) async {
      final KLCPopupController controller = KLCPopupController();
      late final BuildContext appContext;
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            appContext = context;
            return const Placeholder();
          },
        ),
      ));
      showKLCPopup(
        appContext,
        child: const Text("Hello World"),
        controller: controller,
      );
      await tester.pumpAndSettle();
      expect(find.text("Hello World"), findsOneWidget);
      controller.dismiss();
      await tester.pumpAndSettle();
      expect(find.text("Hello World"), findsNothing);
    },
  );

  testWidgets(
    "test layout",
    (tester) async {
      late final BuildContext appContext;
      late final Size screenSize;
      const Size popupSize = Size(50, 50);
      const Key popupKey = ValueKey("popup");
      final KLCPopupController controller = KLCPopupController();

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              appContext = context;
              screenSize = MediaQuery.of(context).size;
              return const Placeholder();
            },
          ),
        ),
      );
      Map<KLCPopupVerticalLayout, double> verticalLayoutMap = {
        KLCPopupVerticalLayout.custom: 0,
        KLCPopupVerticalLayout.top: 0,
        KLCPopupVerticalLayout.topOfCenter: (screenSize.height - popupSize.height) / 4,
        KLCPopupVerticalLayout.center: (screenSize.height - popupSize.height) / 2,
        KLCPopupVerticalLayout.bottom: screenSize.height - popupSize.height,
        KLCPopupVerticalLayout.bottomOfCenter: screenSize.height - (screenSize.height - popupSize.height) / 4 - popupSize.height,
      };
      Map<KLCPopupHorizontalLayout, double> horizontalLayoutMap = {
        KLCPopupHorizontalLayout.custom: 0,
        KLCPopupHorizontalLayout.left: 0,
        KLCPopupHorizontalLayout.leftOfCenter: (screenSize.width - popupSize.width) / 4,
        KLCPopupHorizontalLayout.center: (screenSize.width - popupSize.width) / 2,
        KLCPopupHorizontalLayout.rightOfCenter: screenSize.width - (screenSize.width - popupSize.width) / 4 - popupSize.width,
        KLCPopupHorizontalLayout.right: screenSize.width - popupSize.width,
      };
      for (var vertical in KLCPopupVerticalLayout.values) {
        double dy = verticalLayoutMap[vertical]!;
        for (var horizontal in KLCPopupHorizontalLayout.values) {
          double dx = horizontalLayoutMap[horizontal]!;
          showKLCPopup(
            appContext,
            child: SizedBox(
              key: popupKey,
              width: popupSize.width,
              height: popupSize.height,
            ),
            verticalLayout: vertical,
            horizontalLayout: horizontal,
            controller: controller,
          );
          await tester.pumpAndSettle();
          final RenderBox popupRenderBox = tester.renderObject(find.byKey(popupKey));
          final Offset popupOffset = popupRenderBox.localToGlobal(Offset.zero);
          expect(popupOffset, Offset(dx, dy));
          controller.dismiss();
          await tester.pumpAndSettle();
        }
      }
    },
  );
}
