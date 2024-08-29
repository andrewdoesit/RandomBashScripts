
#!/bin/bash

# Check if a directory is provided
if [ "$#" -ne 1 ]; then
        echo "Usage: $0 directory"
        exit 1
fi

# Store the input directory
input_directory="$1"

# Check if the input is a directory
if [ ! -d "$input_directory" ]; then
        echo "Error: '$input_directory' is not a valid directory."
        exit 1
fi

# Flag to check if any .webp files are found
found_files=false

# Iterate over all .webp files in the directory
for file in "$input_directory"/*.webp; do
        # Check if there are no .webp files
        if [ "$file" == "$input_directory/*.webp" ]; then
                echo "No .webp files found in the directory."
                exit 0
        fi

        # Remove the .webp extension from the file name
        filename_without_extension="${file%.webp}"

        # Get the base name without extension
        basename_without_extension=$(basename "$filename_without_extension")

		output_file="${input_directory}/${basename_without_extension}.png"
        dwebp "$file" -o "$output_file"

		if [ $? -eq 0 ]; then
            # Remove the original .webp file
            rm "$file"
            echo "Converted $file to $output_file and removed the original .webp file."
        else
            echo "Failed to convert $file."
        fi

        found_files=true
done

# If no .webp files were found, print the message
if [ "$found_files" = false ]; then
    echo "No .webp files found in the directory."
fi
