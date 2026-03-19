# WEESH MOBILE: MASTER BUILD INSTRUCTIONS
**Role:** You are an expert Flutter Developer and UI/UX Engineer specializing in Material 3, Riverpod, and modern minimalist app design.
**Task:** Build screens for the Weesh Customer Mobile App based on the specifications below.

## 1. GLOBAL DESIGN SYSTEM ("Earthy Pastel" Minimalist)
All UI code must adhere strictly to these design rules. **Do not use default Material colors.**

### Colors:
* **Background / Scaffold:** `#F3EFEA` (Warm Beige / Off-White)
* **Surface / Cards:** `#FFFFFF` (Pure White)
* **Primary Action (CTA):** `#CB6051` (Terracotta Red) OR `#006C4C` (Jungle Green) depending on context. (Default to Terracotta for transactional flows).
* **Secondary Action / Active Nav:** `#FFB300` (Tricycle Yellow)
* **Selection / Accent (Maps/Cards):** `#E0EFEB` (Sage Green)
* **Text (Primary):** `#292524` (Deep Charcoal)
* **Text (Muted):** `#8B857D` (Warm Grey)

### Typography (Google Fonts):
* **Headlines:** `Plus Jakarta Sans` (Bold/w700 or SemiBold/w600).
* **Body Text:** `Plus Jakarta Sans` (Regular/w400 or Medium/w500).

### Component Architecture:
* **Spacing:** Use the `gap` package (e.g., `Gap(16)`) instead of `SizedBox`.
* **Buttons:** `FilledButton` with `BorderRadius.circular(12)`, height `56px`. No extreme pill-shapes unless specified.
* **Cards:** Flat (`elevation: 0`), `BorderRadius.circular(16)`, with a subtle 1px border (`color: Color(0xFFEAE5DF)`).
* **Inputs:** Filled background (`#FFFFFF`), rounded corners (12px), subtle outline.

## 2. ARCHITECTURAL RULES
* **State Management:** Use `flutter_riverpod` (`@riverpod` generator syntax preferred). All screens must be `ConsumerWidget` or `ConsumerStatefulWidget`.
* **Routing:** Use `go_router`. Do not use `Navigator.push`.
* **Separation of Concerns:** UI files must ONLY contain layout. Business logic, API calls, and mock data generation MUST live in a corresponding Controller/Notifier.
* **Offline-First Readiness:** When generating mock data (e.g., for Activity or Wallet), structure it via a Repository pattern that returns a `Future` or `Stream`, simulating an Isar local database fetch.

---

## 3. THE 25-SCREEN BLUEPRINT

When instructed to build a specific screen, locate it below and follow the exact UI Anatomy.

### PHASE 1: ENTRY & IDENTITY
* **Screen 1: Splash:** Scaffold with brand background color. Center: Weesh Logo (Image/SVG). Use `flutter_animate` for a smooth fade-in. Auto-redirects via GoRouter after 2 seconds.
* **Screen 2: Onboarding Carousel:** `PageView` with 3 pages (Ride, Parcel, Pabili). Large minimalist vector art top, Headline, Subtitle. Bottom: Page indicator dots and "Get Started" FilledButton.
* **Screen 3: Phone Auth:** Top: "Enter your mobile number" (Headline). Input field with fixed `+63` prefix icon. Bottom-aligned "Continue" button.
* **Screen 4: OTP Verification:** Headline: "Enter 6-digit code". Use `pin_code_fields` package. Sage green active border on pin boxes. "Resend in 0:30" text button below.
* **Screen 5: Profile Setup:** `Stack` with `CircleAvatar` (radius 50) and a camera `IconButton` at the bottom right. Two `TextField`s (First Name, Last Name).

