# NusaGraha Flutter App

A modern Flutter application built with Clean Architecture principles and best practices.

## 🚀 Features

- **Splash Screen**: Beautiful animated splash screen with NusaGraha branding
- **Login System**: Modern login interface with form validation
- **Clean Architecture**: Well-structured code following Flutter best practices
- **State Management**: Provider pattern for efficient state management
- **Navigation**: GoRouter for type-safe navigation
- **Responsive Design**: Modern UI that works on all screen sizes

## 🏗️ Architecture

This project follows Clean Architecture principles with the following structure:

```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App-wide constants
│   ├── routes/             # Navigation routing
│   └── di/                 # Dependency injection
├── features/               # Feature modules
│   ├── auth/              # Authentication feature
│   │   ├── domain/        # Business logic & entities
│   │   ├── data/          # Data layer & repositories
│   │   └── presentation/  # UI & state management
│   ├── splash/            # Splash screen feature
│   └── home/              # Home screen feature
└── main.dart              # App entry point
```

## 🎨 Design System

### Colors
- **Primary Blue**: #2196F3 (Nusa brand color)
- **Primary Green**: #4CAF50 (Graha brand color)
- **Background**: #FFFFFF (Pure white)
- **Surface**: #F5F5F5 (Light gray)

### Typography
- **H1**: 32px, Bold
- **H2**: 24px, Semi-bold
- **H3**: 20px, Semi-bold
- **Body**: 16px, Regular
- **Caption**: 14px, Regular

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.0 or higher)
- Dart SDK
- Android Studio / VS Code

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd nusagraha
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 🔐 Login Credentials

For demo purposes, use these credentials:
- **Username**: `admin`
- **Password**: `123456`

## 📱 Screenshots

### Splash Screen
- Animated logo entrance
- Gradient text effects
- Smooth transitions

### Login Screen
- Clean form design
- Input validation
- Remember me functionality
- Forgot password link

### Home Screen
- User information display
- Logout functionality
- Modern card-based layout

## 🛠️ Dependencies

- **provider**: State management
- **go_router**: Navigation
- **shared_preferences**: Local storage
- **http**: HTTP client
- **form_validator**: Form validation

## 🎯 Best Practices Implemented

1. **Clean Architecture**: Separation of concerns
2. **SOLID Principles**: Single responsibility, dependency inversion
3. **Provider Pattern**: Efficient state management
4. **Custom Widgets**: Reusable UI components
5. **Constants Management**: Centralized styling
6. **Error Handling**: Proper exception management
7. **Form Validation**: Client-side validation
8. **Responsive Design**: Mobile-first approach

## 🔧 Customization

### Colors
Edit `lib/core/constants/app_colors.dart` to change the app's color scheme.

### Text Styles
Modify `lib/core/constants/app_text_styles.dart` to adjust typography.

### Sizes
Update `lib/core/constants/app_sizes.dart` to change spacing and dimensions.

## 📁 Project Structure Details

### Core Layer
- **Constants**: App-wide styling and configuration
- **Routes**: Navigation configuration
- **DI**: Dependency injection setup

### Feature Layer
Each feature follows the same structure:
- **Domain**: Business logic, entities, use cases
- **Data**: Repositories, data sources
- **Presentation**: UI, state management, providers

### Widgets
- **CustomTextField**: Reusable input field
- **CustomButton**: Reusable button component

## 🚀 Future Enhancements

- [ ] User registration
- [ ] Password reset functionality
- [ ] Biometric authentication
- [ ] Dark mode support
- [ ] Multi-language support
- [ ] Offline functionality
- [ ] Push notifications

## 🤝 Contributing

1. Fork the project
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 👨‍💻 Author

NusaGraha Development Team

---

**Note**: This is a demo application showcasing Flutter best practices and clean architecture principles.
