# Movie Explorer - setup

1. flutter create movie_explorer
2. cd movie_explorer
3. flutter pub add provider
4. Delete the default lib/ folder and test/widget_test.dart, then copy this lib/ folder in.
5. flutter run -d chrome

## Build + deploy (GitHub Pages)
flutter build web --base-href "/YOUR-REPO-NAME/"
Then publish the contents of build/web (e.g. gh-pages branch, or Settings > Pages).