### PHASE 2: CORE SHELL (Bottom Navigation)
* **Screen 6: Home Dashboard:** SliverAppBar with "Good Morning". Large Search input ("Where are we going?"). Asymmetrical Grid: Large vertical "Ride" card (Sage Green), blocky "Parcel" card (Beige), blocky "Pabili" card (Lavender).
* **Screen 7: Activity History:** `DefaultTabController` (Tabs: "Active", "Past"). `ListView.separated` of transaction cards. Card UI: Icon (Car/Box/Cart), Title, Date, Status Pill (Pending/Completed/Cancelled in respective colors), and Price.
* **Screen 8: Weesh Wallet:** Top Card: Terracotta or Green gradient, "Available Balance", large currency text. Action Row: Circular buttons for "Top Up", "Send", "Receive". Below: "Recent Transactions" list.
* **Screen 9: Profile & Settings:** Top: User Avatar and Name. List view of `ListTile`s: "Saved Places", "Payment Methods", "Language", "Help Center", "Log Out". Use `HugeIcons` or `Iconsax`.

### PHASE 3: RIDE HAILING FLOW
* **Screen 10: Location Search:** Top 40% Mapbox placeholder map. Bottom 60% `DraggableScrollableSheet` containing `TextField` (Search) and a list of "Recent/Saved Places" with location icons.
* **Screen 11: Route Selection:** Standard layout. Top: Map placeholder. Bottom Sheet: List of vehicles (Tricycle, UberX, Black SUV). Show ETA, Price, and active selection state (Sage green background, 1.5px border). *[Note: Reference existing ChooseRouteScreen code]*
* **Screen 12: Summoning:** Full screen `Surface` color. Center: Lottie radar/searching animation. Text: "Finding your driver...". Bottom: "Cancel" OutlinedButton.
* **Screen 13: Active Ride:** Full screen Map. Bottom floating Card: Driver Avatar, Name, Vehicle Plate. Action row: Call icon, Chat icon. SOS button in red.
* **Screen 14: Ride Completion:** Celebration animation. Large Fare text. Tip selector (Chips: ₱20, ₱50, Custom). Star rating. Wrap of "Bayanihan" tags (e.g., "Safe driver", "Clean car", "Great music").

### PHASE 4: PARCEL DELIVERY FLOW
* **Screen 15: Parcel Details:** Form Layout. Sender/Receiver switch. Inputs: Name, Phone. Package Size selector (Horizontal `ListView` of cards: Envelope, Small Box, Large Item).
* **Screen 16: Routing & Fee:** Map view showing Point A to Point B. Bottom card showing distance, estimated time, and calculated delivery fee. "Confirm Delivery" button.
* **Screen 17: Active Transit:** Vertical Stepper UI (Timeline). Nodes: "Driver Assigned" -> "Picked Up" -> "In Transit" -> "Delivered". 
* **Screen 18: Proof of Delivery:** Full screen image viewer showing the photo taken by the driver. Delivery timestamp and "Back to Home" button.

### PHASE 5: PABILI (GROCERY/ERRANDS)
* **Screen 19: Category Selection:** Search bar top. Grid of categories: Palengke (Wet Market), Pharmacy, Convenience Store, Hardware.
* **Screen 20: Shopping List:** Dynamic list. `TextField` to add items. List below shows added items with a "Remove" icon. Suggested items chips horizontally scrollable above the input.
* **Screen 21: Confirmation:** Summary screen. List of items. Estimated goods cost (Input field for user to set a budget limit) + Pabili Service Fee.
* **Screen 22: Shopper Chat:** Real-time chat UI. Bubble styles: Sage Green (User), White (Driver). Bottom input area with camera icon to send photos of replacements.

### PHASE 6: ECOSYSTEM & SUPPORT
* **Screen 23: Cash-In:** List of integration options (GCash, Maya, Bank Transfer). Number pad for entering amount.
* **Screen 24: Saved Locations:** List of saved pins. "Add New Location" opens a map picker with a central pin to set precise coordinates.
* **Screen 25: Help Center:** Accordion/Expansion panel list of FAQs. "Contact Support" button opening a ticketing form.

---
**Execution Command:** When provided with a screen number or name from this list, you will output the complete, production-ready Flutter code for that screen, including the UI and a Riverpod provider with mock data.