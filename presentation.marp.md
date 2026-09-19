---
marp: true
theme: default
paginate: true
style: |
  section {
    background-color: #0d1117;
    color: #c9d1d9;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    padding: 36px 48px 48px 48px;
    height: 720px;
    box-sizing: border-box;
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
  }
  h1, h2, h3 {
    color: #58a6ff;
    font-weight: 700;
  }
  h1 {
    font-size: 2rem;
    margin: 0 0 0.5rem 0;
  }
  h2 {
    font-size: 1.45rem;
    border-bottom: 1px solid #30363d;
    padding-bottom: 6px;
    margin: 0 0 14px 0;
    width: 100%;
  }
  h3 {
    font-size: 1.1rem;
    color: #79c0ff;
    margin: 0 0 8px 0;
  }
  p, li {
    font-size: 0.84rem;
    line-height: 1.42;
  }
  ul {
    margin: 0 0 8px 0;
    padding-left: 20px;
  }
  li {
    margin-bottom: 5px;
  }
  code {
    background-color: #161b22;
    color: #79c0ff;
    border-radius: 4px;
    padding: 2px 6px;
    font-size: 0.8rem;
  }
  pre {
    background-color: #161b22 !important;
    border: 1px solid #30363d;
    border-radius: 6px;
    padding: 10px;
    font-size: 0.72rem;
    margin: 0 0 10px 0;
  }
  table {
    font-size: 0.76rem;
    border-collapse: collapse;
    width: 100%;
    margin-top: 6px;
    background-color: #161b22 !important;
    color: #c9d1d9 !important;
  }
  table th {
    background-color: #21262d !important;
    color: #58a6ff !important;
    border: 1px solid #30363d !important;
    padding: 8px 12px;
    font-weight: 600;
  }
  table td {
    background-color: #0d1117 !important;
    border: 1px solid #30363d !important;
    padding: 8px 12px;
    color: #c9d1d9 !important;
  }
  table tr, table tr:nth-child(2n), table tbody tr, table tbody tr:nth-child(2n) td {
    background-color: #0d1117 !important;
    color: #c9d1d9 !important;
  }
  table tr:nth-child(2n+1) td {
    background-color: #161b22 !important;
    color: #c9d1d9 !important;
  }
  .split-40-60 {
    display: flex;
    flex-direction: row;
    align-items: flex-start;
    justify-content: space-between;
    gap: 24px;
    width: 100%;
    flex: 1;
    min-height: 0;
  }
  .split-40-60 > .col-left {
    flex: 0 0 42%;
  }
  .split-40-60 > .col-right {
    flex: 0 0 55%;
    display: flex;
    justify-content: center;
    align-items: center;
  }
  .split-50-50 {
    display: flex;
    flex-direction: row;
    align-items: flex-start;
    justify-content: space-between;
    gap: 24px;
    width: 100%;
    flex: 1;
    min-height: 0;
  }

  .split-50-50 > .col-left {
    flex: 0 0 48%;
  }
  .split-50-50 > .col-right {
    flex: 0 0 48%;
    display: flex;
    justify-content: center;
    align-items: center;
  }
  .col-right img, .col-left img {
    max-height: 480px;
    max-width: 100%;
    object-fit: contain;
    border-radius: 6px;
    border: 1px solid #30363d;
  }
  section.lead {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    text-align: center;
  }
  section.lead h1 {
    font-size: 2.3rem;
    margin-bottom: 0.8rem;
  }
  section.lead h3 {
    font-size: 1.25rem;
    margin-bottom: 0.8rem;
  }
  section.lead p {
    font-size: 1rem;
  }
  section.lead ul {
    text-align: left;
    display: inline-block;
    font-size: 0.95rem;
    line-height: 1.6;
  }
---

<!-- _class: lead -->
<!-- _paginate: false -->
# Fleet management system
### Unified declarative control for Linux, macOS, and Windows
**Central build server, P2P binary cache, and automated rollback**

---

## The operational problem

Engineering teams manage three operating systems with three disconnected tools.

- **Linux**: Engineers write bash scripts and Ansible playbooks. System state drifts over time.
- **macOS**: Administrators purchase proprietary MDM licenses. Packaging custom software is slow.
- **Windows**: Administrators maintain Intune profiles and Group Policies. Registry changes remain opaque.

**The target state:**
Write one unified Nix Flake. Evaluate host configurations from one central server. Deploy immutable configurations to all three operating systems.

---

## System architecture and topology

<div class="split-40-60">
<div class="col-left">

