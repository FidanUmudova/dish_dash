# DishDash - Recipe Explorer App

A modern cross-platform Flutter application built for the API assignment. The app connects to the **DummyJSON Recipes REST API**, allowing users to browse recipes, view detailed preparation steps, refresh content, and paginate seamlessly.

---

## Screen Recording / Demo Video

https://drive.google.com/file/d/1ds6z6ZhXFQqXP2vL22gQLqnc9-JX2O98/view?usp=sharing

---

## Features & Submission Criteria Checklist

- [x] **API Service Layer (20 pts):** Isolated HTTP service in `lib/services/api_service.dart` handling paginated GET requests with `http`.
- [x] **List + Detail Screen (15 pts):** Clean navigation passing full `Recipe` model instances to `RecipeDetailScreen`.
- [x] **State Management (15 pts):** UI handles Loading, Empty, and Error states, including a functional **Retry** button for failed network requests.
- [x] **Pull-to-Refresh & Pagination (20 pts):** Integrated `RefreshIndicator` and infinite scrolling using `ScrollController` with fetch-guarding (`_isFetchingMore`).
- [x] **Image Caching (10 pts):** Uses `cached_network_image` for smooth image loading with custom placeholders and fallback error icons.
- [x] **JSON Model Parsing & Null Safety (15 pts):** Defensive `fromJson` factory constructor with default fallback values (`??`) preventing null-pointer crashes.
- [x] **Clean Architecture (5 pts):** Implemented **Repository Pattern** (`RecipeRepository`) separating networking, data transformation, and UI layers.

---

## Packages Used

| Package | Version | Purpose |
| :--- | :--- | :--- |
| [`http`](https://pub.dev/packages/http) | `^1.2.0` | Sending REST API requests |
| [`cached_network_image`](https://pub.dev/packages/cached_network_image) | `^3.3.1` | Network image caching and placeholders |
| [`cupertino_icons`](https://pub.dev/packages/cupertino_icons) | `^1.0.8` | Default iOS-style icons |

---

## Project Architecture

```text
lib/
├── main.dart                      # Application entry point & Theme configuration
├── models/
│   └── recipe.dart                # Recipe data model & JSON parsing logic
├── services/
│   └── api_service.dart           # Raw HTTP network request service
├── repositories/
│   └── recipe_repository.dart     # Repository pattern separating data & UI logic
└── screens/
    ├── recipe_list_screen.dart    # Main list view (Pagination, Pull-to-refresh, States)
    └── recipe_detail_screen.dart  # Detailed view (Ingredients, Instructions, Images)
