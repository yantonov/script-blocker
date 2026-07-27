# script-blocker

A tiny extension that blocks specific scripts through a declarative rule system, without depending on browser support or other extensions.

## Table of Contents

* [Usage](#usage)

  * [1. Generate rules](#1-generate-rules)
  * [2. Build the extension](#2-build-the-extension)
* [Install in Firefox / Waterfox](#install-in-firefox--waterfox)

  * [Temporary installation (development)](#temporary-installation-development)
  * [Install from XPI](#install-from-xpi)
* [Build artifacts](#build-artifacts)

## Usage

### 1. Generate rules

Generate the extension rules file:

```sh
./bin/generate-rules.sh
```

This creates the `rules.json` file used by the extension during runtime.

The generated rules file is included in the extension build and should be regenerated whenever blocking rules are changed.

### 2. Build the extension

Build the Firefox/Waterfox extension package:

```sh
./bin/build.sh
```

The build process creates the installable extension artifact in the `target/` directory.

The final extension package:

```text
target/script-blocker.xpi
```

The `target/` directory contains the built extension ready for installation.

Example workflow:

```sh
./bin/generate-rules.sh
./bin/build.sh

# Install:
target/script-blocker.xpi
```

## Install in Firefox / Waterfox

### Temporary installation (development)

1. Open:

```text
about:debugging
```

2. Select:

```text
This Firefox → Load Temporary Add-on
```

3. Choose:

```text
target/script-blocker.xpi
```

The extension will be loaded for testing.

### Install from XPI

Open:

```text
target/script-blocker.xpi
```

directly in Firefox or Waterfox and confirm installation.

## Build artifacts

After a successful build:

```text
target/
└── script-blocker.xpi
```

The `target/script-blocker.xpi` file is the distributable browser extension package.
