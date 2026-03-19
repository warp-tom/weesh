# 🧞 Weesh: Your Wish, My Command

![CodeRabbit Pull Request Reviews](https://img.shields.io/coderabbit/prs/github/warp-tom/weesh?utm_source=oss&utm_medium=github&utm_campaign=warp-tom%2Fweesh&labelColor=171717&color=FF570A&link=https%3A%2F%2Fcoderabbit.ai&label=CodeRabbit+Reviews)

**Author:** Oliver (Neon)\
**Status:** Active Development (Antigravity IDE / Agent-Driven)\
**Platform:** Flutter 3.41 (iOS/Android) & Vite.js Web (Admin Dashboard)

---

## 📖 Project Overview

**Weesh** is a highly immersive, multi-service platform engineered specifically
to solve the unique logistical challenges of the Philippine provinces. Designed
with a "Genie" philosophy—where every user request is treated as a wish waiting
to be granted—Weesh combines ride-sharing (tricycles/cars), peer-to-peer parcel
delivery, and local grocery shopping into one unified Super App.

Moving beyond standard city-centric apps, Weesh brings a touch of magic to daily
logistics, built entirely on a foundation of extreme offline resilience,
hyper-local community trust, and stunning, tactile design.

---

## 🚀 Key Innovations & Real-World Solutions

- **Offline-First Resilience (Isar Cache):** Provincial internet drops
  frequently, especially on rural routes. Weesh utilizes an Isar local database
  so that if a driver loses their 5G/4G signal, the app continues to function
  flawlessly, caching their active "Weesh" state and seamlessly syncing to the
  Supabase server the moment the connection returns.
- **Hyper-Local Routing via Mapbox:** Standard maps fail at tricycle routing. We
  utilize Mapbox to map custom routing profiles, allowing local drivers to
  crowdsource and navigate unmapped alleyways safely.
- **The "Bayanihan" Trust System:** We replace the standard, sterile 5-star
  rating with tag-based social proof (e.g., _"Maingat magmaneho"_ - Safe
  Driver). Parcel deliveries require a mandatory "Selfie with Receiver" for
  undisputed, friendly proof of delivery.
- **Low-Signal Auth Fallback:** Because SMS OTPs often fail in remote provinces,
  Weesh utilizes a fallback onboarding mechanism via WhatsApp and Facebook
  Messenger.

---

## 🎨 Design Philosophy: The Anti-Minimalist "Genie"

**Core Constraint: The UI must not be too minimalist.** Weesh utilizes a rich,
heavily layered **Material 3 Expressive** design system to create a premium,
tactile, and magical user experience.

- **Color Palette:** `oklch` Primary Jungle Green (`#006C4C`), Secondary
  Tricycle Yellow (`#FFB300`), and a Mystic Purple Accent (`#7B1FA2`) for
  magical CTA states.
- **Tactile UI & Glassmorphism:** We utilize deep drop shadows, asymmetrical
  bottom sheet radii, translucent Apple-style frosted glass overlays on active
  maps, and fluid spring-physics for all state changes.
- **Magical Micro-interactions:** Powered by `flutter_animate` and Lottie,
  actions like "Granting a Weesh" trigger fluid, genie-like transitions rather
  than rigid screen cuts.

---

## 🛠️ Tech Stack Architecture

### Mobile Applications (User & Driver)

- **Framework:** Flutter 3.41 (Impeller Engine)
- **Language:** Dart 3.10+
- **State Management:** Riverpod 2.5+
- **Local Cache / Offline DB:** Isar `^3.1.0`
- **Maps & Routing:** Mapbox + Geolocator
- **UI / Animations:** `velocity_x`, `flutter_animate`, `hugeicons`

### Admin Nerve Center (Web)

- **Framework:** Vite.js + React
- **Styling:** Tailwind CSS v4 (CSS-first `@theme` config, oklch colors)
- **UI Components:** `shadcn/ui` (Preset: `awPxsmG`)
- **Features:** Live PostGIS dispatch heatmap, God-mode override dispatch,
  1-click verification queue.

### Backend

- **Database:** Supabase (PostgreSQL)
- **Spatial Queries:** PostGIS Extension (Critical for radius-based tricycle
  dispatching)
- **Real-time:** Supabase WebSockets (Realtime)

---

## 📂 Feature-First Directory Structure (Flutter)

To prevent architectural spaghetti across 50+ screens, we strictly enforce
Domain-Driven Design:

```text
lib/
 ├── core/                  # Global assets, M3 Expressive Tokens, Isar Sync Engine
 ├── features/              # Isolated Feature Modules
 │    ├── auth/             # Messenger fallback, Profile setup
 │    ├── weesh_ride/       # Tricycle routing, Mapbox overlays
 │    ├── weesh_parcel/     # Camera logic, Proof of Delivery
 │    ├── weesh_grocery/    # Store catalog, Cart management
 │    └── driver_active/    # Real-time radar alerts, offline-first state
 └── main.dart              # Riverpod ProviderScope
```
