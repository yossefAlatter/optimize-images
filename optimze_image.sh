#!/bin/bash

# --- Configuration ---
# 1. WebP Quality (0-100). Lower is smaller/lower quality.
MAX_QUALITY=75

# 2. Maximum Output Width (in pixels). Set to 0 to skip resizing.
# Example: 1920 is a common max width for web images.
MAX_WIDTH=1280

# 3. Highest Compression Method (6 is best but slowest).
COMPRESSION_METHOD=6

# --- Usage and Input Validation ---
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_directory> <output_directory>"
    echo "Example: $0 images/ optimized_images/"
    exit 1
fi

INPUT_DIR="$1"
OUTPUT_DIR="$2"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

echo "Starting image optimization and resizing..."
echo "Input Directory: $INPUT_DIR"
echo "Output Directory: $OUTPUT_DIR"
echo "Target WebP Quality: $MAX_QUALITY"
echo "Maximum Width: $MAX_WIDTH pixels (0 = no resize)"
echo "---"

# --- Prerequisites Check ---
if ! command -v convert &> /dev/null
then
    echo "ERROR: 'convert' command (ImageMagick) is required for resizing but not found."
    echo "Please install it: sudo apt install imagemagick"
    exit 1
fi

if ! command -v cwebp &> /dev/null
then
    echo "ERROR: 'cwebp' command (libwebp-tools) is required but not found."
    echo "Please install it: sudo apt install libwebp-tools (or webp)"
    exit 1
fi
echo "Tools check successful."
echo "---"


# --- Main Processing Loop ---
find "$INPUT_DIR" -type f | while read -r IMAGE_PATH; do
    FILENAME=$(basename "$IMAGE_PATH")
    
    # Define a temporary file for the resized image before WebP conversion
    # We use a temp directory to ensure the original files are never overwritten
    TEMP_FILE="/tmp/resized_temp_$(uuidgen)_${FILENAME}" 
    OUTPUT_FILE="${OUTPUT_DIR}/${FILENAME%.*}.webp"

    FILE_TYPE=$(file --brief --mime-type "$IMAGE_PATH")

    if [[ "$FILE_TYPE" == image/* ]]; then
        echo "Processing: $FILENAME ($FILE_TYPE)"
        
        # 1. Resize the image using ImageMagick's convert command
        # Check if resizing is necessary (MAX_WIDTH > 0)
        if [ "$MAX_WIDTH" -gt 0 ]; then
            # 'convert' resizes the image. '> ${MAX_WIDTH}' means resize ONLY if the width is greater than MAX_WIDTH.
            # -strip removes all metadata (e.g., Exif) to reduce size further.
            convert "$IMAGE_PATH" -strip -resize "${MAX_WIDTH}x>" "$TEMP_FILE" 2>/dev/null
            RESIZE_STATUS=$?
            INPUT_TO_CONVERT="$TEMP_FILE"
        else
            RESIZE_STATUS=0
            INPUT_TO_CONVERT="$IMAGE_PATH"
        fi

        if [ $RESIZE_STATUS -eq 0 ]; then
            echo "   -> Dimensions set to max width: $MAX_WIDTH"

            # 2. Convert to WEBP and minimize
            # Use -q for quality and -m for maximum compression effort
            cwebp -q $MAX_QUALITY -m $COMPRESSION_METHOD "$INPUT_TO_CONVERT" -o "$OUTPUT_FILE" 2>/dev/null
            
            if [ $? -eq 0 ]; then
                echo "   -> Converted and Minimized to $OUTPUT_FILE"
            else
                echo "   -> ERROR: WebP conversion failed for $FILENAME."
            fi
        else
            echo "   -> ERROR: Resizing failed for $FILENAME."
        fi

    else
        echo "⚠️ Skipping: $FILENAME (Not a recognized image format: $FILE_TYPE)"
    fi
    
    # 3. Clean up the temporary file if it was created
    if [ -f "$TEMP_FILE" ]; then
        rm "$TEMP_FILE"
    fi

done

echo "---"
echo "Optimization and Resizing complete!"