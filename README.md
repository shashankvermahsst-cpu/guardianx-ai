# GuardianX AI - Parental Control Platform

> **Tagline**: *"Protect. Monitor. Guide."*
> **Version**: 1.0.0 (Production-Ready Release)

GuardianX AI is a modern, enterprise-grade, scalable parental safety and child protection ecosystem similar to FlashGet Kids, Google Family Link, AirDroid Parental Control, and KidsGuard Pro.

---

## 🌟 Platform Components Overview

| Component | Technology | Description |
|---|---|---|
| **Parent App** | Flutter 3.x, Riverpod 2.x, Material 3 | Full-featured parent dashboard with live map, screen mirror UI, camera/audio controls, AI chat assistant, app blocker & subscriptions. |
| **Child Service App** | Flutter / Android Native Services | Stealth background telemetry collector, anti-tamper guard, location & app lock overlay handler. |
| **Backend Engine** | Node.js, Express, Socket.IO, PostgreSQL | Real-time WebSocket streaming server, REST API suite, AES-256 cipher, FCM dispatcher. |
| **AI Engine** | Custom Heuristic + LLM Assistant | Screen addiction analyzer, sleep habit calculator, risk scoring (0-100), natural language parent queries. |
| **Admin Dashboard** | HTML5, CSS3 Glassmorphism, JS | Super admin panel for user metrics, MRR analytics, security alerts, and system toggles. |
| **Website Landing Page** | HTML5, CSS3, JS | High-converting marketing landing page featuring interactive web live parent app simulator. |

---

## 🚀 Quick Setup & Run Instructions

### 1. Backend Server (Node.js + Socket.IO)

```bash
cd backend
npm install
npm run dev
# Server running at http://localhost:4000
```

### 2. Database Migration (PostgreSQL)

Import `backend/db/schema.sql` into your PostgreSQL instance:
```bash
psql -U postgres -d guardianx_db -f backend/db/schema.sql
```

### 3. Parent App (Flutter)

```bash
cd parent_app
flutter pub get
flutter run
```

### 4. Child App (Flutter / Android Stealth)

```bash
cd child_app
flutter pub get
flutter run
```

---

## 🛡️ Google Play Store Publishing & Readiness Checklist

To publish **GuardianX AI Child App** on Google Play Store, comply with Google's Parental Control & Accessibility Policies:

1. **Prominent Disclosure & Consent**:
   - The app displays a mandatory parent pairing screen explaining location, camera, and screen mirroring access before enabling background tracking.
2. **Accessibility Service Declaration**:
   - `BIND_ACCESSIBILITY_SERVICE` is used strictly for locking blocked applications (TikTok, YouTube, Games) requested by parents.
3. **Device Admin & Anti-Uninstall Policy**:
   - Uses `DeviceAdminReceiver` to prevent unauthorized child uninstallation without parental verification.
4. **Data Safety Form**:
   - End-to-End Encryption (AES-256) declared for live screen frames and audio packets. Data is never sold to third parties.

---

## 📁 Repository Structure

```
d:/timepassproject/trakingapp/
├── backend/
│   ├── db/schema.sql
│   ├── src/
│   │   ├── config/
│   │   ├── controllers/
│   │   ├── middleware/
│   │   ├── routes/
│   │   ├── services/
│   │   └── server.js
│   └── package.json
├── parent_app/
│   ├── lib/
│   │   ├── core/theme.dart
│   │   ├── models/models.dart
│   │   ├── providers/app_providers.dart
│   │   ├── services/api_service.dart
│   │   ├── views/
│   │   └── main.dart
│   └── pubspec.yaml
├── child_app/
│   ├── lib/
│   │   ├── services/
│   │   └── main.dart
│   ├── android/app/src/main/AndroidManifest.xml
│   └── pubspec.yaml
├── admin_dashboard/
│   ├── index.html
│   ├── styles.css
│   └── app.js
├── landing_page/
│   ├── index.html
│   ├── styles.css
│   └── script.js
└── README.md
```
