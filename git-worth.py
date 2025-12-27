#!/usr/bin/env python3
"""
git-worth: Estimate the development value of your git repository.
Run this inside any git repository to see your project's worth!
"""
import subprocess
import os
import sys
import platform

# --- SETTINGS ---
YOUR_HOURLY_RATE = 20.00  # What would a company pay you per hour?

# Production-ready app target (based on industry estimates)
# A typical MVP/production app: ~5K-10K LOC, ~100+ dev days, ~500+ commits
# At $75/hr market rate, this translates to roughly $50K-$150K
PRODUCTION_TARGET = 50_000  # Your goal: what's a "complete" app worth to you?


def run_cmd(cmd, shell_cmd=None):
    """Run a command cross-platform. Returns output or None on failure."""
    try:
        if platform.system() == "Windows" and shell_cmd:
            # Use PowerShell for complex commands on Windows
            result = subprocess.check_output(
                ["powershell", "-Command", shell_cmd],
                stderr=subprocess.DEVNULL
            )
        else:
            result = subprocess.check_output(cmd, shell=True, stderr=subprocess.DEVNULL)
        return result.decode().strip()
    except (subprocess.CalledProcessError, FileNotFoundError):
        return None


def get_git_metadata():
    """Get total commits, unique days worked, and lines of code."""
    # Get commit dates
    log_output = run_cmd("git log --format=%ad --date=short")
    if not log_output:
        return 0, 0, 0
    
    log_data = log_output.splitlines()
    unique_days = len(set(log_data))
    total_commits = len(log_data)
    
    # Get total lines of code (cross-platform)
    files_output = run_cmd("git ls-files")
    if not files_output:
        return unique_days, total_commits, 0
    
    files = files_output.splitlines()
    total_loc = 0
    
    # Directories to skip
    skip_dirs = {'node_modules', 'vendor', '.git', '__pycache__', 'venv', 
                 '.venv', 'dist', 'build', '.next', 'target', 'coverage'}
    
    for filepath in files:
        # Skip vendor directories
        if any(skip_dir in filepath for skip_dir in skip_dirs):
            continue
        
        # Skip binary/non-text files by extension
        binary_exts = {'.png', '.jpg', '.jpeg', '.gif', '.ico', '.pdf', 
                       '.zip', '.tar', '.gz', '.exe', '.dll', '.so', '.pyc'}
        if any(filepath.lower().endswith(ext) for ext in binary_exts):
            continue
        
        try:
            with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                total_loc += sum(1 for line in f if line.strip())
        except (IOError, OSError):
            continue
    
    return unique_days, total_commits, total_loc


def calculate_worth():
    """Calculate the project's estimated worth."""
    days, commits, loc = get_git_metadata()
    
    # 1. Base Labor Value (Assuming 4 hours of 'deep work' per active git day)
    labor_value = days * 4 * YOUR_HOURLY_RATE
    
    # 2. Intellectual Property Value (The 'Product' factor)
    # Every 100 lines of code is worth roughly 1 hour of architectural 'worth'
    ip_value = (loc / 100) * YOUR_HOURLY_RATE
    
    # 3. Momentum Bonus (Each commit adds 'liquidity' to the project)
    momentum_bonus = commits * 10
    
    total_worth = labor_value + ip_value + momentum_bonus
    
    return {
        "total": total_worth,
        "labor": labor_value,
        "ip": ip_value,
        "momentum": momentum_bonus,
        "days": days,
        "commits": commits,
        "loc": loc
    }


def progress_bar(current, target, width=20):
    """Generate a visual progress bar."""
    percent = min(current / target, 1.0) if target > 0 else 0
    filled = int(width * percent)
    bar = "█" * filled + "░" * (width - filled)
    return bar, percent * 100


def get_milestone_message(percent):
    """Return encouraging message based on progress."""
    if percent >= 100:
        return "🎉 PRODUCTION READY! Ship it!"
    elif percent >= 75:
        return "🔥 Almost there! Final stretch!"
    elif percent >= 50:
        return "💪 Halfway to production!"
    elif percent >= 25:
        return "🚧 Building momentum..."
    else:
        return "🌱 Just getting started!"


def print_report(data):
    """Print the project equity report."""
    # Colors (disabled on Windows cmd which doesn't support ANSI by default)
    if platform.system() == "Windows":
        GREEN, RESET = "", ""
    else:
        GREEN, RESET = "\033[1;32m", "\033[0m"
    
    print("\n" + " 💰 PROJECT EQUITY REPORT ".center(44, "="))
    print(f"  Project Age (Active Days): {data['days']} days")
    print(f"  Codebase Size:             {data['loc']:,} lines")
    print(f"  Total Commits:             {data['commits']:,}")
    print("-" * 44)
    print(f"  Labor Investment:         ${data['labor']:,.2f}")
    print(f"  IP & Architecture:        ${data['ip']:,.2f}")
    print(f"  Momentum Bonus:           ${data['momentum']:,.2f}")
    print("-" * 44)
    print(f"  TOTAL ESTIMATED WORTH:    {GREEN}${data['total']:,.2f}{RESET}")
    print("=" * 44)
    
    # Production target progress
    bar, percent = progress_bar(data['total'], PRODUCTION_TARGET)
    remaining = max(0, PRODUCTION_TARGET - data['total'])
    
    print(f"\n  🎯 PRODUCTION TARGET: ${PRODUCTION_TARGET:,.0f}")
    print(f"     [{bar}] {percent:.1f}%")
    if remaining > 0:
        print(f"     ${remaining:,.0f} to go")
    print(f"     {get_milestone_message(percent)}")
    print()


def main():
    """Main entry point."""
    if not os.path.exists(".git"):
        print("❌ Error: Not a git repository!")
        print("   Run this command inside a git project folder.")
        sys.exit(1)
    
    # Check if there are any commits
    if run_cmd("git rev-parse HEAD") is None:
        print("⚠️  No commits yet! Make your first commit to get started.")
        sys.exit(0)
    
    stats = calculate_worth()
    print_report(stats)


if __name__ == "__main__":
    main()
