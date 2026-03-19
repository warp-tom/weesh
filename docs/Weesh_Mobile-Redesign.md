AI AGENT INSTRUCTION MANUAL: "WEESH" SUPER APP REBUILD
Role: You are a Senior Flutter Developer and Lead UI/UX Designer.
Objective: Rebuild the "Weesh" application from scratch using Flutter and Material Design 3. The previous iteration was "broken" due to inconsistent spacing, lack of alignment, and non-adherence to a grid system. You must follow this comprehensive style guide strictly.

PHASE 1: THE DESIGN SYSTEM (Foundations)
Before building any screens, define the constants. A broken design comes from hardcoded values. Use a centralized styling system.

1.1: Color Palette (Material 3 ColorScheme)

Primary: Jungle Green (#006C4C). Use for major buttons, active navigation icons, and key headers.
Secondary: Tricycle Yellow (#FFB300). Use for highlights, badges (e.g., "Cheaper"), and secondary actions.
Tertiary: Mystic Purple (#7B1FA2). Use for premium features and "Genie" specific elements.
Background: Off-White (#F8F9FA). NEVER use pure white (#FFFFFF) for the main background to reduce eye strain.
Surface: White (#FFFFFF) with Opacity 0.9 for Cards/Bottom Sheets.
1.2: Typography (Google Fonts)

Font Family: 'Plus Jakarta Sans' (Headers), 'Roboto' (Body).
Hierarchy:
displayLarge: 32px, Bold (Screen Titles).
headlineMedium: 24px, SemiBold (Section Headers).
bodyLarge: 16px, Regular (Main Content).
labelLarge: 14px, Medium (Buttons, Inputs).
1.3: The Grid System (CRITICAL FOR FIXING BROKEN LAYOUTS)

Global Horizontal Padding: 16.0 pixels on all screens. (Never use hardcoded margins differently unless specified).
Vertical Spacing between Sections: 24.0 pixels.
Vertical Spacing between Items: 12.0 pixels.
Border Radius:
Cards: 16.0 pixels.
Buttons: 100.0 pixels (Pill shape).
Inputs: 12.0 pixels.
PHASE 2: SCREEN-BY-SCREEN BUILD INSTRUCTIONS
Execute the following build instructions sequentially.

SECTION A: ONBOARDING & AUTH
Screen 1: Splash Screen

Layout: Scaffold with backgroundColor: Off-White.
Content: Center -> Column.
Alignment: MainAxisAlignment.center.
Elements:
Image/Icon: Weesh Logo (Size: 120x120).
Text: "Your Wish, Our Wheels" (headlineMedium, color: Primary).
Spacing: 16px between logo and text.
Animation: Fade-in animation with 1-second duration.
Screen 2: Welcome / Role Selection

Layout: Column.
Padding: 24.0 all sides.
Illustration: SizedBox(height: 250, width: double.infinity). Place "Nano Banana" vector asset here (Hammock/Driver split).
Text: "Komusta! Welcome to the Province." (displayLarge). Align Left. Padding bottom: 24.0.
Buttons: Column of two SizedBox (width: double.infinity, height: 56).
Button 1: FilledButton ("I need a Ride").
Button 2: OutlinedButton ("I want to drive").
Spacing between buttons: 12.0.
Screen 3: Mobile Number Verification

AppBar: Leading: BackButton, Title: "Login".
Body Padding: 24.0 horizontal.
Illustration: Top aligned, height 200. "Banana holding phone".
Input: TextField.
decoration: InputDecoration. prefixText: "+63". labelText: "Mobile Number".
keyboardType: TextInputType.phone.
Constraint: Must have a clear focus border color (Primary).
Button: FilledButton anchored at bottom with 16.0 padding.
Screen 4: OTP Verification

Layout: Similar to Screen 3.
Text: "Enter the 4-digit code sent to +63..." (bodyLarge). Center aligned. Padding bottom: 32.0.
Input: Use pin_code_fields package or custom Row of 4 TextFields.
Box size: 60x60.
Spacing between boxes: 16.0.
Border: OutlineInputBorder with radius 12.
Resend: TextButton ("Resend Code").
Screen 5: User Profile Setup

AppBar: "Setup Profile".
Avatar: Center -> Stack.
CircleAvatar (radius: 50, background: Grey[200]).
Positioned (bottom right) -> IconButton (Camera icon, small).
Padding bottom: 32.0.
Fields: Column of TextFields (Name, Email).
Spacing between fields: 16.0.
Padding horizontal: 24.0.
SECTION B: CORE APP & NAVIGATION
Global Navigation Structure

Widget: Scaffold with bottomNavigationBar.
Nav Bar: NavigationBar.
backgroundColor: White.
height: 70.
Destinations: Home (Icon: Icons.home), Activity (Icon: Icons.receipt_long), Inbox (Icon: Icons.inbox), Profile (Icon: Icons.person).
Indicator Color: Secondary (Yellow).
Screen 6: The Master Dashboard (Home)

Header: Padding (16.0) -> Row.
Left: Column (CrossAxisAlignment.start).
Text "Magandang Umaga" (bodyMedium, color: Grey).
Text "Juan Dela Cruz" (headlineMedium, Bold).
Right: Stack. IconButton (Notification Bell). Badge (top right, color: Red).
Search: Padding (16.0) -> SearchAnchor or Container mimicking search.
Height: 56. Elevation: 2 (Shadow). Text: "Where are we going?".
Services Grid: Padding (16.0) -> GridView.count (crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16).
Card 1 (Ride): Card (elevation: 0, color: Primary[10]).
Height: 180.
Content: Image (Tricycle), Text "Ride", Button "Book".
Card 2 (Parcel): Card (color: Secondary[10]). Image (Box), Text "Parcel".
Card 3 (Pabili): Card (color: Tertiary[10]). Image (Groceries), Text "Pabili".
Screen 7: Location Search ("Landmark" Picker)

AppBar: SearchBar anchored at top.
Body: Column.
Section: "Saved Places". ListView of ListTiles. Leading Icon: Icons.home. Title: "Home". Subtitle: "Near Municipal Hall".
Section: "Nearby Landmarks". ListView of ListTiles.
Map Button: FloatingActionButton ("Pin on Map"). Bottom right.
Screen 8: Choose Your "Chariot"

Layout: Stack.
Layer 1 (Back): Map Widget (greyscale style).
Layer 2 (Front): DraggableScrollableSheet (initialChildSize: 0.5, minChildSize: 0.5).
Container: Decoration: BoxDecoration(color: White, borderRadius: BorderRadius.vertical(top: Radius.circular(24))).
Handle: Centered grey container (width 40, height 4) at top.
Content: ListView.
Title: "Choose a ride" (headlineMedium). Padding 16.
List Items: Container (margin: bottom 8).
Row: Image (60x60), Column (Title, Subtitle), Spacer, Column (Price, Badge).
Active State: Border color Primary, Background Primary[10].
Badge: Chip (label: "Recommended", backgroundColor: Secondary).
Screen 9: Booking Confirmed (Searching)

Layout: Column (Center).
Animation: Lottie.asset('searching_banana.json'). Size: 200.
Text: "Finding you a Granter..." (headlineSmall). Center. Padding top: 24.
Timer: Text "0:45" (displayLarge, color: Primary).
Cancel: OutlinedButton ("Cancel Search"). Bottom of screen, padding 24.
Screen 10: Driver En Route

Layout: Stack.
Map: Full screen.
Overlay: Positioned (bottom: 0, left: 0, right: 0).
Card: Container (padding: 16, decoration: White with shadow).
Row:
CircleAvatar (Driver photo, radius: 30).
SizedBox(width: 16).
Column (Name: "Kuya Ben", Rating: "4.9", Plate: "123-ABC").
Spacer.
Column (Buttons: Call, Chat).
OTP: Container (margin top 16, padding: 12, color: Grey[100]).
Text "OTP: 4821" (headlineMedium, letterSpacing: 4).
SECTION C: LOGISTICS & SERVICES
Screen 11: Parcel Service Type

AppBar: "Send Package".
Body: ListView (padding 16).
Items: Card (height: 120, elevation 2, margin bottom 12).
Child: Row (Image, Title, Arrow).
Types: "Instant Courier", "Box/Heavy", "Scheduled".
Screen 12: Parcel Receiver Details

Layout: Form.
Section: Card (elevation 0, border: Border.all(color: Grey)).
Title: "Receiver Info". Padding 12.
TextField (Name, Phone). Padding inside: 12.
Section: Map Preview (Height 150).
Screen 13: Parcel Tracking

Layout: Column.
Map: Top 50% of screen.
Status Card: Card (margin 16).
Stepper visual (Timeline).
Dots connected by lines. Active step highlighted in Primary.
Text: "Courier is on the way".
Screen 14: "Pabili" Store Selection

Layout: Column.
Search: SearchBar (padding 16).
Grid: GridView (2 columns).
Items: "Palengke", "Grocery", "Pharmacy", "Sari-Sari Store".
Style: Image background with gradient overlay text.
Screen 15: "Pabili" Custom List Input

AppBar: "Shopping List".
Input: TextField (maxLines: 5, hint: "1 kilo Rice...").
Chips: Wrap (spacing: 8).
Chips: "Cooking Oil", "Eggs".
Budget: TextField (prefixText: "₱", hint: "Budget Limit").
SECTION D: ACTIVE RIDE & FINANCE
Screen 16: Active Ride

Layout: Map full screen.
Bottom Sheet: Container (padding 16, height 100).
Text "Ride in Progress" (Green).
Button "Emergency SOS" (Red, Icon: Icons.warning).
Button "Share Trip" (Outlined).
Screen 17: Ride Completion

Layout: Column (Center).
Icon: Icon (Check Circle, size: 80, color: Primary). Padding bottom 16.
Text: "Ride Finished". "Total: ₱75.00" (displayLarge).
Tip Slider: Slider (min: 0, max: 100, divisions: 4). Label "Tip".
Rating: Row of 5 IconButtons (Stars). Spacing 8.
Button: FilledButton ("Done").
Screen 18: Weesh Wallet

Header Card: Container (height: 180, gradient: Primary to DarkGreen).
Text "Balance" (White). Text "₱500.00" (displayLarge, White).
Actions: Row (MainAxisAlignment.spaceEvenly).
Buttons: "Cash In", "Cash Out", "Transfer".
History: ListView of transactions.
Screen 19: Cash In

List: ListView of Banks/E-wallets.
Item: ListTile. Leading: Logo. Title: "GCash". Trailing: Arrow.
Screen 20: Promo & Vouchers

Input: TextField (suffixIcon: Button "Apply").
List: Card (Color: Secondary[10]).
Title: "20% Off Ride".
Expiry: "Valid until Dec 31".
Button: "Use Now".
SECTION E: SOCIAL & SETTINGS
Screen 21: Activity History

Tabs: TabBar (Rides, Parcels, Pabili).
List: Card (margin 8).
Leading: Icon (Tricycle).
Title: "Ride to SM".
Trailing: "₱50.00" & "Completed".
Screen 22: Chat Interface

AppBar: "Kuya Ben".
Body: ListView (reverse: true).
Bubble alignment: Left (Driver), Right (User).
Spacing: 8.
Input: Container (padding: 8). TextField + IconButton (Send).
Screen 23: Emergency Contacts

List: ListTile.
Title: "Mom".
Subtitle: "+63 917...".
Trailing: Switch (value: true).
Screen 24: Invite Friends

Card: Container (padding 24, color: Tertiary[10]).
Text "Invite & Get ₱50".
Code: Text ("JUANBANANA", style: Bold).
Button: "Share Link".
Screen 25: Profile & Settings

Header: UserAccountsDrawerHeader.
CurrentAccountPicture: CircleAvatar.
AccountName: "Juan Dela Cruz".
AccountEmail: "juan@email.com".
List: ListView.
Items: "Edit Profile", "Language", "Dark Mode" (Switch), "Terms", "Sign Out".
EXECUTION INSTRUCTION FOR AI AGENT
Start by creating the constants.dart file for Colors and Spacing.
Setup main.dart with Material 3 ThemeData.
Build the Navigation Structure (HomeScreen with BottomNavBar).
Implement screens sequentially from 1 to 25.
Verify every screen against the "Grid System" rules (Padding 16, Radius 16).
Ensure all illustrations are referenced as placeholders (Image.asset('assets/nano_banana_X.png')).
DO NOT proceed to the next screen until the current screen's padding and alignment match the specifications above. Fix the broken design by enforcing these strict layout rules.