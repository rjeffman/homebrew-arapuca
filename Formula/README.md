# Arapuca Homebrew Formula

This directory contains the Homebrew formula for arapuca.

## For Tap Maintainers

To create the homebrew-arapuca tap repository:

1. **Create a new repository** named `homebrew-arapuca` on GitHub

2. **Initialize the repository**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/homebrew-arapuca.git
   cd homebrew-arapuca

   # Copy the formula
   mkdir -p Formula
   cp /path/to/arapuca/Formula/arapuca.rb Formula/

   # Create a README
   cat > README.md << 'EOF'
   # Homebrew Arapuca

   Homebrew tap for [arapuca](https://github.com/LeGambiArt/arapuca) - a cross-platform process sandbox.

   ## Installation

   ```bash
   brew tap LeGambiArt/arapuca
   brew install arapuca
   ```

   ## Development

   Test the formula locally:

   ```bash
   brew install --build-from-source Formula/arapuca.rb
   brew test arapuca
   brew audit --strict arapuca
   ```
   EOF

   git add .
   git commit -m "Initial commit: Add arapuca formula"
   git push origin main
   ```

3. **Calculate SHA256** for the release:
   ```bash
   # Use the provided script
   ./scripts/update-homebrew-formula.sh 0.2.1

   # Or manually
   wget https://github.com/LeGambiArt/arapuca/archive/refs/tags/v0.2.1.tar.gz
   shasum -a 256 v0.2.1.tar.gz
   ```

4. **Update the formula** with the SHA256 checksum

## For Users

Install arapuca via Homebrew:

```bash
# Add the tap
brew tap LeGambiArt/arapuca

# Install
brew install arapuca

# Or in one command
brew install LeGambiArt/arapuca/arapuca
```

### Install from HEAD

```bash
brew install --HEAD LeGambiArt/arapuca/arapuca
```

## What Gets Installed

The formula installs:

- **Binaries**: `arapuca` (and `arapuca-agent` on Linux with microvm feature)
- **Library**: `libarapuca.dylib` (macOS) or `libarapuca.so` (Linux)
- **Static library**: `libarapuca.a`
- **Header**: `arapuca.h` for C FFI integration
- **pkg-config**: `arapuca.pc` for build system integration

## Platform Support

- **macOS**: Full support with Seatbelt sandbox
- **Linux**: Full support with Landlock, seccomp, and cgroups v2
- **Windows**: Not supported via Homebrew (use Cargo directly)

## Updating

When a new version is released:

```bash
# Use the helper script from the main arapuca repo
./scripts/update-homebrew-formula.sh <new-version>

# Or manually update Formula/arapuca.rb:
# - Update url to new version
# - Calculate and update sha256
# - Commit and push

git add Formula/arapuca.rb
git commit -m "Update arapuca to X.Y.Z"
git push origin main
```

Users can then upgrade:

```bash
brew update
brew upgrade arapuca
```

## Testing

Before releasing a formula update:

```bash
# Audit for issues
brew audit --strict --online arapuca

# Test installation
brew install --build-from-source arapuca

# Run tests
brew test arapuca

# Test uninstall
brew uninstall arapuca
```

## Links

- **Main repository**: https://github.com/LeGambiArt/arapuca
- **Homebrew documentation**: https://docs.brew.sh/Formula-Cookbook
- **Issue tracker**: https://github.com/LeGambiArt/arapuca/issues
