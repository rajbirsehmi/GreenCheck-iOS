# GreenCheck 🌿

[![iOS 17.0+](https://img.shields.io/badge/iOS-17.0%2B-blue.svg?style=flat-square&logo=apple)](https://developer.apple.com/ios/)
[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9%2B-orange.svg?style=flat-square&logo=swift)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-purple.svg?style=flat-square)](https://developer.apple.com/xcode/swiftui/)
[![SwiftData](https://img.shields.io/badge/Storage-SwiftData-green.svg?style=flat-square)](https://developer.apple.com/documentation/swiftdata)
[![Privacy First](https://img.shields.io/badge/Privacy-100%25%20On--Device-teal.svg?style=flat-square)]()
[![Zero Dependencies](https://img.shields.io/badge/Dependencies-Zero%203rd--Party-success.svg?style=flat-square)]()

> **Scan packaged food barcodes to instantly verify vegan status, explore detailed ingredient analyses, and discover plant-based alternatives — all in a 100% ad-free, privacy-first iOS experience.**

---

## 📸 Screenshots

| Home Dashboard | Barcode Scanner | Manual Search |
| :---: | :---: | :---: |
| <img src="GreenCheck/Screenshots/GreenCheck%20-%20Home%20Screen.png" width="250" alt="GreenCheck Home Screen" /> | <img src="GreenCheck/Screenshots/GreenCheck%20-%20Scanner%20Screen.png" width="250" alt="GreenCheck Camera Barcode Scanner" /> | <img src="GreenCheck/Screenshots/GreenCheck%20-%20Manual%20Entry%20Screen.png" width="250" alt="GreenCheck Manual Barcode Entry" /> |

| Product Overview | Ingredient Analysis | Alternative Suggestions |
| :---: | :---: | :---: |
| <img src="GreenCheck/Screenshots/GreenCheck%20-%20Product%20Screen%20-%201.png" width="250" alt="Product Overview and Status" /> | <img src="GreenCheck/Screenshots/GreenCheck%20-%20Product%20Screen%20-%202.png" width="250" alt="Detailed Ingredient Analysis" /> | <img src="GreenCheck/Screenshots/GreenCheck%20-%20Product%20Screen%20-%203.png" width="250" alt="Plant-Based Product Alternatives" /> |

| Scan History | History (Empty State) |
| :---: | :---: |
| <img src="GreenCheck/Screenshots/GreenCheck%20-%20History%20Screen.png" width="250" alt="Searchable Scan History" /> | <img src="GreenCheck/Screenshots/GreenCheck%20-%20History%20Screen%20(Empty).png" width="250" alt="Empty Scan History State" /> |

---

## ✨ Features

### 📷 High-Performance Camera Barcode Scanner
- **AVFoundation-Powered**: Real-time scanning using hardware-accelerated video metadata capture (`AVCaptureMetadataOutput`).
- **Comprehensive Symbology Support**: Scans EAN-13, EAN-8, UPC-E, UPC-A, Code 39, Code 128, and PDF417.
- **Interactive Viewfinder**: Custom target overlay, focus frame animation, and flashlight/torch toggle.
- **Haptic Feedback**: Instant tactile confirmation upon successful barcode detection.

### ⌨️ Manual Barcode Entry
- Dedicated numeric entry screen for items with damaged or unscannable barcodes.
- Automated digit sanitization (limits to valid 14-digit UPC/EAN formats).
- Live quota consumption badge indicator.

### 🔬 Intelligent Dietary & Ingredient Analysis
- **Instant Vegan Status Verification**: Evaluates ingredients into clear categories:
  - 🟢 **Vegan Friendly** (`yes`)
  - 🔴 **Non-Vegan Detected** (`no`)
  - 🟡 **Uncertain Source** (`maybe`)
  - ⚪ **Unknown** (`unknown`)
- **Granular Ingredient Breakdown**: Inspects individual ingredients with percentage concentrations where provided by Open Food Facts.
- **Expandable Raw Ingredients**: View full ingredient lists formatted directly from the product packaging.
- **Plant-Based Alternatives Carousel**: When an inspected product is non-vegan or uncertain, GreenCheck queries category-matched vegan alternatives in real time.

### 💾 Local Scan History (SwiftData)
- **Automatic Caching**: Every inspected product is persisted locally using modern **SwiftData** (`ProductEntity`).
- **Offline Access**: Review previously scanned items anytime without an internet connection.
- **Search & Filter**: Search cached items by product name, brand, or barcode, with segmented filter controls (*All*, *Vegan*, *Non-Vegan*).
- **History Management**: Swipe-to-delete individual entries or clear all history with a single tap.

### ⏱️ On-Device Quota Management
- Enforces friendly daily rate-limiting (10 camera scans + 10 manual lookups per day) to respect Open Food Facts public API infrastructure.
- Zero server communication required for quotas — tracked securely and locally via `UserDefaults` and `@Observable` `QuotaManager`.
- Automated midnight reset (12:00 AM local time).
- Informative usage progress sheet and quota warning badges.

### 🛡️ Privacy & Transparency
- **100% Free & Ad-Free**: No subscriptions, paywalls, or third-party advertising SDKs.
- **Zero Data Collection**: No accounts, logins, analytics trackers, or cloud tracking. All history and settings remain strictly on your physical device.

---

## 🏛️ Architecture & Clean Code

GreenCheck is built using modern **Clean Architecture** and **MVVM (Model-View-ViewModel)** with Apple's modern Swift Observation framework:

```
GreenCheck/
├── App/
│   └── GreenCheckApp.swift                 # App lifecycle, modelContainer, custom typography init
├── Core/
│   ├── Local/
│   │   ├── Database/
│   │   │   ├── ProductEntity.swift         # SwiftData @Model schema & entity mappers
│   │   │   ├── ProductLocalDataSource.swift
│   │   │   └── ProductLocalDataSourceImpl.swift
│   │   └── Model/
│   │       ├── DietaryStatus.swift         # Dietary enum (yes, no, maybe, unknown)
│   │       ├── IngredientItem.swift        # Ingredient domain model
│   │       └── ProductItem.swift           # Product domain model & computed vegan status
│   ├── Mapper/
│   │   └── Product+IngredientMapper.swift  # DTO to Domain model mapping
│   ├── Remote/
│   │   ├── Model/                          # Decodable DTOs (ProductDTO, IngredientDTO, etc.)
│   │   └── Network/
│   │       ├── ApiEndpoints.swift          # Open Food Facts v2 endpoint builder
│   │       ├── NetworkError.swift          # Custom networking errors
│   │       ├── ProductRemoteDataSource.swift
│   │       └── ProductRemoteDataSourceImpl.swift
│   └── Repo/
│       ├── ProductRepository.swift         # Repository protocol
│       └── ProductRepositoryImpl.swift     # Offline-first caching & remote fallback logic
├── UI/
│   ├── HostScreen/
│   │   └── HostScreen.swift                # Root TabView navigation & onboarding trigger
│   └── Screens/
│       ├── Home/                           # Welcome banner, feature highlights & disclaimer
│       ├── Scanner/                        # AVCapture preview, viewfinder overlay & ViewModel
│       ├── Manual/                         # Numeric keypad lookup & ViewModel
│       ├── Product/                        # Detailed inspection view & alternatives ViewModel
│       ├── History/                        # SwiftData history list, filters & ViewModel
│       └── Others/
│           ├── WelcomeScreen/              # First-launch onboarding modal
│           ├── UsageSheet/                 # Daily quota indicators & progress cards
│           └── PrivacyAndTransparency/     # Privacy guarantee & ODbL open-data licensing
├── Utils/
│   ├── QuotaManager.swift                  # @Observable daily rate-limiter
│   ├── LookupSource.swift                  # Source tracking (scanner vs manual)
│   └── Utils.swift                         # Shared helpers
└── Resources/
    ├── Assets.xcassets                     # App icons, colors, illustrations
    ├── Fonts/                              # Poppins font family suite (TTF)
    ├── Mocks/                              # Offline JSON fixtures for testing
    ├── Screenshots/                        # App showcase visual previews
    └── Theme/                              # Semantic AppColors, AppShapes & FontExtension
```

---

## 🛠️ Tech Stack & Technologies

| Layer / Component | Technology |
| :--- | :--- |
| **User Interface** | SwiftUI (iOS 17+) |
| **State Management** | Swift Observation (`@Observable`, `@State`, `@Binding`) |
| **Local Persistence** | SwiftData (`@Model`, `ModelContext`, `ModelContainer`) |
| **Camera & Barcode** | AVFoundation (`AVCaptureSession`, `AVCaptureMetadataOutput`) |
| **Networking** | Native `URLSession` + `Codable` with Swift Concurrency (`async`/`await`) |
| **Typography & Theme** | Poppins Font Family Suite, Dynamic Type scaling, Custom Design Tokens |
| **Data Source** | [Open Food Facts API v2](https://world.openfoodfacts.org/) |
| **Dependencies** | **0 external dependencies** (Pure Swift / Native Apple SDKs) |

---

## 🚀 Getting Started

### Prerequisites
- macOS Sonoma (14.0+) or later
- Xcode 15.0+ or Xcode 16.0+
- An iOS device running iOS 17.0+ (for camera barcode scanning; Simulator can test manual lookups)

### Installation & Running
1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/GreenCheck.git
   cd GreenCheck
   ```

2. **Open in Xcode**:
   ```bash
   open GreenCheck.xcodeproj
   ```

3. **Select your target device or simulator**:
   - Choose an iOS 17+ Simulator or your connected iPhone.
   - For camera scanning, run on a physical iOS device (`NSCameraUsageDescription` is already pre-configured in `Info.plist`).

4. **Build and Run**:
   - Press `Cmd + R` in Xcode.

---

## 📄 License & Attribution

- **Product Data**: Product information, ingredients, and barcodes are retrieved from the open database provided by [Open Food Facts](https://world.openfoodfacts.org/) and licensed under the [Open Database License (ODbL) v1.0](https://opendatacommons.org/licenses/odbl/1-0/).
- **Disclaimer**: GreenCheck is intended for informational and educational purposes. Always inspect physical packaging and allergen warnings for strict medical or dietary requirements.
