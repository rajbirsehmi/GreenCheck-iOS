# 🌿 GreenCheck

<p align="center">
  <img src="GreenCheck/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png" width="110" alt="GreenCheck App Icon" />
</p>

<h3 align="center">Know what's in your food. Choose what aligns with you.</h3>

<p align="center">
  Scan. Discover. Choose better.
  <br />
  A smarter way to make plant-based choices.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/iOS-17.0%2B-007AFF?style=flat-square&logo=apple&logoColor=white" alt="iOS 17+" />
  <img src="https://img.shields.io/badge/Swift-5.9%2B-F05138?style=flat-square&logo=swift&logoColor=white" alt="Swift 5.9+" />
  <img src="https://img.shields.io/badge/SwiftUI-Native-7B61FF?style=flat-square" alt="SwiftUI" />
  <img src="https://img.shields.io/badge/SwiftData-On--Device-34A853?style=flat-square" alt="SwiftData" />
  <img src="https://img.shields.io/badge/Privacy-First-14B8A6?style=flat-square" alt="Privacy First" />
  <img src="https://img.shields.io/badge/Dependencies-Zero-22C55E?style=flat-square" alt="Zero Dependencies" />
</p>

<p align="center">
  <strong>100% Free</strong> · <strong>Ad-Free</strong> · <strong>No Accounts</strong> · <strong>Your Data Stays on Your Device</strong>
</p>

---

## 🌱 A little more transparency. A lot more confidence.

Ever picked up a snack and wondered whether it's actually vegan?

**GreenCheck makes finding out simple.**

Scan a packaged food barcode or enter it manually to explore ingredient information, check reported vegan status, and discover plant-based alternatives when available.

Built with native Swift and SwiftUI, GreenCheck combines a clean iOS experience with open food data, local scan history, and a privacy-first approach.

No accounts to create. No ads to dismiss. No unnecessary complexity.

Just the information you need to make a more informed choice.

---

## 📱 Take a look around

<p align="center">
  <img src="GreenCheck/Screenshots/GreenCheck%20-%20Welcome%20Screen.png" width="240" alt="GreenCheck onboarding screen" />
  &nbsp;&nbsp;
  <img src="GreenCheck/Screenshots/GreenCheck%20-%20Home%20Screen.png" width="240" alt="GreenCheck home screen" />
  &nbsp;&nbsp;
  <img src="GreenCheck/Screenshots/GreenCheck%20-%20Scanner%20Screen.png" width="240" alt="GreenCheck barcode scanner" />
</p>

<p align="center">
  <em>A simple welcome. A clean home screen. A scanner ready to go.</em>
</p>

<p align="center">
  <img src="GreenCheck/Screenshots/GreenCheck%20-%20Product%20Screen%20-%201.png" width="240" alt="Product overview and vegan status" />
  &nbsp;&nbsp;
  <img src="GreenCheck/Screenshots/GreenCheck%20-%20Product%20Screen%20-%202.png" width="240" alt="Detailed ingredient analysis" />
  &nbsp;&nbsp;
  <img src="GreenCheck/Screenshots/GreenCheck%20-%20Product%20Screen%20-%203.png" width="240" alt="Plant-based alternatives" />
</p>

<p align="center">
  <em>Understand the product, explore its ingredients, and find alternatives.</em>
</p>

<p align="center">
  <img src="GreenCheck/Screenshots/GreenCheck%20-%20Manual%20Entry%20Screen.png" width="240" alt="Manual barcode entry" />
  &nbsp;&nbsp;
  <img src="GreenCheck/Screenshots/GreenCheck%20-%20History%20Screen.png" width="240" alt="Product scan history" />
  &nbsp;&nbsp;
  <img src="GreenCheck/Screenshots/GreenCheck%20-%20Privacy%20%26%20Transparency.png" width="240" alt="Privacy and transparency information" />
</p>

<p align="center">
  <em>Manual lookup, searchable history, and transparency by design.</em>
</p>

---

## ✨ Made for everyday decisions

### 📷 Scan it. Know it.

Point your iPhone camera at a packaged food barcode and let GreenCheck do the lookup.

* Real-time barcode detection powered by AVFoundation.
* Support for EAN-13, EAN-8, UPC-A, UPC-E, Code 39, Code 128, and PDF417.
* Custom viewfinder with focus-frame animation.
* Built-in flashlight toggle for low-light environments.
* Haptic feedback when a barcode is detected.

### 🔬 Ingredients, without the guesswork

Get a clearer picture of what goes into the products you buy.

| Status                | What it means                                           |
| --------------------- | ------------------------------------------------------- |
| 🟢 Vegan friendly     | The available product data identifies it as vegan.      |
| 🔴 Non-vegan detected | The available product data identifies it as non-vegan.  |
| 🟡 Uncertain          | The product's vegan status is reported as uncertain.    |
| ⚪ Unknown             | There isn't enough information to determine the status. |

