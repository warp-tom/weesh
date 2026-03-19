# Code Review Issues Log

## Purpose

This document captures the main engineering issues identified during the repository audit. It is organized as an action-oriented code review log rather than a generic critique. Priority and ownership are suggested to help triage work.

## Priority Legend

- `P0`: blocking or release-critical
- `P1`: high-priority quality or architecture issue
- `P2`: important but not immediately blocking
- `P3`: improvement or cleanup

## Ownership Legend

- `Mobile`
- `Web`
- `Platform`
- `Product/Design`
- `Shared`

# P0 Issues

## 1. Mobile compile errors are already present

- **Area**: `weesh_mobile`
- **Owner**: `Mobile`
- **Evidence**: `readable_errors.txt`
- **Problem**: The project contains recorded compile-time issues related to icon getters and argument type mismatches.
- **Impact**: The mobile app cannot be considered build-stable.
- **Recommended Fix**:
  - correct the invalid HugeIcons reference
  - fix icon type mismatches in parcel and rating screens
  - confirm a clean analyzer/build pass

## 2. Android build is blocked by Gradle wrapper version

- **Area**: Android build pipeline
- **Owner**: `Mobile`
- **Evidence**: `build_log.txt`
- **Problem**: Current Gradle wrapper version is below the minimum required version.
- **Impact**: Android packaging is blocked.
- **Recommended Fix**:
  - update Gradle wrapper to the required version
  - verify plugin compatibility after upgrade

# P1 Issues

## 3. Supabase configuration is hardcoded in app bootstrap

- **Area**: `weesh_mobile/lib/main.dart`
- **Owner**: `Platform`
- **Problem**: Runtime backend configuration is embedded directly in application code.
- **Impact**:
  - weak environment management
  - harder staging/production separation
  - poor configuration hygiene
- **Recommended Fix**:
  - move runtime config to environment-driven initialization
  - support local, staging, and production variants

## 4. Auth abstraction is bypassed in onboarding flow

- **Area**: `features/auth/onboarding_screen.dart`
- **Owner**: `Mobile`
- **Problem**: The screen directly calls Supabase auth methods instead of routing through the existing auth controller.
- **Impact**:
  - duplicated logic
  - harder testing
  - inconsistent architecture
- **Recommended Fix**:
  - route sign-in and sign-up through `AuthController`
  - keep UI focused on presentation and state display

## 5. Offline-first repository is not fully integrated into feature flows

- **Area**: mobile domain/data architecture
- **Owner**: `Mobile` and `Platform`
- **Problem**: The Isar sync repository exists, but core ride and parcel journeys do not appear to fully depend on it.
- **Impact**:
  - offline-first value is not realized in user-facing flows
  - product resilience is lower than intended
- **Recommended Fix**:
  - create explicit repository flows for ride and parcel request creation
  - write locally first, then sync remotely

## 6. Business logic is concentrated in UI screens

- **Area**: multiple mobile feature screens
- **Owner**: `Mobile`
- **Problem**: Flow logic, state transitions, and domain actions are handled inside widget classes.
- **Impact**:
  - harder maintenance
  - low testability
  - weak separation of concerns
- **Recommended Fix**:
  - move core actions into notifiers/controllers/use cases
  - keep screens as rendering and interaction surfaces

## 7. Core service flows are prototype-driven rather than data-driven

- **Area**: ride and parcel features
- **Owner**: `Mobile` and `Platform`
- **Problem**: Several screens rely on mock delays, hardcoded locations, hardcoded drivers, and simulated success paths.
- **Impact**:
  - limited production readiness
  - misleading operational assumptions
- **Recommended Fix**:
  - replace screen-local simulation with repository-backed state transitions
  - introduce real domain entities and status lifecycle handling

## 8. Admin app is not functionally integrated

- **Area**: `weesh_admin/apps/web`
- **Owner**: `Web`
- **Problem**: The app entry still renders starter content, while the richer admin component is not mounted.
- **Impact**:
  - internal operations surface is not actually usable
