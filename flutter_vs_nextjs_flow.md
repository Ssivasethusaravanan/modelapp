# login-flow-comparison.md

Here is the exact mapping of how a login happens, step-by-step, comparing your Flutter Architecture to the Next.js Architecture.

If we trace a user clicking the **"Login"** button, here is the journey the code takes:

### 1. The User Interface (Triggering the Action)
* **Flutter (`login_page.dart`):** The user clicks Login. Your logic says `context.read<AuthBloc>().add(LoginRequested(email, password))`.
* **Next.js (`(auth)/login/page.tsx`):** The user clicks Login. Notice we don't have a BLoC! Instead, the React form fires a simple function called `onSubmit(data)` that lives right inside the same file.

### 2. The Middleman (Processing the Request)
* **Flutter (`auth_bloc.dart`):** The BLoC catches the `LoginRequested` event, emits a loading state, and asks the Domain layer: *"Hey AuthRepository, please log this person in."*
* **Next.js (`page.tsx`):** Inside the `onSubmit` function, Next.js makes an HTTP call to its own local server route: `fetch('/api/auth/login')`.

### 3. The Contract (The Repository Interface)
* **Flutter (`auth_repository.dart`):** This is the abstract class interface telling the app what a login looks like (`Future<Either<String, LoginResponse>> login(...)`).
* **Next.js:** We skip this entirely. Next.js doesn't enforce strict Clean Architecture by default. There is no abstract interface; the frontend just asks the Next.js backend for data.

### 4. The Implementation (Fetching the Data)
* **Flutter (`auth_repository_impl.dart`):** This file provides the concrete code. It reaches out to the `auth_datasource` to get the raw JSON data.
* **Next.js (`app/api/auth/login/route.ts`):** This file acts as the Repository, the BLoC, and the Datasource combined into one! This is your Backend-for-Frontend (BFF). When it receives the request from the web browser, this file says *"Okay, I will securely fetch the user from the actual Cloudflare server."*

### 5. The Network Engine (Sending to the Cloudflare Backend)
* **Flutter (`auth_datasource.g.dart`):** The generated Retrofit code uses the `Dio` package to shoot the HTTP POST over the internet to Cloudflare.
* **Next.js (`route.ts`):** Inside the same `route.ts` file, Next.js uses the native Node package `fetch()` to shoot the HTTP POST over the internet to Cloudflare.

### 6. Saving the Secure Token
* **Flutter (`auth_repository_impl.dart`):** Cloudflare replies with the JWT. Your repository takes that JWT and tells `FlutterSecureStorage` to encrypt it and save it on the phone.
* **Next.js (`route.ts`):** Cloudflare replies with the JWT. Next.js grabs the token and uses `res.cookies.set('access_token', token, { httpOnly: true })`. This forces the user's web browser to lock the token in a vault that JavaScript cannot touch (preventing hackers).

### 7. Success & Navigation
* **Flutter (`auth_bloc.dart` -> `app_router.dart`):** The BLoC finally emits `AuthAuthenticated()`. The `GoRouter` is secretly listening to the BLoC, hears the change, and automatically forces the screen to go to `/` (Home).
* **Next.js (`page.tsx` -> `middleware.ts`):** The `route.ts` tells the browser "Success!". The browser code runs `router.push('/')`. As the browser tries to load `/`, the Next.js `middleware.ts` acts as a guard, sees that the locked cookie exists, and allows the dashboard to load!

---

### The Big Difference
In your Flutter app, you separated the logic into 7 distinct layers/files (`Page` -> `BLoC` -> `Repo` -> `RepoImpl` -> `DataSource` -> `DataSource.g` -> `Dio`) to keep things extremely organized and testable.

In Next.js, web developers prefer a "flatter" approach. That entire 7-file journey is mostly contained in just two files:

1. **`login/page.tsx`** (The UI and the trigger).
2. **`api/auth/login/route.ts`** (The logic, the network call, the token storage vault).
