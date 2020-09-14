# Changelog

All notable changes to this project will be documented in this file, in reverse chronological order by release.

## 1.0.0 - TBD

This is the initial 1.0.0 release under the Laminas organization.

### Added

- Adds descriptions for shipped Composer commands.

### Changed

- Bumps the minimum supported PHP version to 7.3.

- Improves the shipped Dockerfile and default extensions available.

### Deprecated

- Nothing.

### Removed

- Removes the `public/index.html` page, which could lead to display of the default Apache2 landing page.

### Fixed

- Ensures initial page presentation looks as expected, including logo display, no duplication, proper 404 display, etc.

- Ensures Zend Framework is no longer referenced in all commands, documentation, and default pages.