- **Recommended Fix**:
  - build real admin routing and layout shell
  - wire operational components into the app

## 9. Admin prototype likely has unresolved integration mismatches

- **Area**: `admin_heatmap.tsx`
- **Owner**: `Web`
- **Problem**: The component appears to rely on imports and utility classes that may not exist in the currently active app structure.
- **Impact**:
  - component may break if simply mounted as-is
- **Recommended Fix**:
  - align imports with `@workspace/ui`
  - verify all referenced utility classes exist in shared styles

# P2 Issues

## 10. Role switch in profile is currently only local UI state

- **Area**: `features/profile/profile_screen.dart`
- **Owner**: `Mobile` and `Platform`
- **Problem**: Switching between user and driver mode does not appear to change permissions, routing, or backend behavior.
- **Impact**:
  - misleading UX
  - incomplete driver-mode architecture
- **Recommended Fix**:
  - persist role in backend profile data
  - use role to drive accessible routes and feature states

## 11. Activity/history screen is powered by mock data

- **Area**: `features/activity/activity_screen.dart`
- **Owner**: `Mobile`
- **Problem**: History records are hardcoded.
- **Impact**:
  - weak transaction continuity
  - no real retention value for users
- **Recommended Fix**:
  - connect to persisted transaction history via repository layer

## 12. Grocery feature exists only as product placeholder

- **Area**: dashboard and feature structure
- **Owner**: `Product/Design` and `Mobile`
- **Problem**: Grocery is visible in the product surface but not implemented.
- **Impact**:
  - user expectation mismatch
- **Recommended Fix**:
  - either hide until planned or formalize roadmap timing and placeholder messaging

## 13. Driver feature module is largely empty

- **Area**: `features/driver_active`
- **Owner**: `Mobile`
- **Problem**: Repository structure implies driver capability, but the implementation is not materially present.
- **Impact**:
  - architecture suggests more completeness than actual delivery
- **Recommended Fix**:
  - create explicit driver-mode roadmap and feature ownership

## 14. Limited test coverage

- **Area**: repository-wide
- **Owner**: `Shared`
- **Problem**: The repo contains only a minimal smoke test for mobile.
- **Impact**:
  - regressions are likely
  - refactoring risk is high
- **Recommended Fix**:
  - add routing, repository, auth, and critical-widget tests
  - add web build/typecheck/test gates

# P3 Issues

## 15. CSS token file contains duplication and potential cleanup opportunities

- **Area**: `weesh_admin/packages/ui/src/styles/globals.css`
- **Owner**: `Web`
- **Problem**: Some sidebar/chart tokens are duplicated or reassigned in a way that reduces clarity.
- **Impact**:
  - maintainability cost
  - risk of theme drift
- **Recommended Fix**:
  - normalize token definitions
  - keep each semantic token defined once per theme context

## 16. Dark mode strategy appears incomplete

- **Area**: admin UI theming
- **Owner**: `Web`
- **Problem**: Theme toggling exists, but project-specific dark token overrides are not obviously complete.
- **Impact**:
  - inconsistent theming experience
- **Recommended Fix**:
  - formalize dark theme tokens in shared CSS
  - validate components in both themes

## 17. Prototype code should be clearly labeled or isolated

- **Area**: repository-wide
- **Owner**: `Shared`
- **Problem**: Several screens and components act as polished demos without strong separation from production pathways.
- **Impact**:
  - engineering ambiguity
  - roadmap ambiguity
- **Recommended Fix**:
  - distinguish production code, concept code, and roadmap placeholders

## Suggested Triage Order

### First wave

- fix compile/build blockers
- externalize configuration
- unify auth architecture
- connect ride/parcel creation to real repositories

### Second wave

- real activity history
- true driver mode
- admin app shell and routing
- reduce screen-local business logic

### Third wave

- formalize backend contracts
- improve testing and CI
- clean theme/token debt
- clarify placeholder features

## Final Note

The codebase has strong product and UX potential. These issues are not signs of a weak concept; they are signs of a project that has advanced quickly in design and flow quality and now needs a disciplined integration and hardening phase.
