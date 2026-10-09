# GreenCheck

Scan packaged food barcodes to instantly verify vegan status, explore ingredient analysis, and find vegan alternatives — all with a privacy-first, ad‑free experience.

## Features
- Camera barcode scanner (AVFoundation)
  - Live camera preview with focus frame overlay
  - Torch/flashlight toggle
  - Haptic feedback on detection
  - Supports EAN-13, EAN-8, UPC-E, Code 39, Code 128, PDF417
- Manual barcode entry
  - Numeric keypad with input filtering (digits only)
  - Supports EAN/UPC formats
  - Keyboard accessory with Done action
- Product details
  - Product hero (image, name, brand, UPC)
  - Clear vegan status banner with color-coded icon
  - Ingredient Analysis: Vegan Friendly, Uncertain Source, Non‑Vegan Detected
  - Ingredient Breakdown with percentages where available
  - Collapsible full ingredient list parsed from raw text
  - Vegan alternatives carousel (category-based suggestions)
- History (SwiftData local cache)
  - Automatic caching of looked‑up products
  - Searchable by name/brand/UPC
  - Filter by Vegan / Non‑Vegan / All (segmented control)
  - Swipe to delete and Clear All with confirmation
- Usage limits (per device)
  - Separate daily quotas for Scanner and Manual lookups
  - Inline quota badge with remaining count and warning state
- Onboarding & info
  - Welcome sheet highlighting core capabilities
  - Privacy & Transparency sheet: no accounts, no tracking, ad‑free
- Design system
  - SwiftUI throughout with custom typography
  - Consistent shapes, colors, and HIG‑friendly components

## Screenshots
Below images are referenced from the `Screenshots` folder. If your filenames differ, update the `src` paths accordingly.

<div align="center">
  
  <img src="Screenshots/home.png" alt="Home" width="260" />
  <img src="Screenshots/manual.png" alt="Manual Entry" width="260" />
  <img src="Screenshots/history.png" alt="History" width="260" />
  
  <img src="Screenshots/scanner.png" alt="Scanner" width="260" />
  <img src="Screenshots/product.png" alt="Product Details" width="260" />
  <img src="Screenshots/alternatives.png" alt="Vegan Alternatives" width="260" />
  
  <img src="Screenshots/privacy.png" alt="Privacy & Transparency" width="260" />
  <img src="Screenshots/welcome.png" alt="Welcome" width="260" />
</div>

> Tip: If images do not render on GitHub, verify the filenames (case‑sensitive) inside the `Screenshots/` directory and adjust the paths above.

## How it works
- GreenCheck queries the Open Food Facts API for product metadata and ingredients.
- Ingredient analysis tags and parsed lists are used to infer dietary status.
- A lightweight local cache (SwiftData) stores your recent lookups for offline access.
- When a product is not fully vegan, the app can suggest vegan alternatives from similar categories.

## Tech stack
- SwiftUI for UI
- SwiftData for local persistence
- AVFoundation for barcode scanning
- Swift Concurrency (async/await)
- URLSession/JSON decoding for networking

## Requirements
- iOS 17 or later (SwiftData)
- Xcode 15 or later

## Getting started
1. Clone the repository
   ```bash
   git clone https://github.com/your-username/greencheck.git
   cd greencheck
