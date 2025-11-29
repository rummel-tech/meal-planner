# Meal Planner - Application Context

## Overview

The Meal Planner application uses a centralized context configuration system to manage application-wide settings, API configuration, and feature flags.

## Application Context

### Core Configuration

Located in: `frontend/packages/meals_ui/lib/services/app_context.dart`

```dart
class AppContext {
  static const String appName = 'Meal Planner';
  static const String appVersion = '0.1.0';
  static const String contextPath = 'meal-planner';
  static const String apiContextPath = '/meal-planner';
}
```

### Key Components

#### 1. Application Metadata
- **App Name**: Meal Planner
- **Version**: 0.1.0
- **Context Path**: `meal-planner`
- **API Context**: `/meal-planner`
- **Description**: Your personalized nutrition guide

#### 2. API Configuration
```dart
// Development
static const String defaultApiHost = 'localhost';
static const int defaultApiPort = 8010;

// API Base URL
static String get apiBaseUrl => 'http://localhost:8010/meal-planner';
```

#### 3. Feature Flags
- **Dark Mode**: Enabled
- **Offline Mode**: Disabled
- **Analytics**: Disabled

## AppContextProvider

The `AppContextProvider` is an InheritedWidget that makes the context available throughout the widget tree.

### Usage in main.dart

```dart
void main() {
  runApp(const MealsApp());
}

class MealsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppContextProvider(
      environment: 'development',
      child: MaterialApp(
        title: AppContext.appName,
        // ... rest of app
      ),
    );
  }
}
```

### Accessing Context in Widgets

#### Method 1: Using the Provider
```dart
final provider = AppContextProvider.of(context);
final apiUrl = provider?.apiUrl;
final isDev = provider?.isDevelopment;
```

#### Method 2: Using Extension Methods
```dart
final apiUrl = context.apiUrl;
final isDev = context.isDevelopment;
final isProd = context.isProduction;
```

#### Method 3: Using Static Constants
```dart
final appName = AppContext.appName;
final version = AppContext.appVersion;
```

## Environment Configuration

### Development
```dart
AppContextProvider(
  environment: 'development',
  customApiUrl: 'http://localhost:8010/meal-planner',
  child: MaterialApp(...),
)
```

### Production
```dart
AppContextProvider(
  environment: 'production',
  customApiUrl: 'https://api.example.com/meal-planner',
  child: MaterialApp(...),
)
```

## API Service Integration

The `MealsApiService` automatically uses the AppContext for API configuration:

```dart
class MealsApiService {
  MealsApiService({String? baseUrl})
      : baseUrl = baseUrl ?? AppContext.apiBaseUrl;
}
```

### Custom API URL
```dart
// Use default from AppContext
final service = MealsApiService();

// Override with custom URL
final customService = MealsApiService(
  baseUrl: 'https://custom-api.com/meal-planner'
);
```

## URL Structure

### Frontend
- **Development**: http://localhost:8081
- **Production**: https://example.com/meal-planner-app

### Backend API
- **Development**: http://localhost:8010/meal-planner
- **Production**: https://api.example.com/meal-planner

### API Endpoints
All API endpoints are prefixed with the context path:
- Health: `/meal-planner/health`
- Today's Meals: `/meal-planner/meals/today/{user_id}`
- Weekly Plan: `/meal-planner/meals/weekly-plan/{user_id}`

## Context Path Benefits

1. **Multi-tenant Support**: Run multiple apps on same domain
2. **Clear Separation**: Distinct paths for different applications
3. **Reverse Proxy Friendly**: Easy nginx/Apache configuration
4. **Microservices Ready**: Each app can be deployed independently

## Feature Flags

Control application features via AppContext:

```dart
// Check if dark mode is enabled
if (AppContext.enableDarkMode) {
  // Show dark mode toggle
}

// Check if offline mode is supported
if (AppContext.enableOfflineMode) {
  // Enable offline caching
}
```

## Environment Variables

For production builds, you can inject environment-specific values:

```bash
# Build with production API
flutter build web --dart-define=API_URL=https://api.example.com/meal-planner
```

```dart
// Access in code
const apiUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'http://localhost:8010/meal-planner',
);
```

## Integration with Other Apps

The Meal Planner context is designed to work alongside other applications:

### Workout Planner
- Context: `/workout-planner`
- Frontend: Port 8080
- Backend: Port 8000

### Meal Planner
- Context: `/meal-planner`
- Frontend: Port 8081
- Backend: Port 8010

### Vehicle Manager
- Context: `/vehicle-manager`
- Frontend: Port 8082
- Backend: Port 8020

## Best Practices

1. **Always use AppContext** for application metadata
2. **Don't hardcode URLs** - use the context configuration
3. **Check feature flags** before enabling features
4. **Use environment variables** for sensitive configuration
5. **Document context changes** in this file

## Updating Context

To modify the application context:

1. Edit `app_context.dart`
2. Update version number in AppContext
3. Update this documentation
4. Test in both development and production modes
5. Deploy with new configuration

## Related Files

- `frontend/packages/meals_ui/lib/services/app_context.dart` - Core context
- `frontend/app/meals_app/lib/main.dart` - Provider setup
- `frontend/packages/meals_ui/lib/services/meals_api_service.dart` - API integration
- `backend/main.py` - Backend context configuration
