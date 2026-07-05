# SteamFast (v8.4) 🚀

**SteamFast** is a lightweight, high-performance plugin built for Steam clients via the **Millennium** framework. Designed and managed by **Ecren Studio**, SteamFast grants you deeper control over your Steam client's resource usage while tracking your gaming footprint.

---

## 🌟 Features

* **RAM Management:** Actively optimize and limit the memory footprint of sluggish `SteamWebHelper` processes.
* **Game History Tracker:** Review a detailed timeline of your recently played titles directly within Steam.
* **Deleted Games Log:** Keep track of games you have uninstalled from your local drives.
* **Average FPS Dashboard:** Monitor your benchmarked average frame rates across your gaming library.
* **Seamless Integration:** Adds a custom `steammeneage` button straight into the native Steam TitleBar.

---

## 🛠️ Installation

### Method 1: Automatic Installation (Recommended)
You can install both **Millennium** (if not already installed) and **SteamFast** automatically. Open **PowerShell** and execute the following command:

```powershell
irm [https://raw.githubusercontent.com/ecrenstudio/steamfast/main/install.ps1](https://raw.githubusercontent.com/ecrenstudio/steamfast/main/install.ps1) | iex
```

Method 2: Manual Installation
If you prefer to set things up yourself or are using a specific Release build:

Ensure you have Millennium installed in your Steam directory.

Download the latest release or clone this repository.

Locate your Steam installation folder (typically C:\Program Files (x86)\Steam).

Navigate to the plugins/ directory (create it if it doesn't exist).

Copy the content of the src/ folder from this repository into a new folder named steamfast inside plugins/.

Correct Path Structure: .../Steam/plugins/steamfast/plugin.json

Restart Steam completely.

thanks for use .