### Control layer and endpoints
- **Fleet server**: Evaluates unified Nix Flakes into target closures.
- **Control channel**: Outbound gRPC over HTTPS port 443 with mTLS.
- **Linux endpoints**: Native NixOS with ephemeral `tmpfs` root.
- **macOS endpoints**: Nix-Darwin with embedded NanoMDM security.
- **Windows endpoints**: Native Go agent mapping configurations to Win32, Registry, and LGPO.
- **P2P transport**: Tailcat userspace WireGuard mesh on local networks.

</div>
<div class="col-right">

<img src="/home/radhey/code/fleet-management/assets/diagram_topology.svg" />

</div>
</div>

---

## Build cache transfer sequence

<div class="split-40-60">
<div class="col-left">

### Distribution sequence
- Admin pushes Flake lock update to Git.
- Build workers compile derivations and write outputs to Attic.
- Server sends target hash to endpoints via gRPC.
- Node A downloads missing paths from Attic S3.
- Node B requests chunks from Node A via local LAN Tailcat WireGuard.
- Endpoints verify Ed25519 signatures before unpacking.

</div>
<div class="col-right">

<img src="/home/radhey/code/fleet-management/assets/diagram_cache_sequence.svg" />

</div>
</div>

---

## Build cache mechanics

| Phase | Mechanism | Technical function |
| :--- | :--- | :--- |
| **Derivation build** | Sandboxed build farm | Compiles packages into immutable store paths (`/nix/store/<hash>-<name>`). |
| **Signature** | Ed25519 private key | Signs `.narinfo` index files. Clients reject unsigned or modified paths. |
| **Persistence** | Attic store on S3 | Deduplicates storage blocks with FastCDC. Compresses archives with Zstandard. |
| **Local transfer** | Tailcat peer transport | Streams missing store chunks between machines on the same local network. |
| **Integrity check** | Cryptographic verification | Verifies SHA-256 hashes before unpacking archives into the local store. |

---

## Linux node execution workflow

<div class="split-50-50">
<div class="col-left">

### NixOS immutable execution
- **Ephemeral root**: The operating system boots with `tmpfs` mounted at `/`. A reboot wipes unauthorized files.
- **Store protection**: The host mounts `/nix/store` as read-only.
- **Persistent state**: The agent binds machine identity and host keys from `/persist` using `impermanence`.
- **Atomic rollback**: If post-switch health checks fail, the agent switches the symlink back to generation $N-1$.

</div>
<div class="col-right">

<img src="/home/radhey/code/fleet-management/assets/diagram_linux_workflow.svg" />

</div>
</div>

---

## macOS node execution workflow

<div class="split-50-50">
<div class="col-left">

### Dual-channel management
- **Integrated MDM**: The Fleet server includes an embedded NanoMDM service for FileVault escrow and TCC permissions.
- **Nix integration**: The agent writes packages to `/nix/store` using APFS synthetic firmlinks.
- **Declarative state**: `darwin-rebuild activate` updates LaunchDaemons and user preference plists.
- **License savings**: Eliminates third-party MDM vendor costs.

</div>
<div class="col-right">

<img src="/home/radhey/code/fleet-management/assets/diagram_macos_workflow.svg" />

</div>
</div>

---

## Windows node execution workflow

<div class="split-50-50">
<div class="col-left">

