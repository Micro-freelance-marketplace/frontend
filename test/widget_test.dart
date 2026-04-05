import 'package:flutter_test/flutter_test.dart';

import 'package:micro_freelance_marketplace/main.dart';

void main() {
  testWidgets('Shows login screen on startup', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusFreelanceMarketplaceApp());

    expect(find.text('Campus Freelance Marketplace'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
