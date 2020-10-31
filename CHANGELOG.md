# Changelog

## Unreleased

### 2.0 ~ In Beta-Testing

#### Interface
* Cleaned look of trays
* Implemented empty data image
  * Appears when user has no trays or no items in a selected tray
* Redesigned icons
* Redesigned settings screen
  * Now has icons instead of subtitles
* Confirm button attaches to top of keyboard
  * Previously appeared under the input field
* Decided on optimal size for high-priority add button
  * 66x66pt
* Cleaned edges of app icon
* Made use of built-in navigation bar
  * Creates cleaner animations and less visual glitches
* Shrunk font size of items for a more modern appearance
  * Also thinned the line that crosses each item out
* Other minimal font size/weight changes across app

#### App Store
* Redesigned preview images/videos

#### Back-end
* Refactored entire code base
  * More object-oriented approach
    * Implemented protocols
  * Implemented a theme manager
    * Manages light/dark mode
    * Manages colors when entering a tray
  * Simplified extensions
  * Removed unused animations, classes, etc.
  * Fine-tuned animations
  * Deprecated custom navigation bar, implemented built-in navigation bar
  * Rewrote CoreData handling
  	* Data cycle simplified
  	* Uses reverse index paths instead of reversing array to display correctly ordered data
* Reorganized file structure
* Layout is more flexible for different screen sizes
  * Progress circle layout issues fixed
  * Views scale accordingly

---

## Released

### 1.1 ~ 2020-5-11

#### Interface
* Refurbished tray editing menu
  * Now a presented UIViewController rather than a UIView

#### Back-end
* Refactored code
* Reorganized files
* Renamed confusingly named classes, variables, etc.
* Restructured most used classes

### 1.0 ~ 2020-2-1
🥳 Trayful released to the App Store

