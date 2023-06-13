
import "package:firebase_analytics/firebase_analytics.dart";

Future<void> setCurrentScreen(FirebaseAnalytics analytics,String screenName) async {
  await analytics.setCurrentScreen(
    screenName: '${screenName}',
    screenClassOverride: 'AnalyticsDemo',
  );
}