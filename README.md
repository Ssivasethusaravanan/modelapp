<![CDATA[# 🚀 TeamFlow | Modern Team Management Platform

> A premium, enterprise-grade team management platform built with **Flutter** (Mobile) and **Next.js 15** (Web), connected to a unified **Cloudflare Workers** backend.

Both frontends share a consistent **"Midnight Amethyst"** design system featuring glassmorphism effects, smooth animations, and a dark-mode-first aesthetic.

---

## 📑 Table of Contents

- [Project Overview](#-project-overview)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Project Creation (From Scratch)](#-project-creation-from-scratch)
- [Getting Started](#-getting-started)
  - [Flutter App Setup](#-flutter-mobile-app)
  - [Next.js Web App Setup](#-nextjs-web-app)
- [Architecture Deep Dive](#-architecture-deep-dive)
  - [Flutter Architecture](#flutter-clean-architecture)
  - [Next.js Architecture](#nextjs-bff-architecture)
  - [Flutter vs Next.js Flow Comparison](#-flutter-vs-nextjs-flow-comparison)
- [Authentication Flow](#-authentication-flow)
- [Available Commands](#-available-commands)
- [Testing](#-testing)
- [Environment Variables](#-environment-variables)
- [Deployment](#-deployment)
- [Dependencies](#-dependencies)

---

## 🌟 Project Overview

TeamFlow provides a secure dashboard for managing teams, members, and organizational data. The platform consists of:

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Mobile App** | Flutter (Dart) | Native Android/iOS/Windows/Web client |
| **Web App** | Next.js 15 (TypeScript) | Server-rendered web client with BFF security |
| **Backend API** | Cloudflare Workers + D1 | REST API with JWT authentication |
| **Database** | Cloudflare D1 (SQLite) | Persistent user and team data storage |

### Key Features
- 🔐 **Secure Authentication** — JWT-based login/register with encrypted token storage
- 🎨 **Midnight Amethyst Design** — Premium dark UI with purple/violet accent gradients
- 📱 **Cross-Platform** — One codebase for Mobile (Flutter), one for Web (Next.js)
- 🧪 **100% Test Coverage Target** — Unit, Widget, Integration, and E2E tests
- 🛡️ **Enterprise Security** — httpOnly cookies (Web), FlutterSecureStorage (Mobile)

---

## 🛠 Tech Stack

### Flutter (Mobile)
| Category | Package | Purpose |
|----------|---------|---------|
| State Management | `flutter_bloc` / `bloc` | Reactive state via BLoC pattern |
| Dependency Injection | `get_it` / `injectable` | Service locator + code generation |
| Navigation | `go_router` | Declarative routing with guards |
| Networking | `dio` / `retrofit` | Type-safe HTTP client with code generation |
| Local Storage | `flutter_secure_storage` | Encrypted JWT storage on device |
| UI/Animations | `glassmorphism` / `animate_do` | Premium glassmorphism + entrance animations |
| Serialization | `freezed` / `json_serializable` | Immutable models + JSON parsing |
| Error Handling | `dartz` | Functional `Either<Failure, Success>` types |

### Next.js (Web)
| Category | Package | Purpose |
|----------|---------|---------|
| Framework | `next` 15.0.0 | React Server Components + App Router |
| Styling | `tailwindcss` | Utility-first CSS with custom theme tokens |
| State Management | `zustand` | Lightweight client-side state store |
| Data Fetching | `@tanstack/react-query` | Cache-aware server state management |
| Form Validation | `zod` / `react-hook-form` | Schema-based validation with React integration |
| Icons | `lucide-react` | Consistent SVG icon library |
| Testing (Unit) | `vitest` / `@testing-library/react` | Fast unit & component tests |
| Testing (E2E) | `@playwright/test` | Real browser automation testing |

---

## 📂 Project Structure

```
teammanagementfrontend/
│
│── ─── ─── ─── ─── ─── ─── FLUTTER APP ─── ─── ─── ─── ─── ─── ───
│
├── lib/
│   ├── main.dart                          # 🚪 App entry point
│   ├── app.dart                           # 🏠 MaterialApp + BLoC providers + router
│   ├── injection.dart                     # 💉 GetIt dependency injection setup
│   ├── injection.config.dart              # 💉 Auto-generated DI configuration
│   │
│   ├── core/
│   │   ├── bloc/
│   │   │   └── app_bloc_observer.dart     # 📊 Global BLoC event/state logger
│   │   ├── network/
│   │   │   └── api_client.dart            # 🌐 Retrofit API interface definition
│   │   ├── storage/
│   │   │   └── secure_storage.dart        # 🔒 FlutterSecureStorage wrapper
│   │   └── theme/
│   │       └── app_theme.dart             # 🎨 Midnight Amethyst color palette
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── auth_datasource.dart    # 📡 Retrofit API endpoint definitions
│   │   │   │   │   └── auth_datasource.g.dart  # 📡 Auto-generated HTTP implementation
│   │   │   │   ├── models/
│   │   │   │   │   └── auth_models.dart        # 📦 Request/Response data classes
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository_impl.dart # 🔧 Concrete repository implementation
│   │   │   ├── domain/
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository.dart     # 📜 Abstract repository contract
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   └── auth_bloc.dart           # 🧠 Auth state machine (events → states)
│   │   │       └── pages/
│   │   │           ├── login_page.dart          # 📱 Login screen UI
│   │   │           └── register_page.dart       # 📱 Register screen UI
│   │   │
│   │   └── home/
│   │       └── presentation/
│   │           ├── bloc/
│   │           │   └── home_bloc.dart           # 🧠 Home/Dashboard state machine
│   │           └── pages/
│   │               └── home_page.dart           # 📱 Dashboard screen UI
│   │
│   └── routing/
│       └── app_router.dart                # 🗺️ GoRouter config + auth redirect guards
│
├── test/                                  # 🧪 Unit & Widget tests
│   ├── widget_test.dart
│   ├── injection_test.dart
│   ├── app_integration_test.dart          # 🧪 Headless integration test
│   ├── core/                              # 🧪 Core layer tests
│   ├── features/                          # 🧪 Feature layer tests
│   └── routing/                           # 🧪 Router tests
│
├── integration_test/                      # 🤖 Physical device E2E tests
│   └── app_test.dart
│
├── pubspec.yaml                           # 📋 Flutter dependencies & config
│
│── ─── ─── ─── ─── ─── ─── NEXT.JS WEB APP ─── ─── ─── ─── ─── ───
│
├── next/
│   ├── package.json                       # 📋 Node.js dependencies & scripts
│   ├── next.config.ts                     # ⚙️ Next.js server configuration
│   ├── tailwind.config.ts                 # 🎨 Midnight Amethyst Tailwind theme
│   ├── postcss.config.js                  # ⚙️ CSS processing pipeline
│   ├── tsconfig.json                      # ⚙️ TypeScript compiler configuration
│   ├── vitest.config.ts                   # 🧪 Vitest test runner configuration
│   ├── playwright.config.ts               # 🤖 Playwright E2E test configuration
│   │
│   └── src/
│       ├── middleware.ts                   # 🛡️ Edge middleware (auth guard / route protection)
│       │
│       ├── app/
│       │   ├── layout.tsx                 # 🏠 Root HTML layout (like MaterialApp)
│       │   ├── globals.css                # 🎨 Global CSS + Tailwind directives
│       │   │
│       │   ├── (auth)/                    # 🔓 Auth route group (public pages)
│       │   │   ├── login/
│       │   │   │   └── page.tsx           # 📱 Login page UI + form logic
│       │   │   └── register/
│       │   │       └── page.tsx           # 📱 Register page UI + form logic
│       │   │
│       │   ├── (dashboard)/               # 🔒 Dashboard route group (protected pages)
│       │   │   ├── layout.tsx             # 🖼️ Dashboard layout with Sidebar
│       │   │   └── page.tsx               # 📱 Home dashboard page
│       │   │
│       │   └── api/                       # 🔌 Backend-for-Frontend (BFF) API routes
│       │       ├── auth/
│       │       │   ├── login/route.ts     # 🔐 POST /api/auth/login (sets httpOnly cookie)
│       │       │   ├── register/route.ts  # 🔐 POST /api/auth/register
│       │       │   └── logout/route.ts    # 🔐 POST /api/auth/logout (clears cookie)
│       │       └── proxy/
│       │           └── [...path]/route.ts # 🔀 Catch-all proxy to Cloudflare backend
│       │
│       ├── components/
│       │   └── layout/
│       │       └── sidebar.tsx            # 🧩 Reusable Sidebar navigation component
│       │
│       └── lib/
│           ├── api-client.ts              # 🌐 Unified fetch client (server & client modes)
│           ├── utils.ts                   # 🔧 Tailwind class merger utility (cn)
│           └── utils.test.ts              # 🧪 Unit tests for utilities
│
│   └── e2e/                               # 🤖 Playwright browser E2E tests
│       └── auth.spec.ts
│
│── ─── ─── ─── ─── ─── ─── SHARED FILES ─── ─── ─── ─── ─── ─── ──
│
├── flutter_vs_nextjs_flow.md              # 📚 Developer guide: Flutter vs Next.js mapping
├── .gitignore                             # 🚫 Git ignore rules for both platforms
└── README.md                              # 📖 This file
```

---

## 🏁 Project Creation (From Scratch)

If you want to recreate this project from a completely blank state, follow these steps:

### Step 1: Create the Flutter App
```bash
# Generate the Flutter project skeleton
flutter create --org com.teamflow teammanagementfrontend
cd teammanagementfrontend

# Add all required dependencies
flutter pub add flutter_bloc bloc equatable get_it injectable go_router
flutter pub add dio retrofit connectivity_plus
flutter pub add flutter_secure_storage shared_preferences sqflite hive_flutter
flutter pub add flutter_svg cached_network_image shimmer google_fonts glassmorphism animate_do
flutter pub add freezed_annotation json_annotation dartz logger
flutter pub add intl reactive_forms

# Add dev dependencies (code generators & testing)
flutter pub add --dev build_runner freezed json_serializable retrofit_generator
flutter pub add --dev injectable_generator bloc_test mocktail coverage very_good_analysis

# Download everything
flutter pub get
```

### Step 2: Create the Next.js App (inside the same repo)
```bash
# Navigate to the project root
cd teammanagementfrontend

# Create the Next.js app inside a 'next' subfolder
mkdir next && cd next

# Generate the Next.js 15 project with TypeScript, Tailwind, ESLint, App Router
npx -y create-next-app@15.0.0 . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"

# Install additional production dependencies
pnpm add lucide-react zustand @tanstack/react-query clsx tailwind-merge
pnpm add class-variance-authority zod react-hook-form @hookform/resolvers

# Install additional dev dependencies (testing)
pnpm add -D vitest @vitejs/plugin-react jsdom @testing-library/react
pnpm add -D @vitest/coverage-v8 @playwright/test

# Download Playwright browser engines (Edge only for local dev)
npx playwright install chromium
```

### Step 3: Generate Flutter Code
```bash
# Go back to root
cd ..

# Run the code generator for Retrofit, Injectable, Freezed, and JSON Serializable
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🏃 Getting Started

### Prerequisites
Ensure the following tools are installed on your machine:

| Tool | Version | Installation |
|------|---------|-------------|
| **Flutter SDK** | `>=3.0.0 <4.0.0` | [flutter.dev/docs/get-started](https://flutter.dev/docs/get-started/install) |
| **Dart SDK** | Bundled with Flutter | Comes with Flutter |
| **Node.js** | `v18+` | [nodejs.org](https://nodejs.org) |
| **pnpm** | `v8+` | `npm install -g pnpm` |
| **Git** | Latest | [git-scm.com](https://git-scm.com) |

---

### 📱 Flutter Mobile App

**1. Clone and navigate:**
```bash
git clone <your-repo-url>
cd teammanagementfrontend
```

**2. Install Dart packages:**
```bash
flutter pub get
```

**3. Generate code (Retrofit, Injectable, Freezed, JSON):**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
> This generates `auth_datasource.g.dart`, `injection.config.dart`, and all model serializers.

**4. Run the app:**
```bash
# On an Android Emulator
flutter run

# On Windows Desktop
flutter run -d windows

# On Microsoft Edge (Web)
flutter run -d edge

# List all available devices
flutter devices
```

**5. Build a production release:**
```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# Windows Desktop
flutter build windows --release

# Web
flutter build web --release
```

**6. Analyze code for errors and warnings:**
```bash
flutter analyze
```

**7. Format all Dart code:**
```bash
dart format .
```

---

### 🌐 Next.js Web App

**1. Navigate to the web directory:**
```bash
cd next
```

**2. Install Node packages:**
```bash
pnpm install
```

**3. Start the dev server:**
```bash
pnpm dev
```
Then open your browser and go to **http://localhost:3000**.

**4. Build for production:**
```bash
pnpm build
```

**5. Start the production server locally:**
```bash
pnpm start
```

**6. Run the linter:**
```bash
pnpm lint
```

---

## 🏛 Architecture Deep Dive

### Flutter: Clean Architecture

The Flutter app follows **Clean Architecture** with three distinct layers:

```
┌─────────────────────────────────────────────┐
│              PRESENTATION LAYER             │
│  (What the user sees and interacts with)    │
│                                             │
│  Pages (login_page.dart, home_page.dart)    │
│  BLoCs  (auth_bloc.dart, home_bloc.dart)    │
│         Events → States                     │
└──────────────────┬──────────────────────────┘
                   │ calls
┌──────────────────▼──────────────────────────┐
│               DOMAIN LAYER                  │
│  (The rules / contracts of the business)    │
│                                             │
│  Repository Interfaces (auth_repository.dart)│
│  Use Cases (if applicable)                  │
│  Entity Models                              │
└──────────────────┬──────────────────────────┘
                   │ implemented by
┌──────────────────▼──────────────────────────┐
│                DATA LAYER                   │
│  (Where the data actually comes from)       │
│                                             │
│  Repository Impls (auth_repository_impl.dart)│
│  DataSources      (auth_datasource.dart)    │
│  Models           (auth_models.dart)        │
│  Generated Code   (auth_datasource.g.dart)  │
└─────────────────────────────────────────────┘
```

**Data flow:** `UI → BLoC → Repository (abstract) → RepositoryImpl → DataSource → Cloudflare API`

### Next.js: BFF Architecture

The Next.js app uses a **Backend-for-Frontend (BFF)** pattern with the App Router:

```
┌─────────────────────────────────────────────┐
│              CLIENT LAYER                   │
│  (React components in the browser)          │
│                                             │
│  Pages      (login/page.tsx, page.tsx)      │
│  Components (sidebar.tsx)                   │
│  Layouts    (layout.tsx)                    │
└──────────────────┬──────────────────────────┘
                   │ fetch('/api/...')
┌──────────────────▼──────────────────────────┐
│            BFF SERVER LAYER                 │
│  (Next.js API Routes running on the server) │
│                                             │
│  /api/auth/login/route.ts                   │
│  /api/auth/register/route.ts                │
│  /api/proxy/[...path]/route.ts              │
│  middleware.ts (Edge auth guard)            │
└──────────────────┬──────────────────────────┘
                   │ fetch(BACKEND_API_URL)
┌──────────────────▼──────────────────────────┐
│           CLOUDFLARE BACKEND                │
│  (The real database and business logic)     │
│                                             │
│  Cloudflare Workers + D1 Database           │
└─────────────────────────────────────────────┘
```

**Data flow:** `Browser → Next.js API Route (BFF) → Cloudflare API`

### Why the BFF?
The browser **never** talks to Cloudflare directly. Every request goes through the Next.js server first. This allows us to:
1. **Hide the backend URL** from the browser (no one can see it in DevTools).
2. **Inject the JWT token** securely on the server side (the browser can't read or steal it).
3. **Set httpOnly cookies** that JavaScript cannot access (XSS-proof).

---

## 🔄 Flutter vs Next.js Flow Comparison

Here is how the same **Login** action flows through both architectures:

| Step | Flutter | Next.js |
|------|---------|---------|
| **1. User clicks Login** | `context.read<AuthBloc>().add(LoginRequested(...))` | `onSubmit(data)` → `fetch('/api/auth/login')` |
| **2. Process the request** | `AuthBloc` catches event, emits `AuthLoading` | API Route `route.ts` receives POST request |
| **3. Contract / Interface** | `AuthRepository` abstract class | *(Skipped — no abstract layer)* |
| **4. Fetch from backend** | `AuthRepositoryImpl` → `AuthDatasource` | `route.ts` → `fetch(BACKEND_URL)` |
| **5. HTTP call to Cloudflare** | `auth_datasource.g.dart` (Generated Retrofit/Dio) | Native `fetch()` inside `route.ts` |
| **6. Save the JWT token** | `FlutterSecureStorage.write(key: 'token')` | `cookies.set('access_token', { httpOnly: true })` |
| **7. Navigate to Dashboard** | BLoC emits `AuthAuthenticated` → GoRouter redirects | `router.push('/')` → `middleware.ts` allows access |

> 📄 Full detailed comparison available in [`flutter_vs_nextjs_flow.md`](./flutter_vs_nextjs_flow.md)

---

## 🔐 Authentication Flow

### Flutter (Mobile)
```
User → LoginPage → AuthBloc(LoginRequested)
                        ↓
              AuthRepositoryImpl.login()
                        ↓
              AuthDatasource.login() [Retrofit + Dio]
                        ↓
              Cloudflare Workers API (POST /api/login)
                        ↓
              Receives JWT token
                        ↓
              FlutterSecureStorage.write('token', jwt)
                        ↓
              AuthBloc emits AuthAuthenticated
                        ↓
              GoRouter.refreshListenable hears it → redirects to /
```

### Next.js (Web)
```
User → LoginPage (page.tsx) → onSubmit()
                        ↓
              fetch('/api/auth/login') [Browser → BFF]
                        ↓
              route.ts → fetch(BACKEND_URL + '/api/login') [BFF → Cloudflare]
                        ↓
              Cloudflare Workers API (POST /api/login)
                        ↓
              Receives JWT token
                        ↓
              res.cookies.set('access_token', jwt, { httpOnly: true })
                        ↓
              Returns { success: true } to browser
                        ↓
              router.push('/') → middleware.ts sees cookie → allows dashboard
```

---

## 📋 Available Commands

### Flutter Commands (run from project root `/`)

| Command | Description |
|---------|-------------|
| `flutter pub get` | Install/update all Dart packages |
| `flutter pub run build_runner build --delete-conflicting-outputs` | Generate Retrofit, Injectable, Freezed, JSON code |
| `flutter pub run build_runner watch` | Auto-regenerate code on file changes |
| `flutter run` | Launch app on default device |
| `flutter run -d windows` | Launch app on Windows Desktop |
| `flutter run -d edge` | Launch app in Microsoft Edge |
| `flutter run -d chrome` | Launch app in Google Chrome |
| `flutter devices` | List all connected/available devices |
| `flutter test` | Run all unit & widget tests |
| `flutter test --coverage` | Run tests + generate coverage report |
| `flutter test test/app_integration_test.dart` | Run headless integration test |
| `flutter test integration_test/app_test.dart -d windows` | Run E2E test on Windows |
| `flutter analyze` | Static analysis for errors, warnings, lints |
| `flutter clean` | Delete build artifacts and start fresh |
| `dart format .` | Auto-format all Dart code |
| `flutter build apk --release` | Build Android APK |
| `flutter build web --release` | Build for Web deployment |

### Next.js Commands (run from `/next` directory)

| Command | Description |
|---------|-------------|
| `pnpm install` | Install all Node.js packages |
| `pnpm dev` | Start development server at localhost:3000 |
| `pnpm build` | Create optimized production build |
| `pnpm start` | Start production server locally |
| `pnpm lint` | Run ESLint to check code quality |
| `pnpm test` | Run Vitest unit tests (watch mode) |
| `pnpm test:coverage` | Run tests once + generate coverage report |
| `npx playwright test` | Run all Playwright E2E browser tests |
| `npx playwright test --ui` | Open Playwright visual test dashboard |
| `npx playwright show-report` | View last Playwright HTML test report |
| `npx playwright install` | Download browser engines for testing |
| `npx playwright install chromium` | Download only Chromium engine |

---

## 🧪 Testing

### Testing Philosophy
Both applications target **100% code coverage** using a three-tier testing strategy:

| Tier | Flutter | Next.js |
|------|---------|---------|
| **Unit Tests** | `bloc_test` + `mocktail` | `vitest` |
| **Widget/Component Tests** | `flutter_test` (WidgetTester) | `@testing-library/react` |
| **E2E / Integration Tests** | `integration_test` (physical device) | `@playwright/test` (real browser) |

### Running Flutter Tests
```bash
# Run ALL tests
flutter test

# Run a specific test file
flutter test test/features/auth/presentation/bloc/auth_bloc_test.dart

# Run tests with coverage report generation
flutter test --coverage

# Run headless integration test (no emulator needed)
flutter test test/app_integration_test.dart

# Run full E2E test on Windows Desktop
flutter test integration_test/app_test.dart -d windows
```

### Running Next.js Tests
```bash
# Navigate to the next/ directory first
cd next

# Run unit tests in watch mode (re-runs on file changes)
pnpm test

# Run tests once + see coverage percentage for every file
pnpm test:coverage

# Run Playwright E2E tests (opens real browser invisibly)
npx playwright test

# Watch Playwright tests happening visually in real-time
npx playwright test --ui

# View the beautiful HTML test report from last run
npx playwright show-report
```

### Test File Locations

| Type | Flutter Location | Next.js Location |
|------|-----------------|-------------------|
| Unit Tests | `test/features/*/` | `src/lib/*.test.ts` |
| Widget Tests | `test/features/*/presentation/` | `src/app/**/*.test.tsx` |
| Headless Integration | `test/app_integration_test.dart` | — |
| E2E (Physical Device) | `integration_test/app_test.dart` | `e2e/*.spec.ts` |

---

## 🔑 Environment Variables

### Flutter
The backend API URL is configured directly in `lib/core/network/api_client.dart`:
```dart
@RestApi(baseUrl: 'https://teammanagementbackend.projectece5566.workers.dev')
```

### Next.js
Create a `.env.local` file inside the `next/` directory:
```env
# The URL of your Cloudflare Workers backend
BACKEND_API_URL=https://teammanagementbackend.projectece5566.workers.dev

# Set to 'production' for deployed environments
NODE_ENV=development
```

> ⚠️ **Never commit `.env.local` to Git!** It is already included in `.gitignore`.

---

## 🚢 Deployment

### Flutter
```bash
# Android (APK for direct install)
flutter build apk --release

# Android (App Bundle for Google Play Store)
flutter build appbundle --release

# iOS (requires macOS + Xcode)
flutter build ipa --release

# Web (generates static files in build/web/)
flutter build web --release

# Windows Desktop
flutter build windows --release
```

### Next.js
The Next.js app is configured with `output: 'standalone'` for easy containerized deployment.

**Deploy to Vercel (Recommended):**
1. Push the `next/` folder to a GitHub repository.
2. Connect the repository to [vercel.com](https://vercel.com).
3. Set the **Root Directory** to `next`.
4. Add the `BACKEND_API_URL` environment variable in the Vercel dashboard.
5. Deploy!

**Deploy manually with Docker:**
```bash
cd next
pnpm build
node .next/standalone/server.js
```

---

## 📦 Dependencies

### Flutter (`pubspec.yaml`)
<details>
<summary>Click to expand full dependency list</summary>

**Production Dependencies:**
- `flutter_bloc` / `bloc` — BLoC state management
- `equatable` — Value equality for BLoC states/events
- `get_it` / `injectable` — Dependency injection
- `go_router` — Declarative routing
- `dio` / `retrofit` — HTTP client + code generation
- `flutter_secure_storage` — Encrypted local storage
- `shared_preferences` — Key-value local storage
- `glassmorphism` — Glassmorphism UI effects
- `animate_do` — Entrance/exit animations
- `google_fonts` — Custom typography
- `freezed_annotation` / `json_annotation` — Model code generation
- `dartz` — Functional programming (Either types)
- `firebase_core` / `firebase_messaging` — Push notifications

**Dev Dependencies:**
- `build_runner` — Code generation runner
- `freezed` / `json_serializable` / `retrofit_generator` / `injectable_generator` — Code generators
- `bloc_test` — BLoC-specific test utilities
- `mocktail` — Mock object generation
- `very_good_analysis` — Strict lint rules

</details>

### Next.js (`package.json`)
<details>
<summary>Click to expand full dependency list</summary>

**Production Dependencies:**
- `next` 15.0.0 — Framework (App Router + Server Components)
- `react` / `react-dom` 19.0.0-rc.1 — UI library
- `lucide-react` — Icon library
- `zustand` — Client-side state management
- `@tanstack/react-query` — Server state + caching
- `zod` — Schema validation
- `react-hook-form` / `@hookform/resolvers` — Form management
- `clsx` / `tailwind-merge` / `class-variance-authority` — Styling utilities

**Dev Dependencies:**
- `typescript` — Type safety
- `tailwindcss` / `postcss` / `autoprefixer` — CSS pipeline
- `eslint` / `eslint-config-next` — Code quality
- `vitest` / `@testing-library/react` / `jsdom` — Unit testing
- `@vitest/coverage-v8` — Code coverage
- `@playwright/test` — E2E browser testing

</details>

---

## 📄 License
This project is private and not published to any package registry.

---

<p align="center">
  Built with ❤️ using Flutter & Next.js<br/>
  <strong>Midnight Amethyst Design System</strong>
</p>
]]>