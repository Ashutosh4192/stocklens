# StockLens

**StockLens** is a Flutter-based mini portfolio application that allows users to track their stock holdings, view performance trends, and explore stock insights through a clean, modern UI.

## ✨ Features

### 📈 Portfolio Overview
- Total portfolio summary
- 1D returns, total returns, and invested value
- Privacy toggle (eye icon) to hide/show monetary values

### 📉 Stock Details
- Company logo with Hero animation
- Current price, quantity, and average buy price
- Day / Week / Month percentage changes
- Price history line chart
- AI insight summary

### 🎨 UI & UX
- Light & Dark mode support
- Material 3 theming
- Smooth animations & transitions
- Finance-app styled charts
- Theme-aware colors for accessibility

## Tech Stack

- **Flutter** (Material 3)
- **Provider** – state management
- **fl_chart** – price history charts
- **Local JSON** – mock data (no backend)

## 📁 Project Structure

lib/
├── models/
│ ├── stock.dart
│ └── market_summary.dart
│
├── providers/
│ ├── portfolio_provider.dart
│ └── theme_provider.dart
│
├── screens/
│ ├── portfolio_screen.dart
│ └── stock_detail_screen.dart
│
├── widgets/
│ ├── stock_tile.dart
│ ├── market_summary_bar.dart
│ ├── portfolio_summary_card.dart
│ └── price_chart.dart
│
└── main.dart
assets/
├── data/
│ └── mock_data.json
└── logos/
├── tcs.png
├── infy.png
└── hdfcbank.png


Includes:
- Holdings
- Stock-level details
- Price history
- AI insights

---

## Getting Started

### Prerequisites
- Flutter SDK (3.x or later)
- Android Studio / VS Code
- Emulator or physical device

## Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/<your-username>/stocklens.git
   ```
2. Navigate to the project directory:
   ```sh
   cd stocklens
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```
4. Run the app:
   ```sh
   flutter run
   ```

## Privacy Mode
Users can toggle visibility of portfolio values:
Eye open → show currency values
Eye closed → hide values, show only percentages

This mimics real-world finance apps and improves user privacy.

## Notes & Assumptions
Static mock data (no backend)
No authentication
Focus on UI/UX, chart accuracy, and clean architecture
Designed for evaluation and extensibility

## Future Improvements
Live market data integration
Persistent theme & privacy state
Interactive chart tooltips
Stock search & filtering
Portfolio analytics
