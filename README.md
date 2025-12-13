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

## Screenshots
<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/fb79b67f-c8ab-4314-a0c2-931333254e8d" width="70%"></td>
    <td><img src="https://github.com/user-attachments/assets/759d6e0c-6b95-443a-a371-079debfae8a9" width="70%"></td>
  </tr>
</table>

## Privacy Mode
- Users can toggle visibility of portfolio values:
- Eye open → show currency values
- Eye closed → hide values, show only percentages

This mimics real-world finance apps and improves user privacy.

## Notes & Assumptions
- Static mock data (no backend)
- No authentication
- Focus on UI/UX, chart accuracy, and clean architecture
- Designed for evaluation and extensibility

## Future Improvements
- Live market data integration
- Persistent theme & privacy state
- Interactive chart tooltips
- Stock search & filtering
- Portfolio analytics
