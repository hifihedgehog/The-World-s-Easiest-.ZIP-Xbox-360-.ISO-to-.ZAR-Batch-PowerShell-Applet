# The World's Easiest Bulk .ZIP Xbox 360 .ISO to .ZAR PowerShell Applet

**It's stupid easy now. Reclaim your device's disk space. Compress your jumbo library of .ZIP files of Xbox 360 .ISOs down into one mean and lean, Xenia Canary .ZAR-reducing machine.**

All dependencies included. No batteries needed. Just run the `.ps1` file. It'll prompt you for everything. You can also stop and pick up later. It cleans up after itself!

## Prerequisites

- **Windows PowerShell**: This script requires PowerShell to run.
- **7-Zip**: Used for extracting `.zip` files.
- **extract-xiso**: Used to extract Xbox 360 ISO images.
- **ZArchive**: Used for compressing extracted content into `.zar` files.

These executables are included in the repository for your convenience.

## How to Run

1. **Download the Repository**: Clone or download the repository to your local machine.
2. **Run the Script**: Right-click on the `.ps1` script and select "Run with PowerShell."
3. **Follow the Prompts**: You will be asked to select the folder containing `.zip` files and a destination folder for `.zar` files.
4. **Let It Do Its Thing**: The script will extract, convert, and compress each `.zip` file. You can stop and restart anytime; it will skip files that have already been converted.

## Features

- **Interactive Folder Selection**: The script will prompt you to choose the source and destination folders, making it easy to get started.
- **Automatic Cleanup**: All temporary files and folders are automatically cleaned up after each conversion, ensuring minimal clutter.
- **Pause and Resume**: You can stop the script at any time and continue from where you left off.

## Dependencies and Licenses

### 7-Zip
- **License**: GNU LGPL
- **Link**: [7-Zip Official Website](https://www.7-zip.org/)

### extract-xiso
- **License**: Berkeley Software License
- **Link**: [extract-xiso GitHub Repository](https://github.com/XboxDev/extract-xiso)

### ZArchive
- **License**:  MIT No Attribution
- **Link**: [ZArchive GitHub Repository](https://github.com/Exzap/ZArchive)

## Example Output

- **Total Files Converted**: The script provides a summary of how many `.zip` files have been converted to `.zar` files.
- **Logs**: Detailed logs are printed in the PowerShell window, showing progress and any skipped files.

## Notes

- Ensure you have **read/write permissions** for the folders you select.
- The script is designed only for zipped Xbox 360 `.iso` files.
- Tested on Windows 10, PowerShell version 5.1.
- It's best to run the applet on your fastest drive on your machine. This will speed up conversion since the temporary files and folders it uses for processing are written and read where this is extracted and run.

## Disclaimer

This script and associated executables are provided "as-is" without any warranty. Use at your own risk.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Credits

- **7-Zip** by Igor Pavlov
- **extract-xiso** by XboxDev
- **ZArchive** by Exzap

