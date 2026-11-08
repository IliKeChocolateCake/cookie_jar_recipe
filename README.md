# Cookie Jar Recipes

A Flutter app for saving, browsing and managing your own recipes, with photos, ingredients and steps, stored locally on the device.

**Author:**   Elly E.
**Date:** 8 November 2026

---

## Features

- Browse recipes, filterable by recipe type (All, Breakfast, Lunch, and so on)
- Create a recipe with a photo, type, ingredients and steps
- Detailed recipe page with edit and delete
- Swipe right on a list item to delete it
- Data persists across restarts (local storage)
- Pre-populated sample recipes on first launch
- Empty states for an empty jar and for a filter with no results
- Manual refresh with a "last synced" timestamp
- Login and logout with a session that persists until logout

## Tech Stack

| Area | Choice |
|---|---|
| Framework | Flutter (Dart) |
| Local storage | Hive (`hive`, `hive_flutter`) |
| State management | Provider with `ChangeNotifier` (MVVM) |
| Images | `image_picker`, `path_provider`, `path`, `cached_network_image` |
| IDs | `uuid` |
| Fonts | `google_fonts` (Chewy) |
| Auth | `flutter_secure_storage`, `crypto` (SHA-256) |

## Project Structure

```
lib/
  main.dart
  constant/       text styles
  data/
    model/        RecipeModel, RecipeType, Hive adapter
    repository/   recipe repository (Hive CRUD), recipe type loader, auth repository
    services/     image service (copies picked images into app storage)
  view_model/     recipe list view model, auth view model
  ui/
    pages/        list, form (create and edit), detail, login
    widget/       recipe card, recipe image, empty state, confirm delete
asset/            recipetypes.json, sample_recipes.json, users.json
test/             unit tests
```

## Design Decisions

### Why Hive

Hive is lightweight and fast for local storage. Recipes are simple objects with no relations, so a key-value store fits well.

**Trade-off:** Hive loads its data into memory and has no query language. For large or complex data (thousands of records, joins, complex filtering), I would switch to SQLite, because Hive would put too much pressure on RAM.

### Hive handles the CRUD

All four operations go through one repository, backed by a Hive box keyed by recipe id:

- **Create:** `put(id, recipe)` with a new `uuid` v4
- **Read:** `values`, `get(id)`, and a filter on `typeId`
- **Update:** `put(id, recipe)` with the existing id, which overwrites the old entry
- **Delete:** `delete(id)`

Create and update share one form page. When a recipe is passed in, the form is prefilled and saves under the same id.

### Why a hand-written Hive adapter

`hive_generator` and `build_runner` conflicted with the `analyzer` version in my setup. The generator warned that the analyzer was older than the Dart SDK and then produced no output. Rather than lose time on version pinning, I wrote the `TypeAdapter` by hand (about 30 lines). The field numbers in `read` and `write` must stay stable once data has been saved.

### Why a view model (MVVM)

The view model holds the screen state (recipes, types, selected filter, loading, last synced) and the actions (load, filter, save, delete). Widgets only display what it exposes and call its methods, and repositories handle Hive and JSON. This keeps widgets small, keeps storage details out of the UI, and makes the logic testable without a screen.

### Why Provider

Provider with `ChangeNotifier` is simple, widely used, and needs little boilerplate. For an app this size, heavier options such as Bloc or Riverpod would add more setup than benefit. Widgets use `watch` to rebuild on changes and `read` to call actions.

### Empty states

There are two different cases, with different messages:

- **The jar is empty:** "Your cookie jar is empty. Add your first recipe!" with an Add button.
- **A filter has no results:** "No recipes in this category yet."

Without them, both cases would show a blank screen that looks broken.

### Last sync versus auto refresh

I chose a manual refresh button with a "last synced" timestamp instead of auto refresh. Auto refreshing everything makes the app heavier and uses more battery and data, and the user can't tell how fresh the data is anyway. A visible timestamp answers that directly. Right now the data is local, so refresh reloads from storage; the same pattern becomes meaningful once an API is added.

### Swipe to delete (Dismissible)

Swiping right on a list item deletes it. Each item is keyed by its recipe id, not its index, so the right item is removed. The item is removed from the list immediately, which avoids the "dismissed widget is still in the tree" error. The detail page also has an explicit delete button.

### Friction for delete

Delete is destructive and swipes are easy to trigger by accident, so every delete, from a swipe or from the detail page, asks for confirmation first. The same confirm dialog is shared by both places.

## Authentication

- Credentials come from a local `users.json` that stores a **SHA-256 hash** of each password, never the plain text.
- On login, the typed password is hashed and compared with the stored hash.
- A successful login saves a generated token in `flutter_secure_storage` (encrypted).
- On launch, an auth gate checks for a token: if one exists the user goes straight to the recipe list, otherwise to the login page.
- Logout deletes the token and returns to the login page. Recipes are not affected.

**Demo login:** `cookie` / `cookie123`

## Getting Started

**Requirements:** Flutter SDK and an Android emulator or device (recommended).

```bash
flutter pub get
flutter run
```

Run the unit tests:

```bash
flutter test
```

**Notes**

- Photo picking copies the chosen image into the app's documents directory. This is not available on Flutter web, so please use an emulator or a phone.
- Sample recipes are seeded once on first launch, guarded by a `seeded` flag, so recipes you delete do not come back after a restart.
- Sample recipe images and the Chewy font can load from the network. The app falls back to a placeholder and the default font if they are unavailable.
- Demo login: `cookie` / `cookie123`

## Data Notes

`recipetypes.json` was not included with the materials I received, so I created one in `asset/recipetypes.json` (an id and a name per type). Recipes reference a type by `typeId`. The types are read-only and loaded from the asset on each launch, while recipes live in Hive.

## Bonus Items

- **Architecture pattern:** MVVM with Provider
- **Authentication:** login, logout, hashed credentials, encrypted token storage, session persistence until logout
- **Unit tests:** repository CRUD, filtering, seeding, and model JSON parsing

## Known Limitations

- Authentication is a mock. The users file is a bundled asset that anyone can read, whereas a real app would send credentials to a server that returns the token.
- Passwords are hashed with plain SHA-256 without a salt, which is not production-grade.
- Old image copies are not deleted when a recipe's photo is changed or removed.
- Ingredients and steps are entered as one item per line, not as separate editable rows.
- Refresh reloads from local storage; there is no network sync yet.

## What I Would Improve

- Build flavors for dev, staging and production, with CI/CD so releases do not depend on manual switching
- A real API layer for authentication and recipe types
- UI and widget tests alongside the unit tests
- Switch to SQLite if the data grows large or needs complex queries
- Separate editable rows for ingredients and steps

## Time Spent and AI Use

Time spent: about 6 hours.
