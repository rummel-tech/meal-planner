# Meal Planner

Weekly meal planning application with FastAPI backend and Flutter web frontend.

## 🚀 Features

- **Weekly Meal Plans**: View complete 7-day meal plans
- **Today's Meals**: Quick access to today's meals with nutritional totals
- **Nutritional Tracking**: Calories, protein, carbs, and fat tracking
- **Responsive UI**: Beautiful Flutter web interface
- **REST API**: FastAPI backend with automatic documentation

## 📁 Project Structure

```
meal-planner/
├── backend/                  # FastAPI backend
│   ├── main.py              # API endpoints
│   ├── requirements.txt     # Python dependencies
│   └── Dockerfile           # Container configuration
├── frontend/                 # Flutter frontend
│   ├── app/meals_app/       # Main Flutter application
│   └── packages/meals_ui/   # Reusable UI components
└── .github/workflows/       # CI/CD workflows
    ├── deploy-frontend.yml  # GitHub Pages deployment
    └── deploy-backend.yml   # AWS ECS deployment
```

## 🏃 Quick Start

### Backend Development

```bash
cd backend
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8010
```

Visit: http://localhost:8010/docs

### Frontend Development

```bash
cd frontend/app/meals_app
flutter pub get
flutter run -d chrome
```

### Docker

```bash
cd backend
docker build -t meal-planner:local .
docker run -p 8010:8000 meal-planner:local
```

## 📡 API Endpoints

- `GET /health` - Health check probe
- `GET /ready` - Readiness probe
- `GET /meals/weekly-plan/{user_id}` - Get weekly meal plan
- `GET /meals/today/{user_id}` - Get today's meals (optional date param)

### Example Usage

```bash
# Get weekly plan
curl http://localhost:8010/meals/weekly-plan/user-123

# Get today's meals
curl http://localhost:8010/meals/today/user-123

# Get meals for specific date
curl http://localhost:8010/meals/today/user-123?date=2025-11-20
```

## 🚢 Deployment

### Prerequisites

**GitHub Secrets** (for automated deployment):
- `AWS_ROLE_TO_ASSUME` - AWS IAM role ARN for OIDC authentication

**GitHub Pages** (for frontend):
1. Go to Settings → Pages
2. Source: Deploy from a branch
3. Branch: `gh-pages` (created automatically)

### Automatic Deployment

Push to `main` branch triggers automatic deployment:

```bash
git add .
git commit -m "Update meal planner"
git push origin main
```

**Backend**: Builds Docker image and pushes to AWS ECR
**Frontend**: Builds Flutter web app and deploys to GitHub Pages

### Manual Deployment

Trigger via GitHub Actions UI:
1. Go to **Actions** tab
2. Select workflow (Frontend or Backend)
3. Click **Run workflow**

### Access URLs

After deployment:
- **Frontend**: https://srummel.github.io/meal-planner/
- **Backend API**: http://<ECS_IP>:8000/docs

## 🔧 Configuration

### Update API URL

For production, update the backend URL in:

**File**: `frontend/packages/meals_ui/lib/services/meals_api_service.dart`

```dart
MealsApiService({this.baseUrl = 'https://api.yourdomain.com'});
```

### CORS Configuration

The backend allows all origins by default. For production, update in `backend/main.py`:

```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://srummel.github.io"],  # Specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

## 🏗️ Architecture

**Backend**: FastAPI (Python 3.11)
- RESTful API design
- Automatic OpenAPI/Swagger documentation
- Docker containerization
- AWS ECS deployment

**Frontend**: Flutter Web
- Material Design 3
- Responsive layouts
- Component-based architecture
- GitHub Pages hosting

## 📦 Dependencies

### Backend
```
fastapi==0.110.0
uvicorn[standard]==0.27.1
pydantic==2.6.1
```

### Frontend
```
Flutter SDK: >=2.17.0 <3.0.0
Dependencies:
  - http: ^1.1.0
  - shared_preferences: ^2.2.2
```

## 🧪 Testing

### Backend Tests
```bash
cd backend
pytest test_health.py
```

### Frontend Tests
```bash
cd frontend/app/meals_app
flutter test
```

## 📝 Development Workflow

1. **Create feature branch**
   ```bash
   git checkout -b feature/my-feature
   ```

2. **Make changes and test locally**
   ```bash
   # Backend
   uvicorn backend.main:app --reload

   # Frontend
   flutter run -d chrome
   ```

3. **Commit and push**
   ```bash
   git add .
   git commit -m "Add my feature"
   git push origin feature/my-feature
   ```

4. **Create Pull Request**
5. **Merge to main** (triggers auto-deployment)

## 🔐 Security

- Backend uses CORS middleware for cross-origin protection
- Secrets stored in GitHub Secrets (never in code)
- AWS authentication via OIDC (no static credentials)
- Container image scanning enabled in ECR

## 🎯 Roadmap

- [ ] User authentication (JWT)
- [ ] Persistent storage (PostgreSQL)
- [ ] Meal customization and editing
- [ ] Shopping list generation
- [ ] Nutritional goals and tracking
- [ ] Recipe database integration
- [ ] Mobile app (iOS/Android)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

MIT License - See LICENSE file for details

## 🆘 Support

- **Issues**: https://github.com/srummel/meal-planner/issues
- **Discussions**: https://github.com/srummel/meal-planner/discussions

## 🔗 Related Projects

- **Workout Planner**: AI-powered fitness coaching platform
  - Repository: https://github.com/srummel/workout-planner

## 📚 Platform Documentation

- **[Central Documentation](https://github.com/srummel/documentation)** - Platform-wide patterns and guides
- **[Multi-App Architecture](https://github.com/srummel/documentation/blob/main/architecture/multi-app-architecture.md)** - How all apps work together
- **[Port Allocation](https://github.com/srummel/documentation/blob/main/references/port-allocation.md)** - Port allocation strategy
- **[Deployment Guides](https://github.com/srummel/documentation/blob/main/deployment/)** - Production deployment

---

Made with ❤️ by Shawn Rummel
