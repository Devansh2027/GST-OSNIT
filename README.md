# 🔍 GST-OSINT: Intelligence & Verification Tool

![Perl Version](https://img.shields.io/badge/Perl-v5.14+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![OSINT](https://img.shields.io/badge/Category-OSINT-orange.svg)

**GST-OSINT** is a robust command-line utility built in Perl designed to automate the validation and investigation of Indian Goods and Services Tax Identification Numbers (GSTIN). It bridges the gap between basic format checking and deep-dive business intelligence.

---

## 📖 Project Description

In modern financial ecosystems, manual verification of vendor tax identities is a significant bottleneck. **GST-OSINT** solves this by providing a dual-layered investigative approach:

### The Problem it Solves:
* **Fraud Prevention:** Instantly identifies mathematically "fake" or mistyped GSTINs using local cryptographic validation.
* **Compliance Automation:** Simplifies vendor onboarding by fetching real-time registration status and filing history.
* **Intelligence Gathering:** Decodes the internal structure of a GSTIN to reveal the State of origin, the linked PAN, and the business's tax-paying behavior.

### How it Works:
1.  **Mathematical Layer:** The tool implements the **ISO 7064 Mod 36, 37** algorithm. It calculates the check-digit of the input GSTIN locally to ensure authenticity before ever making a network request.
2.  **OSINT Layer:** Utilizing public endpoints and scraping techniques, the tool pulls the Legal Name, Trade Name, Business Constitution, and the most recent GSTR-1 and GSTR-3B filing records.

---

## 🌟 Key Features

* **Offline Validation:** Regex-based format checks + Modulo-36 checksum verification.
* **State Decoding:** Instant mapping for all 38 Indian State/UT codes.
* **Deep Business Lookup:** Real-time data including Business Status (Active/Inactive), Taxpayer Type, and Jurisdiction Wards.
* **HSN/SAC Analytics:** Displays the primary goods and services the entity is registered to provide.
* **Filing History Table:** A clean, scannable table showing the last several tax filing periods.

---

## 🛠️ Prerequisites & Setup

### Requirements
* **Perl Version:** `v5.14.0` or higher.
* **Dependencies:** `LWP::UserAgent`, `JSON`, and `LWP::Protocol::https`.

### Installation
1.  **Clone the repository:**
    ```bash
    git clone https://github.com/Devansh2027/GST-OSNIT
    cd gst-osint-perl
    ```

2.  **Install dependencies via CPAN:**
    ```bash
    cpan install LWP::UserAgent JSON LWP::Protocol::https
    ```

---

## 🚀 Usage Guide

Run the script from your terminal:
```bash
perl gst_osint.pl