Explore individual ingredients, available concentration percentages, and the full ingredient list reported by the product database.

*GreenCheck presents information from Open Food Facts. Results depend on the completeness and accuracy of the available data and are not an independent certification of a product.*

### 🌿 Discover plant-based alternatives

Found a product that isn't vegan, or one you're unsure about?

GreenCheck can search for alternatives from related product categories, helping you explore other options without starting your search from scratch.

Alternative suggestions depend on the products available in Open Food Facts.

### ⌨️ No scanner? No problem.

Damaged barcode? Camera not available?

Enter the barcode manually using the dedicated numeric-entry screen.

* Numeric-only input with digit sanitization.
* Support for common UPC/EAN barcode lengths, up to 14 digits.
* Live daily usage indicator.

### 💾 Your scan history, right on your iPhone

Every inspected product can be saved locally using SwiftData.

* Browse previously scanned products without an internet connection.
* Search by product name, brand, or barcode.
* Filter between all products, vegan products, and non-vegan products.
* Delete individual entries or clear your history.

Your history stays on your device instead of being tied to an online account.

### ⏱️ Thoughtful API usage

GreenCheck uses daily lookup limits to help respect the public Open Food Facts API.

| Lookup method  | Daily limit |
| -------------- | ----------: |
| Camera scans   |          10 |
| Manual lookups |          10 |

Usage is tracked locally and resets at midnight according to the device's local date. An in-app usage screen helps you see how much of your daily allowance remains.

### 🛡️ Privacy isn't an afterthought

GreenCheck is designed to work without collecting your personal information.

* **No accounts or logins**
* **No advertising or ad SDKs**
* **No analytics trackers**
* **No cloud-synced scan history**
* **No external dependencies**

Product lookups require an internet connection and send barcode-based requests to Open Food Facts. The app's local scan history, settings, and quota tracking remain on the device.

Your product searches aren't the same thing as a personal profile. GreenCheck is built to keep the experience simple and minimize unnecessary data handling.

---

## 🧰 Built with Apple's native tools

GreenCheck is written in Swift and uses Apple's native frameworks rather than a cross-platform UI layer or third-party dependency stack.

| Area                      | Technology                                     |
| ------------------------- | ---------------------------------------------- |
| User interface            | SwiftUI                                        |
| Minimum deployment target | iOS 17.0                                       |
| Language                  | Swift 5.9+                                     |
| State management          | Swift Observation                              |
| Local persistence         | SwiftData                                      |
| Barcode scanning          | AVFoundation                                   |
| Networking                | URLSession                                     |
| Data decoding             | Codable                                        |
| Asynchronous operations   | Swift Concurrency (`async`/`await`)            |
| Product database          | Open Food Facts API v2                         |
| Typography                | Poppins font family                            |
| Design system             | Custom semantic colors, shapes, and typography |
| Third-party dependencies  | None                                           |

### Why native Swift?

Native frameworks provide a focused foundation for a lightweight iOS application, including direct access to the camera, local persistence, modern state management, and platform-native UI patterns.

The result is a project that stays close to the Apple ecosystem and avoids unnecessary dependencies.

---

## 🏗️ Architecture

GreenCheck follows a layered architecture with MVVM, repository abstractions, and separation between the domain, data, and presentation layers.

```text
GreenCheck/
├── App/
│   └── GreenCheckApp.swift
│
├── Core/
│   ├── Local/
│   │   ├── Database/
│   │   │   ├── ProductEntity.swift
│   │   │   ├── ProductLocalDataSource.swift
│   │   │   └── ProductLocalDataSourceImpl.swift
│   │   └── Model/
│   │       ├── DietaryStatus.swift
│   │       ├── IngredientItem.swift
│   │       └── ProductItem.swift
│   │
│   ├── Mapper/
│   │   └── Product+IngredientMapper.swift
│   │
│   ├── Remote/
│   │   ├── Model/
│   │   └── Network/
│   │       ├── ApiEndpoints.swift
│   │       ├── NetworkError.swift
│   │       ├── ProductRemoteDataSource.swift
│   │       └── ProductRemoteDataSourceImpl.swift
│   │
│   └── Repo/
│       ├── ProductRepository.swift
│       └── ProductRepositoryImpl.swift
│
├── UI/
│   ├── HostScreen/
│   │   └── HostScreen.swift
│   │
│   └── Screens/
│       ├── Home/
│       ├── Scanner/
│       ├── Manual/
│       ├── Product/
│       ├── History/
│       └── Others/
│           ├── WelcomeScreen/
│           ├── UsageSheet/
│           └── PrivacyAndTransparency/
│
├── Utils/
│   ├── QuotaManager.swift
│   ├── LookupSource.swift
│   └── Utils.swift
│
└── Resources/
    ├── Assets.xcassets/
    ├── Fonts/
    ├── Mocks/
    ├── Screenshots/
    └── Theme/
```

