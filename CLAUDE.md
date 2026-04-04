# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Project Overview

**Meal Planner** — Weekly meal planning with nutrition tracking and calorie management

| Path | Contents |
|------|----------|
| `~/_Projects/meal-planner` | This repo — Flutter app + meal-planner assets |
| `~/_Projects/services/meal-planner` | FastAPI backend |
| `~/_Projects/services/common` | Shared Python infrastructure |
| `~/_Projects/resources` | Platform contract + design assets |

## ⚠️ Documentation Rules

Do NOT create session/fix files in the repo root.
Put context in commit messages and update `CHANGELOG.md` instead.

**Never create:** `SESSION_SUMMARY.md`, `*_FIX.md`, `*_UPDATE.md`, one-off `*_SETUP.md` files.

**Do instead:** commit message + `CHANGELOG.md` entry + permanent content in `docs/`.

## Quick Start

Backend: `http://localhost:8010` | API docs: `http://localhost:8010/docs`

```bash
# Backend
cd ~/_Projects/services/meal-planner
source .venv/bin/activate
uvicorn main:app --reload --port 8010

# Frontend
flutter pub get
flutter run -d chrome
```

## Artemis Integration

This app implements the Artemis Module Contract.
See: `rummel-tech/resources/ARTEMIS_MODULE_CONTRACT.md`

Required endpoints (not yet implemented — coming in next sprint):
- `GET /artemis/manifest`
- `GET /artemis/widgets/{widget_id}`
- `POST /artemis/agent/{tool_id}`
- `GET /artemis/data/{data_id}`

## Deployment

```bash
gh workflow run deploy-meal-planner-frontend.yml --repo <your-org>/infrastructure
gh workflow run deploy-meal-planner-backend.yml  --repo <your-org>/infrastructure
```
