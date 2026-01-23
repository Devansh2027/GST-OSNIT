# 🔍 GST-OSINT: Perl Intelligence Tool

A professional-grade OSINT (Open Source Intelligence) and verification tool for Indian GST Identification Numbers (GSTIN). This script allows for both **Instant Offline Validation** and **Deep Online Intelligence** gathering using Perl.

---

## 🌟 Features

### 1. Offline Verification
- **Format Validation:** Regex-based checks for the 15-digit structure.
- **State Decoding:** Automatically identifies the registration state from the first two digits (e.g., 07 - Delhi, 27 - Maharashtra).
- **PAN Extraction:** Isolates the entity's PAN directly from the GSTIN.
- **Mod-36 Checksum:** Implements the mathematical validation to detect fake or mistyped GST numbers without an internet connection.

### 2. Online OSINT Lookup
- **Entity Details:** Retrieves Legal Name, Trade Name, and Registration Date.
- **Status Check:** Real-time status (Active/Cancelled/Suspended).
- **Jurisdiction:** Identifies both Central and State jurisdiction wards.
- **HSN/SAC Summary:** Lists the goods and services the business is registered for.
- **Filing Intelligence:** Displays a table of the latest GSTR filings, financial years, and tax periods.

---

## 🛠️ Prerequisites

### Minimum Requirements
* **Perl Version:** `v5.14.0` or higher (Uses the `/r` and `//` operators).
* **System:** Works on Linux, macOS, and Windows (via Strawberry Perl).

### Dependency Installation
This tool requires a few CPAN modules for web requests and JSON handling. Install them by running:

```bash
cpan install LWP::UserAgent JSON LWP::Protocol::https