### How the pieces fit together

* **Presentation:** SwiftUI screens and view models manage user interactions and screen state.
* **Domain:** Product and ingredient models represent the information used throughout the application.
* **Repository:** Coordinates local and remote data sources and supports cached product access.
* **Local data:** SwiftData persists inspected products for future access.
* **Remote data:** Native networking retrieves product and ingredient information from Open Food Facts.
* **Utilities:** Shared helpers and `QuotaManager` handle lookup-source tracking, daily limits, and supporting functionality.

This separation keeps UI code independent of the underlying data sources and makes individual components easier to maintain and test.

---

## 🚀 Get started

Want to explore the code, run the app, or build on top of it? Here's how to get started.

### Requirements

* macOS Sonoma 14.0 or later.
* Xcode 15 or later, with a compatible Swift toolchain.
* An iPhone running iOS 17.0 or later for physical-device camera scanning.
* Internet access for product lookups through Open Food Facts.

### 1. Clone the repository

```bash
git clone https://github.com/your-username/GreenCheck.git
cd GreenCheck
```

Replace `your-username` with the repository owner's GitHub username.

### 2. Open the project

```bash
open GreenCheck.xcodeproj
```

### 3. Select your destination

Choose an iOS 17+ simulator or connect your iPhone.

The simulator can be used to explore the UI and test manual lookups. A physical device is required to test live camera barcode scanning.

### 4. Build and run

Press **⌘ R** in Xcode, or select **Product → Run**.

Camera access must be permitted when prompted. The app's camera usage description should be configured in `Info.plist`.

---

## 🔌 Data source

GreenCheck uses the [Open Food Facts API](https://world.openfoodfacts.org/) to retrieve packaged-food product information.

Open Food Facts is an open, collaborative food database containing product names, brands, ingredients, barcodes, and other information contributed by its community.

* Website: https://world.openfoodfacts.org/
* API documentation: https://openfoodfacts.github.io/openfoodfacts-server/api/
* Database license: [Open Database License (ODbL) v1.0](https://opendatacommons.org/licenses/odbl/1-0/)

Product availability and the level of ingredient detail vary by item and region. GreenCheck does not independently verify every database entry.

Please consult the original product packaging for authoritative ingredient and allergen information, especially when making decisions related to allergies or strict dietary requirements.

---

## 🔒 Privacy & transparency

GreenCheck is designed around a straightforward principle:

**The app should work for you without needing to know who you are.**

There are no user accounts, advertising SDKs, or analytics trackers. Scan history, app settings, and daily usage tracking are stored locally.

When you look up a product, GreenCheck communicates with Open Food Facts to retrieve its available information. That network request is necessary for remote product lookup and is separate from the locally stored app data.

For more details, see the in-app **Privacy & Transparency** screen.

---

## 🗺️ Roadmap

Ideas for future improvements as GreenCheck evolves:

* [ ] Expand automated unit and UI test coverage.
* [ ] Improve ingredient explanations and uncertainty handling.
* [ ] Refine product matching and alternative discovery.
* [ ] Add more offline-friendly product information.
* [ ] Continue improving accessibility and Dynamic Type support.
* [ ] Explore additional ways to make product data easier to understand.

Have an idea? Suggestions and contributions are welcome.

---

## 🤝 Contributing

Found a bug, spotted an issue, or have an idea that could make GreenCheck better?

Contributions are welcome.

1. Fork the repository.
2. Create a feature branch.
3. Make your changes.
4. Test your changes on a compatible iOS simulator or device.
5. Submit a pull request describing what changed and why.

For larger changes, opening an issue first is a good way to discuss the approach before investing time in implementation.

Please keep changes focused, follow the existing architectural patterns, and prefer native Apple frameworks where practical.

---

## 📄 License & attribution

### Open Food Facts

Product data is provided by [Open Food Facts](https://world.openfoodfacts.org/) and is subject to the applicable [Open Database License (ODbL) v1.0](https://opendatacommons.org/licenses/odbl/1-0/).

GreenCheck is an independent application and is not affiliated with or endorsed by Open Food Facts.

### GreenCheck source code

The source-code license for GreenCheck should be specified by the repository owner. Unless a license is included in the repository, no open-source license should be assumed.

### Disclaimer

GreenCheck is intended for informational and educational purposes only. Vegan classifications and ingredient information depend on the data available from Open Food Facts and may be incomplete, inaccurate, or outdated.

Always check product packaging and manufacturer information for strict dietary requirements, allergies, or other health-related concerns.

---

<p align="center">
  <strong>🌿 Better information. More mindful choices.</strong>
  <br />
  <sub>Made with SwiftUI, a love for clean code, and a little more transparency.</sub>
</p>

<p align="center">
  <sub>GreenCheck — Know what you're choosing.</sub>
</p>
