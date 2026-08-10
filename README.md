# CM — CXC 138 31 Configuration Management

[![CI](https://img.shields.io/badge/hex-v0.7.7-blue.svg)](https://hex.pm/packages/cm)
[![License: ISC](https://img.shields.io/badge/License-ISC-blue.svg)](LICENSE)
[![Elixir](https://img.shields.io/badge/Elixir-~%3E%201.14-purple.svg)](https://elixir-lang.org/)

**CM** (CXC 138 31 Configuration Management) is an Elixir/OTP security profile management framework, CMDB asset classification registry, and automated compliance document compiler.

Extracted and specialized from the CMDB functionality of [`synrc/ca`](https://github.com/synrc/ca), **CM** provides formal security baseline specifications, regulatory document generation (LaTeX / PDF reports and legal administrative orders), OID registries, and cryptographic key protection profiles mapped to **NIST SP 800-53**, **FIPS 199/200**, **ISO/IEC 27005**, **MITRE ATT&CK**, and Ukrainian **KSZI / НД ТЗІ** regulations.

---

## Key Features

### CMDB & Enterprise Asset Taxonomies
- **ABAC / RBAC** (`CA.ABAC`): Role & access control policy matrix based on NIST SP 800-162 and ND TZI.
- **Data Assets** (`CA.Data`): Data classification matrix based on FIPS 199 CIA Triad.
- **Hardware Assets** (`CA.HW`): Hardware inventory specs (Intel Sapphire Rapids, TPM 2.0, Secure Boot, Intel TDX, FIPS 140-3).
- **Network Zoning** (`CA.Net`): Network topology mapping based on Defense-in-Depth & NIST SP 800-41.
- **Business Processes** (`CA.Proc`): Criticality & RTO/RPO metrics based on NIST SP 800-34.
- **Software Assets** (`CA.Sys`): Software taxonomy & OS hardening specs (UA Linux DSTU-hardened, Windows 11 Pro NATO STIG, IIT KZI).
- **Threats & Risks** (`CA.Risk`, `CA.Mitre`): Risk taxonomy and MITRE ATT&CK Enterprise kill-chain mapping.

### NIST SP 800-53 Controls & Security Baselines
- `CA.NIST.Low`, `CA.NIST.Moderate`, `CA.NIST.High`, `CA.NIST.Privacy` baselines according to NIST SP 800-53B.
- Key storage protection profiles: `CA.NIST.PrivateKeyStorage`, `CA.NIST.SecureEnclaveStorage`, and `CA.NIST.TPMStorage`.

### Multi-Level Security Profiles
- **Level 1 Base Profiles**: `CA.L1.Base84`, `CA.L1.Base97`, `CA.L1.Extended` (full subcontrol baselines).
- **Level 2 Sectoral Profiles**: Judicial / Court System security profiles (`CA.L2.Court`, `CA.L2.CourtOrg`, `CA.L2.CourtTech`).
- **Level 3 Target Profiles**: Application and infrastructure baselines (`CA.L3.ERP`, `CA.L3.Mail`, `CA.L3.Messenger`, `CA.L3.VPN`).

### Documentation-as-Code (DaC) & Automated Compiler
- **`CA.TeX`**: Generates publication-ready LaTeX documentation for security profiles, architectures, and policies directly from Elixir source modules.
- **`CA.NPA`**: Generates regulatory administrative security orders (накази з ІБ та КСЗІ).
- **`CA.PRO` & OIDs**: Functional inventory search engine alongside `CA.SPE` and `CA.CP` OID registries.

---

## Directory Structure

```
cm/
├── config/
│   └── config.exs          # Application configuration
├── doc/                    # Generated Markdown, HTML, and EPUB documentation
│   ├── index.html
│   └── llms.txt
├── lib/
│   ├── application.ex      # Main CM application entry point
│   ├── family.ex           # Family description generator utilities
│   ├── npa.ex              # Administrative order (накази) template generator
│   ├── param.ex            # Parameter utilities
│   ├── tex.ex              # LaTeX compilation engine for security profiles
│   ├── cmdb/               # Core security maps (ABAC, Data, HW, Net, Proc, Sys, Risk, Mitre, NIST)
│   ├── cmdb-profiles/      # Sectoral & court inventory profiles (CA.PRO)
│   └── oid/                # Certificate Policy (CP) and Security Profile Extensions (SPE) OIDs
├── priv/                   # LaTeX templates, compiled PDFs, and shell build scripts (run.sh, clean.sh)
├── NIST.md                 # Mapped NIST SP 800-53 controls documentation
├── mix.exs                 # Mix project definition & dependencies
├── mix.lock                # Locked dependency tree
└── LICENSE                 # ISC License
```

---

## Prerequisites

- **Elixir**: `~> 1.14` (with Erlang/OTP)
- **pdflatex** / **TeX Live** (optional, required if building PDFs from generated `.tex` files)

---

## Installation

Add `:cm` to your dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cm, "~> 0.7.7"}
  ]
end
```

Then run:

```bash
mix deps.get
mix compile
```

---

## CMDB Interactive Inspection (`CA.PRO`)

The `CA.PRO` module allows programmatic querying of all CMDB inventory profiles directly in Elixir (`iex`):

### 1. Risk Assessment & Threat Mapping (`CA.PRO.risk/1`)

```elixir
iex> CA.PRO.risk("ERP")
[
  {"RISK-OS-01", "Вразливості Active Directory (Kerberoasting, Pass-the-Hash, Golden Ticket)", ["AC", "IA", "SC"]},
  {"RISK-OS-06", "Підвищення привілеїв Linux (Kernel, SUID, Dirty COW)", ["AC", "SI"]},
  {"RISK-CRY-04", "Компрометація ПАК «Гряда» (ІІТ HSM)", ["PE", "SC", "AC"]},
  {"RISK-CRY-07", "Вразливості криптобібліотек (Калина, Купина, Padding Oracle)", ["SA", "SI"]},
  {"RISK-NET-04", "DDoS (Slowloris, SYN Flood, ампліфікація DNS/NTP)", ["SC", "IR"]},
  {"RISK-INF-01", "Компрометація BMC (IPMI, iDRAC, iLO)", ["AC", "SC"]},
  {"RISK-PER-01", "Spear Phishing & Whaling (цільовий фішинг адміністраторів)", ["AT", "IR", "SI"]},
  {"RISK-DAT-01", "Втрата резервних копій (Ransomware, Backup Corruption)", ["CP", "MP", "SI"]}
]
```

### 2. System Software Components (`CA.PRO.sys/1`)

```elixir
iex> CA.PRO.sys("ERP")
[
  {"SYS-OS-01-UAL", "UA Linux 24.04 LTS (DSTU-hardened, SELinux Enforcing)", []},
  {"SYS-APP-00-ERL", "Erlang/OTP 27.3 (SMP, BEAM VM, distribution TLS)", []},
  {"SYS-APP-00-ELX", "Elixir 1.18.3 (N2O, NITRO, FORM, Bandit)", []},
  {"SYS-APP-01-IIT", "ІІТ Користувач ЦСК-1 (бібліотека «IIT Gryada-301»)", []},
  {"SYS-DB-01-PG", "PostgreSQL 17.2 (TDE + pgAudit + pg_partman)", []},
  {"SYS-MW-01-NGX", "Nginx 1.27 (TLS 1.3 only, OCSP Stapling, CT Logs, HSTS)", []}
]
```

### 3. Hardware Asset Inventory (`CA.PRO.inventory/1`)

```elixir
iex> CA.PRO.inventory("ERP")
[
  {"ERP-STG-01", "ERP-STG-2025-001", "5HT Technology AllFlash NVMe Array (Sapphire Rapids Storage Controller)"},
  {"ERP-TAPE-01", "ERP-STG-2025-003", "HPE StoreEver MSL3040 Tape Library"},
  {"ERP-KZI-01", "ERP-KZI-2025-001", "IIT Gryada-301 PCIe HSM"},
  {"ERP-KZI-03", "ERP-KZI-2025-003", "Автор CryptoCard Smart-01 (е-Токен, Смарт-карта)"},
  {"ERP-NET-01", "ERP-NET-2025-001", "Cisco Catalyst 9500-48Y4C"},
  {"ERP-FW-01", "ERP-NET-2025-004", "Cisco Firepower 4145 NGFW (FTD 7.6)"},
  {"ERP-SRV-01", "ERP-2025-001", "5HT Technology Tristellar 3U"},
  {"ERP-SRV-03", "ERP-2025-003", "5HT Technology Quadstellar 4U"}
]
```

### 4. Role-Based Access Control (`CA.PRO.roles/1`)

```elixir
iex> CA.PRO.roles("ERP")
[
  {"ROLE-ADM-01", "Адміністратор безпеки", ["security_admin"]},
  {"ROLE-AUD-01", "Аудитор", ["auditor"]},
  {"ROLE-OPR-01", "Оператор реєстрації", ["reg_operator"]},
  {"ROLE-SYS-01", "Системний процес (Machine-to-Machine)", ["ocsp_service", "crl_generator"]},
  {"ROLE-SADM-01", "Глобальний суперадміністратор (root/administrator)", ["global_root_admin", "infra_super_user"]}
]
```

### 5. Data Categorization & Repositories (`CA.PRO.data/1`)

```elixir
iex> CA.PRO.data("ERP")
[
  {"DATA-PUB-01", "Публічні сертифікати та CRL", "Public CDN / web server"},
  {"DATA-PII-01", "Реєстр підписників (паспорти, РНОКПП)", "Encrypted DB (PostgreSQL)"},
  {"DATA-INT-02", "Журнали аудиту (SIEM logs)", "SIEM (Elasticsearch)"},
  {"DATA-KEY-01", "Кореневі та підпорядковані ключі ЦСК", "HSM (Гряда / IIT)"},
  {"DATA-CRT-01", "Матеріали судових проваджень та ухвали", "Encrypted DB (Oracle / PostgreSQL)"},
  {"DATA-BKP-01", "Снапшоти БД та образи ВМ", "Tape Library (MSL3040)"}
]
```

### 6. Business Process Criticality (`CA.PRO.proc/1`)

```elixir
iex> CA.PRO.proc("ERP")
[
  {"PROC-CERT-01", "Видача кваліфікованих сертифікатів", "Оператор реєстрації ЦСК"},
  {"PROC-OCSP-01", "Формування OCSP-відповідей (24/7)", "Автоматичний сервіс ЦСК"},
  {"PROC-AUDIT-01", "Логування та моніторинг подій безпеки", "Адміністратор безпеки / SIEM"},
  {"PROC-ROOT-01", "Церемонія генерації кореневого ключа", "Комісія ЦСК (Dual Control)"},
  {"PROC-DOC-01", "Реєстрація та розгляд судових справ", "Судова влада України / ДП ІСС"}
]
```

### 7. Network Architecture & Zoning (`CA.PRO.net/1`)

```elixir
iex> CA.PRO.net("ERP")
[
  {"NET-DMZ-01", "OCSP / CRL публічний ендпоінт", "публічна підмережа"},
  {"NET-INT-01", "Сегмент серверів БД", "внутрішня підмережа БД"},
  {"NET-INT-02", "Сегмент робочих станцій операторів", "внутрішня підмережа АРМ"},
  {"NET-MGT-01", "VLAN IPMI / iLO адміністрування", "management VLAN"},
  {"NET-AIR-01", "Кореневий ЦСК (офлайн вузол)", "N/A"}
]
```

---

## Automated Document Compiler & LaTeX Engine

### 1. Rendering Security Profile Specifications

Use `CA.TeX` to render complete LaTeX documents for security profiles:

```elixir
# Render Court Sectoral Security Profile LaTeX specification:
CA.TeX.gen_tex("legal_l2_court_profile.tex", title: "Court Sectoral Security Profile")
```

To compile generated `.tex` files into PDFs using TeX Live:

```bash
cd priv
./run.sh
```

### 2. Administrative Security Orders (NPA)

Generate structured regulatory administrative orders (Накази з Інформаційної Безпеки):

```elixir
# Generate SZI Establishment Order:
CA.NPA.gen_order_szi_establishment(
  org_name: "State Enterprise Information Judicial Systems",
  city: "Kyiv",
  ciso_name: "Ivan Petrenko"
)

# Generate KSZI Development Order:
CA.NPA.gen_order_kszi_development(
  system_name: "Enterprise ERP",
  survey_deadline: "30.03.2025"
)
```

### 3. Compiling Documentation

Generate updated HTML, Markdown (`llms.txt`), and EPUB documentation using `ExDoc`:

```bash
mix docs
```

---

## Certification Workflow & Segregation of Duties

Under Ukrainian technical protection regulations (e.g., **НД ТЗІ 2.6-001-11**), constructing and certifying a Comprehensive Information Security System (**КСЗІ**) follows a strict **two-stage procedure** to guarantee segregation of duties (Maker/Checker principle):

1. **Stage 1: Developer (Provider 1)**  
   Performs environment risk assessments, inspects target infrastructure, formulates the **Target Security Profile (Technical Specification)** in Elixir CMDB code, and implements the Reference Monitor and security controls.
2. **Stage 2: Expertise Organizer (Provider 2)**  
   Receives the Technical Specification from the Developer, designs an independent Expertise Program, conducts instrumental testing and live verification, and issues the official Expert Conclusion for SSSCIP (**ДССЗЗІ**).

---

## Standard Compliance & Regulatory Mapping

| Framework / Regulation | Specifications & Coverage |
| :--- | :--- |
| **NIST SP 800-53 Rev. 5 / 800-53B** | Controls across all 20 families (AC, AT, AU, CA, CM, CP, IA, IR, MA, MP, PE, PL, PM, PS, PT, RA, SA, SC, SI, SR) and baselines (`CA.NIST.Low`, `CA.NIST.Moderate`, `CA.NIST.High`, `CA.NIST.Privacy`). |
| **FIPS 199 / FIPS 200** | Data classification (`CA.Data`), baseline security specifications (`CA.L1`, `CA.L2`). |
| **MITRE ATT&CK Enterprise** | Threat kill-chain taxonomy (`CA.Mitre`), risk mapping (`CA.Risk`). |
| **NIST SP 800-162 & 800-41** | ABAC policy rules (`CA.ABAC`), network zoning (`CA.Net`). |
| **NIST SP 800-34** | Business process criticality & RTO/RPO metrics (`CA.Proc`). |
| **Ukrainian Laws & Regulations** | Laws of Ukraine No. 80/94-VR, No. 2657-XII, No. 2155-VIII; Regulatory Orders №409 and №419. |
| **НД ТЗІ Standards** | НД ТЗІ 1.1-002-99, 2.5-004-99, 2.5-005-99, 2.5-008-02, 2.5-010-03, 1.6-005-22, 2.3-025-24, 2.6-001-11, 3.6-006-24, 3.7-003-23. |
| **National Cryptographic Standards** | DSTU 4145-2002 (ECDSA digital signature), DSTU 7564-2014 (Kupyna hash function). |

---

## License & Maintainers

- **Maintainer**: Namdak Tonpa
- **Repository**: [github.com/synrc/cm](https://github.com/synrc/cm)
- **License**: [ISC License](LICENSE)
