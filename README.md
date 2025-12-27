# 💰 git-worth

> Estimate the development value of your git repository

Ever wondered how much your side project is *actually* worth? `git-worth` analyzes your git history and codebase to estimate your project's value based on:

- **Labor Investment** — Active development days × hours × your rate
- **IP & Architecture** — Lines of code as a proxy for complexity
- **Momentum Bonus** — Commit frequency as a measure of project "liquidity"

```
========== 💰 PROJECT EQUITY REPORT ==========
  Project Age (Active Days): 45 days
  Codebase Size:             3,200 lines
  Total Commits:             156
--------------------------------------------
  Labor Investment:         $3,600.00
  IP & Architecture:        $640.00
  Momentum Bonus:           $1,560.00
--------------------------------------------
  TOTAL ESTIMATED WORTH:    $5,800.00
============================================

  🎯 PRODUCTION TARGET: $50,000
     [██░░░░░░░░░░░░░░░░░░] 11.6%
     $44,200 to go
     🌱 Just getting started!
```

## 📦 Installation

### Linux & macOS

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/git-worth.git
cd git-worth

# Run the installer
./install.sh
```

Or manually:
```bash
# Copy to your bin directory
cp git-worth.py ~/.local/bin/git-worth
chmod +x ~/.local/bin/git-worth

# Make sure ~/.local/bin is in your PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc  # or ~/.bashrc
source ~/.zshrc
```

### Windows

```powershell
# Clone the repo
git clone https://github.com/YOUR_USERNAME/git-worth.git
cd git-worth

# Run the installer (PowerShell)
.\install.ps1
```

Or manually:
```powershell
# Create scripts folder
mkdir "$env:USERPROFILE\.local\bin" -Force

# Copy files
cp git-worth.py "$env:USERPROFILE\.local\bin\"

# Create wrapper script
echo '@python "%~dp0git-worth.py" %*' > "$env:USERPROFILE\.local\bin\git-worth.cmd"

# Add to PATH (run once)
$path = [Environment]::GetEnvironmentVariable("Path", "User")
[Environment]::SetEnvironmentVariable("Path", "$env:USERPROFILE\.local\bin;$path", "User")
```

## 🚀 Usage

Navigate to any git repository and run:

```bash
git-worth
```

That's it! The script will analyze your repo and display the equity report.

## ⚙️ Configuration

Edit the settings at the top of `git-worth.py` (or `~/.local/bin/git-worth`):

```python
# --- SETTINGS ---
YOUR_HOURLY_RATE = 20.00  # What would a company pay you per hour?
PRODUCTION_TARGET = 50_000  # Your goal: what's a "complete" app worth?
```

### Suggested Hourly Rates

| Experience Level | Rate |
|-----------------|------|
| Junior Developer | $30-50/hr |
| Mid-Level Developer | $50-100/hr |
| Senior Developer | $100-200/hr |
| Industry Average (US) | ~$75/hr |

## 🧮 How It Works

The valuation uses three components:

1. **Labor Value** = `active_days × 4hrs × hourly_rate`
   - Assumes ~4 hours of deep work per active git day

2. **IP Value** = `(lines_of_code / 100) × hourly_rate`
   - Every 100 lines ≈ 1 hour of architectural worth

3. **Momentum Bonus** = `total_commits × $10`
   - Each commit adds "liquidity" to the project

**Total Worth** = Labor + IP + Momentum

> ⚠️ **Disclaimer**: This is a fun motivational tool, not a formal appraisal. Real software valuations depend on revenue, market, users, and many other factors.

## 📋 Requirements

- **Python 3.6+**
- **Git** (obviously!)

## 🤝 Contributing

Feel free to open issues or PRs! Ideas for improvements:

- [ ] Add language-specific LOC analysis
- [ ] Track worth over time
- [ ] Export reports to JSON/Markdown
- [ ] Git hook integration

## 📄 License

MIT License — Do whatever you want with it! 🎉

---

**Keep building! Every commit adds equity. 🚀**

