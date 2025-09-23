Global – System Utilities & AI Extensions
Overview

Global is a central collection of system utilities, scripts, and AI-powered extensions designed to support the Omniscient framework and other modular projects.

This repo serves as:

A toolbox of scripts and utilities for Linux systems.

A global namespace for shared modules between projects.

A staging area for experimental AI, OSINT, and DevOps workflows.

Features

🛠 Cross-project utilities – shared helpers for Omniscient and related repos.

🤖 AI Extensions – portable modules for Hugging Face, LangChain, and Ollama integration.

📦 Installers – system-wide and per-user setup scripts.

🧰 Tooling hub – bash, Python, and mixed-language scripts for forensics, monitoring, and automation.

Installation
Requirements

Python 3.9+

pip

Recommended: Linux (Debian/Ubuntu, Fedora tested)

Quick Start
# Clone repo
git clone https://github.com/MrSiebel585/global.git
cd global

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

Usage
Example Scripts
# Run system utility
bash scripts/system_check.sh

# Use AI-powered tool
python3 tools/ai_logger.py --file /var/log/syslog

As a Dependency

You can import global modules in your own Python project:

from global.utils import logger, parser

Project Structure
global/
│── scripts/          # Bash scripts for system automation
│── tools/            # AI-powered Python utilities
│── modules/          # Shared Python modules for integration
│── install/          # Setup & installer scripts
│── tests/            # Unit tests
│── requirements.txt
│── README.md

Roadmap

✅ Core utility scripts.

✅ Shared modules for Omniscient.

🔄 In progress: AI logging utilities.

🖥 Planned: web UI for global tools.

🔒 Planned: security-hardened installers.

Contributing

Fork repo

Create branch: git checkout -b feature/my-feature

Commit: git commit -m "Added new script"

Push: git push origin feature/my-feature

Submit PR

License

MIT License

⚡ Suggested /docs/ expansion:

docs/installation.md – advanced install paths

docs/usage.md – detailed examples

docs/modules.md – shared utilities explained

docs/roadmap.md – feature pipeline

Do you want me to generate a unified documentation style so both Omniscient and global have the same structure/voice (README + /docs folder), or should I keep them distinct since they serve different purposes?

Connectors
Sources

