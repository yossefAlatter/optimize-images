Image Optimizer and Resizer (to WebP)

This Bash script automates the process of optimizing a directory of images for web usage. It performs three key functions:

Image Type Check: Uses file content (--mime-type) to ensure it's a valid image.

Dimension Reduction: Resizes images to a configurable maximum width (default 1280px).

WebP Conversion & Minimization: Converts the image to the highly efficient WebP format and applies maximum compression (-m 6) while maintaining a controlled quality level (-q 75).

🚀 How to Use

1. Make the Script Executable

Before running, ensure you have execution permissions:

chmod +x optimize_and_resize.sh


2. Run the Script

The script requires two arguments: the source folder and the destination folder.

./optimize_and_resize.sh <input_directory> <output_directory>


Example:

./optimize_and_resize.sh ./raw_photos ./optimized_for_web


⚙️ Configuration

You can easily adjust the script's behavior by modifying the variables at the top of the file:

Variable

Description

Default Value

Recommendation

MAX_QUALITY

The JPEG/WebP quality factor (0-100). Lower is smaller.

75

Keep between 75-85 for good quality, or try 50-60 for maximum file size reduction.

MAX_WIDTH

The maximum width (in pixels) for output images.

1280

Set this to match the maximum width of your HTML container (e.g., 1280px) to prevent users from downloading unnecessarily large images. Set to 0 to skip resizing.

COMPRESSION_METHOD

The effort level (0-6) for cwebp. 6 is max effort (slowest but smallest file size).

6

Leave at 6 for the best results.

🛠️ Prerequisites (Needed Packages)

This script relies on three essential command-line utilities: file, cwebp (WebP Tools), and convert (ImageMagick).

Tool

Purpose

Source Package (Debian/Ubuntu)

file

Content-based file type checking.

Typically pre-installed

cwebp

Converts and compresses to WebP format.

libwebp-tools or webp

convert

Resizes and strips metadata from images.

imagemagick

📦 Installation Steps

🐧 Linux (Debian/Ubuntu/WSL)

Update Package Lists:

sudo apt update


Install ImageMagick (for Resizing):

sudo apt install imagemagick


Install WebP Tools (for Conversion):

sudo apt install webp
# If 'webp' is not found, try: sudo apt install libwebp-tools


🍎 macOS (Using Homebrew)

You will need Homebrew (the macOS package manager) installed first. If you don't have it, install it by running the command found on the official Homebrew website.

Install ImageMagick (for Resizing):

brew install imagemagick


Install WebP Tools (for Conversion):

brew install webp


🪟 Windows (Using Chocolatey)

This script must be run inside an environment that supports Bash (like Git Bash or WSL).

You will need Chocolatey (the Windows package manager) installed first. If you don't have it, follow the instructions on the official Chocolatey website.

Install ImageMagick (for Resizing):

choco install imagemagick


Install WebP Tools (for Conversion):

choco install libwebp