### Desired state pipeline
- **Intermediate representation**: Server evaluates Nix into a typed JSON desired-state document.
- **Local generation bundle**: Agent writes files to `C:\ProgramData\Fleet\generations\<hash>\`.
- **State application**:
  - Applies registry keys using Win32 API calls.
  - Compiles and applies LGPO policy files.
  - Installs Winget and MSIX packages.
  - Configures Windows services and queries WMI.
- **Idempotent rollback**: If verification fails, the agent re-executes the generation $N-1$ bundle.

</div>
<div class="col-right">

<img src="/home/radhey/code/fleet-management/assets/diagram_windows_workflow.svg" />

</div>
</div>

---

## Windows rollback: Generation re-application

We reject complex state diff engines and heavy disk restore points.

- State diff journals introduce fragile edge cases and unneeded code complexity.
- Volume Shadow Copy restore points consume multiple gigabytes of disk and require reboots.

### The generation re-application model
1. The agent keeps previous generation bundles in `C:\ProgramData\Fleet\generations\`.
2. Each bundle contains complete `.reg` files, policy manifests, and package lists.
3. When generation $N$ fails validation, the agent re-executes the generation $N-1$ bundle.
4. Re-running the previous declarative bundle is idempotent. The system returns to compliant state in seconds without a reboot.

---

## Networking: Tailcat unified mesh

<div class="split-40-60">
<div class="col-left">

### Mesh and telemetry transport
- **Remote laptops (WAN)**: Traveling endpoints connect via userspace WireGuard (gVisor `netstack`, zero TUN conflicts) with HTTPS 443 DERP fallback.
- **Target hashes via Tailcat**: The server dispatches desired-state hashes over the private WireGuard mesh without exposing public ports.
- **Telemetry via HTTP tunneling**: Live metrics and heartbeats stream back via HTTP/gRPC tunneling with automatic HTTPS DERP fallback.
- **Office workstations (LAN)**: Local machines discover peers via Tailcat Disco and stream binary store chunks at gigabit LAN speed.



</div>
<div class="col-right">

<img src="/home/radhey/code/fleet-management/assets/diagram_network_mesh.svg" />

</div>
</div>



---

## Fleet web console and telemetry

<div class="split-40-60">
<div class="col-left">

### Operational console architecture
- **Web console (Next.js 15)**: Displays real-time inventory, target generations, and compliance drift.
- **Control server engine (Go)**: Collects metrics and pushes state updates over WebSockets and gRPC.
- **PostgreSQL 16**: Stores relational host inventories with TimescaleDB toggle.
- **Prometheus & LLM**: Real-time threshold monitoring paired with plain-language incident explanations.

</div>
<div class="col-right">

<img src="/home/radhey/code/fleet-management/assets/diagram_dashboard.svg" />

</div>
</div>

---

## Operational metrics and human control

- **Deterministic alerting**: Prometheus metric rules detect system faults, high failure counts, and failed check-ins.
- **Incident summaries**: An LLM reads metric anomalies and writes short plain-language root cause explanations.
- **Drift detection**: The agent reports unauthorized registry edits, modified services, and untracked software packages.
- **One-click bulk revert**: Administrators review non-compliant nodes in the dashboard and click **Revert Selected** to re-apply the assigned generation.
- **Safe boundaries**: The AI assistant never makes autonomous configuration changes to production computers.

---

## Database architecture and scaling

<div class="split-50-50">
<div class="col-left">

### Unified relational schema
- **Single database engine**: PostgreSQL 16.
- **Shared schema**: Uses the same SQL tables across all deployment scales.
- **Small fleets (under 2,000 nodes)**: Uses native PostgreSQL monthly table partitions.
- **Large fleets (over 10,000 nodes)**: Enables TimescaleDB hypertable compression with a configuration toggle.
- **Zero schema rewrite**: The schema does not change as an organization scales.

</div>
<div class="col-right">

```sql
-- Core relational inventory
CREATE TABLE nodes (
    id UUID PRIMARY KEY,
    hostname TEXT NOT NULL,
    os_type TEXT NOT NULL,
    target_gen TEXT NOT NULL,
    current_gen TEXT NOT NULL,
    last_seen_at TIMESTAMPTZ NOT NULL
);

-- Telemetry log (TimescaleDB toggle)
CREATE TABLE node_telemetry (
    recorded_at TIMESTAMPTZ NOT NULL,
    node_id UUID REFERENCES nodes(id),
    cpu_percent REAL,
    memory_used_bytes BIGINT,
    drift_detected BOOLEAN,
    payload JSONB
);
```

</div>
</div>

---

## Deployment rings and verification

<div class="split-50-50">
<div class="col-left">

### Ring-based rollout
- **Canary stage (Ring 0)**: Deploys updates to 1% of internal test workstations for 24 hours.
- **Early adopters (Ring 1)**: Deploys updates to 10% of users for 48 hours.
- **Full rollout (Ring 2)**: Deploys to all remaining production computers.
- **Local watchdog**: If an endpoint loses contact with the Fleet server for three consecutive check-ins after an update, it reverts locally to the last good generation.

</div>
<div class="col-right">

<img src="/home/radhey/code/fleet-management/assets/diagram_canary_rings.svg" />

</div>
</div>

---

## Production technology stack

| Subsystem | Technology | Responsibility |
| :--- | :--- | :--- |
| **Control plane** | Go 1.23 | HTTP/gRPC server, Nix evaluator, embedded Tailcat DERP relay |
| **Apple MDM** | NanoMDM | APNs push, FileVault key escrow, TCC permission profiles |
| **Database** | PostgreSQL 16 | Relational node inventory and optional TimescaleDB telemetry |
| **Build cache** | Attic + S3 | Content-addressed chunk store with FastCDC deduplication |
| **Client agent** | Go 1.23 (`fleetd`) | System daemon on Linux (systemd), macOS (launchd), Windows (Service) |
| **Windows engine** | Win32 FFI | Registry transactions, LGPO policies, Winget installations |
| **Web dashboard** | Next.js 15 | React 19, TypeScript, Tailwind CSS, Prometheus alert summaries |

---

<!-- _class: lead -->
# Summary
- One Nix Flake controls Linux, macOS, and Windows computers.
- Tailcat peer networking distributes binary closures across office local networks.
- Generation re-application provides reliable Windows rollback without restore points.
- Embedded NanoMDM eliminates third-party Apple MDM subscriptions.
