# Product Catalog App

A Flutter application built for the Junior Mobile Developer technical assessment. It fetches and displays products from the DummyJSON API, featuring infinite scrolling, state management, and a debounced search.

## Architecture
I implemented a 2-layer architecture to separate business logic from the UI:
* **Data Layer:** Contains the `Product` and `ProductResponse` models with defensive JSON parsing, and the `ApiService` which handles HTTP requests.
* **Presentation Layer:** Contains the UI screens (`ProductListScreen`, `ProductDetailScreen`), reusable components (`ProductCard`), and the `ProductProvider` for state management.

## State Management
I chose **Provider** because it offers a clean, reactive way to handle mutually exclusive UI states (Loading, Success, Empty, Error) and isolates the pagination/search logic away from the widget tree.

## Search Implementation
I implemented a **server-side debounced search** (500ms delay) using the DummyJSON search endpoint. 
* **Why server-side over client-side?** Filtering a paginated list on the client would only search the currently loaded items (e.g., the first 20). Hitting the search endpoint queries the entire database, providing accurate results without requiring the app to download the full catalog into memory.

## AI Usage Disclosure
I utilized AI as a thought partner to refine the timer-based search debounce, and troubleshoot initial Android Studio environment path errors on Windows. All core logic and architectural choices are my own.
