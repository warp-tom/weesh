# Implementation Roadmap

## Objective

This roadmap translates the current state of the repository into a practical path from branded MVP/prototype to reliable operational product. It is organized by phases rather than by isolated tickets so that engineering, product, and design can align around outcomes.

## Current Baseline

### Strengths already in place

- strong mobile route architecture
- coherent design system and brand identity
- initial auth integration
- local persistence foundations via Isar
- web admin workspace and shared UI package

### Core gaps

- mobile compile/build blockers
- feature logic concentrated in screen widgets
- incomplete repository/service layer adoption
- limited real backend-backed transaction flow
- admin application not yet operational
- minimal tests and no visible CI quality gates

## Guiding Principles

- ship from the mobile core outward
- prioritize operational correctness over adding more visual surfaces
- preserve the existing brand quality while hardening architecture
- formalize data contracts before scaling service complexity
- keep offline-first behavior central to user-facing transaction design

# Phase 0: Stabilization and Hygiene

## Goal

Bring the repository to a clean, buildable, and maintainable baseline.

## Workstreams

### Build and dependency health

- fix current compile-time errors in mobile screens
- update Android Gradle wrapper to supported version
- verify mobile app builds successfully on target platforms
- verify admin app typechecks and builds cleanly

### Configuration hygiene

- move Supabase runtime configuration out of hardcoded app bootstrap
- introduce environment configuration strategy for local, staging, and production

### Structural cleanup

- remove or clearly isolate dead prototype code
- normalize imports and broken references in admin prototype components
- align onboarding auth flow with controller/provider abstractions

## Exit Criteria

- mobile project builds successfully
- admin project builds successfully
- no known compile errors remain
- runtime configuration is environment-managed

# Phase 1: Mobile Core Product Hardening

## Goal

Convert the mobile app from prototype-grade interaction flows into real, persisted, user-facing service flows.

## Workstreams

### Auth and session flow

- unify all sign-in and sign-up behavior through auth controller/provider abstractions
- add error-state normalization and auth feedback handling
- confirm route redirect behavior under cold start and session restore scenarios

### Domain modeling

- define request models for ride and parcel flows
- define status lifecycle states
- define driver and transaction entities clearly
- separate presentation models from persistence models

### Repository and service layer

- add explicit repositories for ride, parcel, and activity history
- move domain operations out of screen widgets
- establish a standard interface for local-first and remote-sync writes

### Activity/history integration

- replace mock activity records with persisted transaction history
- support status transitions from real data

## Exit Criteria

- ride and parcel requests are created through repository flows
- activity screen reflects real stored transactions
- UI no longer owns core business actions directly

# Phase 2: Offline-First Operationalization

## Goal

Make offline resilience a real product feature rather than an infrastructure placeholder.

## Workstreams

### Local-first transactions

- route new service requests through Isar-backed persistence before remote sync
- surface pending sync state in domain entities
- recover active requests after app restarts or network interruptions

### Sync engine improvements

- implement retry strategy for failed sync attempts
- distinguish network failure from validation failure
- add conflict handling rules for local vs cloud state divergence

### User experience for degraded connectivity

- add UI states for pending sync
- add recovery notices where needed
- ensure users can continue critical flows without immediate connectivity

## Exit Criteria

- requests survive offline conditions
- sync failures are observable and recoverable
- active service state can be restored after interruption

# Phase 3: Driver and Role-Based Expansion

## Goal

Transform the profile-level role toggle into a real product capability.

## Workstreams

### Driver mode architecture

- create driver-specific routes and shell behavior
- persist role in backend/user profile instead of local UI-only state
- implement driver availability and status model

### Driver operational flows

- online/offline toggling
- active assignment state
- location updates
- task acceptance and completion flow

### Permissions and route control

- ensure role determines route access and visible features
- formalize role-based access expectations across mobile and admin surfaces

## Exit Criteria

- driver mode changes available app behavior
- driver state is persisted and recoverable
- role is no longer only decorative UI state

# Phase 4: Admin Operational MVP

## Goal

Turn the admin workspace into a usable internal operations tool.

## Workstreams

### App shell and navigation

- build real admin layout shell
- add authenticated access
- implement route structure for dashboard, queue, dispatch, and support views

### Shared UI expansion

- add table, form, modal, sidebar, filters, and empty-state components in `packages/ui`
- standardize token usage and theme consistency

### Operations features

- verification queue
- active service monitoring
- dispatch overview
- issue review and moderation workflows

### Data integration

- wire real backend queries into admin views
- replace placeholder content with live operational state

## Exit Criteria

- admin users can sign in
- admin dashboard shows live or near-live operational data
- at least one operational workflow is fully usable end-to-end

# Phase 5: Dispatch and Service Intelligence

## Goal

Move from UX-complete flows to business-complete logistics behavior.

## Workstreams

### Backend orchestration

- move dispatch decision logic into server-managed workflows
- formalize fare computation and assignment constraints
- support audit trails for service state changes

### Mapping and routing intelligence

- replace faux or static map logic with real operational map overlays
- add pickup/drop-off capture and route state handling
- support driver and request positioning as real data flows

### Trust and compliance features

- operationalize bayanihan rating/tag logic
- operationalize proof-of-delivery workflows
- add admin visibility into trust and dispute signals

## Exit Criteria

- assignment and service state changes are system-driven, not screen-simulated
- mapping and tracking reflect real operational data
- trust features persist and influence review workflows

# Phase 6: Scale, Observability, and Product Expansion

## Goal

Prepare the platform for broader real-world reliability and service growth.

## Workstreams

### Quality and observability

- add logging and crash/error reporting
- add analytics for funnel drop-off and service completion
- add backend observability for key operational events

### Testing and CI

- widget and routing tests for mobile
- repository and service tests
- web unit tests for admin views
- CI build, lint, and test gates

### Product expansion

- implement grocery feature from current placeholder state
- refine service catalogs and operational constraints
- add more robust support and escalation tooling

## Exit Criteria

- CI protects main branches
- platform health is measurable
- new verticals can be added without destabilizing the core architecture

## Suggested Team Ownership Model

### Mobile engineering

- phases 0 through 3
- mobile repository/service layering
- offline-first implementation
- active transaction UX

### Web/admin engineering

- phase 4
- shared UI package expansion
- admin shell and workflows

### Backend/platform engineering

- phases 2, 5, and 6
- sync strategy, orchestration, schema ownership, observability

### Product/design

- service lifecycle definition
- trust and rating systems
- role-based flow requirements
- degraded connectivity UX

## Recommended Delivery Order

If resourcing is limited, the highest-return order is:

- stabilize build health
- convert mobile flows to real repositories and persistence
- operationalize offline behavior
- implement true driver mode
- build admin MVP around real live data
- move dispatch logic server-side

## Final Note

The current codebase already proves that the team can define and deliver a differentiated product experience. This roadmap focuses on converting that strong design-led base into a dependable operational system without losing the original brand quality that makes the product distinctive.
