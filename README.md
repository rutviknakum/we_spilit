Creating a `README.md` file for your Flutter project is a great idea as it helps others understand what your project is about, how to set it up, and how to use it. Here's a sample `README.md` file based on the information you've provided:

```markdown
# We Split - Flutter Application

We Split is a Flutter-based mobile application designed to help users manage shared expenses with friends. The app allows users to add friends, track shared expenses, and manage payments through QR codes.

## Features

- **Add New Friends**: Easily add new friends with their first and last names, Google Pay barcode, and shared expenses.
- **Shared Expense Management**: Keep track of shared expenses among friends, and view detailed expense information.
- **QR Code Integration**: Scan and display QR codes for quick payments.
- **Swipe to Delete**: Swipe left on a friend to reveal a delete option, with confirmation dialogs to prevent accidental deletions.
- **Beautiful UI**: The app includes a custom background and intuitive user interface for easy navigation.

## Screenshots

![Home Screen](asset/background.jpeg)

## Getting Started

These instructions will help you set up the project on your local machine for development and testing purposes.

### Prerequisites

Ensure you have the following installed:

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)
- [Xcode](https://developer.apple.com/xcode/) (for iOS development)
- [Android Studio](https://developer.android.com/studio) (for Android development)

### Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/rutviknakum/we_split.git
   cd we_split
   ```

2. **Install dependencies**:

   Run the following command to install all required dependencies:

   ```bash
   flutter pub get
   ```

3. **Configure iOS for CocoaPods**:

   Navigate to the `ios` directory and run:

   ```bash
   cd ios
   pod install
   cd ..
   ```

   If you encounter issues related to `CocoaPods` not setting the base configuration, ensure that the Xcode project is correctly configured by following these steps:

   - Open the project in Xcode.
   - Go to `Build Settings`.
   - Search for `Base Configuration`.
   - Set the Base Configuration for `Debug` to `Target Support Files/Pods-Runner/Pods-Runner.debug.xcconfig`.
   - Set the Base Configuration for `Release` to `Target Support Files/Pods-Runner/Pods-Runner.release.xcconfig`.

4. **Run the app**:

   You can run the app on an iOS simulator, Android emulator, or a physical device using:

   ```bash
   flutter run
   ```

## Usage

- **Home Screen**: View all added friends and their shared expenses.
- **Add New Friends**: Tap the "Add new Friends" button to add a new friend to your list.
- **Manage Expenses**: View detailed expense reports and manage payments through integrated QR codes.
- **Delete Friends**: Swipe left on a friend entry to delete them. A confirmation dialog will ensure no accidental deletions.

## Troubleshooting

If you encounter the error `Another exception was thrown: A dismissed Dismissible widget is still part of the tree.`, ensure the underlying data is updated immediately when dismissing an item. Refer to the code comments for more details.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue on GitHub.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contact

- **Rutvik Nakum** - [GitHub](https://github.com/rutviknakum)
```

### Explanation of the README Structure

- **Project Title and Description**: Provides a brief overview of the app.
- **Features**: Highlights the key functionalities of the app.
- **Screenshots**: A visual aid that helps users understand what to expect.
- **Getting Started**: A step-by-step guide to set up the project locally.
- **Prerequisites and Installation**: Lists required tools and dependencies and gives instructions on how to install them.
- **Usage**: Explains how to use the app's features.
- **Troubleshooting**: Offers solutions to common problems, specifically the `Dismissible` widget issue.
- **Contributing**: Encourages others to contribute to the project.
- **License**: States the licensing terms.
- **Contact**: Provides a way to reach the project owner for questions or feedback.

You can modify the content as needed to better fit your project's specifics.
