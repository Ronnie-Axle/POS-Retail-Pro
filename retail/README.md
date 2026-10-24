# POS Retail Pro

Flutter POS prototype implementing the 12-screen mobile workflow from the
provided product brief: welcome, sign-in, dashboard, catalog, checkout,
payment, inventory, customers, analytics, settings, offline status and business
profile customization.

## Run and validate

From this directory:

```powershell
flutter pub get
flutter run
flutter analyze
flutter test
```

## Source layout

```text
lib/
  main.dart             App entry point and navigation composition
  app_state.dart        Cart, inventory filters and sync queue state
  screens/              One file per screen plus shared presentation widgets
  theme/app_theme.dart  Color tokens and Material theme
assets/
  pos_retail_pro_icon.jpg  App launcher icon artwork
api/
  openapi.yaml          POS, inventory and payment API contracts
test/
  widget_test.dart      Navigation, cart calculation and sync queue tests
```

The Flutter app is organized around feature flows and shared app state, and
keeps the theme and API contract separate. It currently uses in-memory sample
data and a lightweight `ChangeNotifier` state layer to keep the prototype
dependency-free; the state objects can be replaced behind feature repositories
when the service and persistence packages are added.

Each screen is implemented in its own file under `lib/screens/`. The supplied
POS emblem is used to generate the Android and iOS launcher icons via the
`flutter_launcher_icons` development tool.

## API contract

`api/openapi.yaml` defines the mobile BFF contract for catalog lookup and stock
adjustments, order creation and voiding, and payment initiation/status. The
contract uses UGX integer amounts, an 18% tax rate, JWT bearer authentication,
and UUID `Idempotency-Key` headers for write operations.

## Integration boundaries

This repository contains a runnable UI prototype and API contract, not deployed
microservices or a production POS integration. The sample credentials, product
catalog, transaction list, reports and customer list are illustrative. Sign-in,
OAuth, card/mobile-money/bank processing, durable offline database storage,
connectivity monitoring, automatic batch synchronization, reconciliation,
server-side authorization and analytics aggregation still require backend and
provider integrations. The offline queue and UUID idempotency-key generation
are in-memory demonstrations and do not survive an app restart.
