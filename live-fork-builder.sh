#!/bin/bash

# Exit script on any error
set -e

# Configuration Variables
BRAND_NAME="BootComposer"
WP_LATEST="https://wordpress.org/latest.zip"  # Official WordPress download link
BOOTSCORE_REPO="https://github.com/bootscore/bootscore.git"  # Bootscore GitHub repo

# List of URLs to download plugins
PLUGIN_URLS=(
   # TO DO :: ADD Links to Latest Versions of the MU-plugins
    "https://example.com/plugin1.zip"
   
)

# Step 1: Download and Extract the Latest WordPress Version
echo "Downloading the latest version of WordPress..."
curl -O $WP_LATEST
unzip latest.zip
rm latest.zip
cd wordpress  # Enter the extracted WordPress directory

# Step 2: Rename WordPress Branding and Core References
echo "Updating branding to $BRAND_NAME..."
find . -type f \( -name "*.php" -o -name "*.css" \) -exec sed -i "s/WordPress/$BRAND_NAME/g" {} \;
find . -type f -name "*.php" -exec sed -i "s/'wp-/'bc-/g" {} \;

# Step 3: Remove Default Themes
echo "Removing default themes..."
rm -rf wp-content/themes/twentytwenty*

# Step 4: Clone the Latest Version of Bootscore Theme
echo "Cloning the latest version of Bootscore theme from GitHub..."
git clone --depth=1 $BOOTSCORE_REPO wp-content/themes/bootscore
rm -rf wp-content/themes/bootscore/.git  # Remove the .git directory to keep it clean

# Step 5: Download and Install Plugins to mu-plugins Directory
echo "Downloading and adding plugins to mu-plugins directory..."
mkdir -p wp-content/mu-plugins

for url in "${PLUGIN_URLS[@]}"; do
    echo "Downloading plugin from $url..."
    plugin_zip="${url##*/}"  # Extract the file name from URL
    curl -L -o "$plugin_zip" "$url"  # Download the plugin zip file
    unzip -q "$plugin_zip" -d wp-content/mu-plugins/  # Unzip into mu-plugins
    rm "$plugin_zip"  # Clean up the zip file
done

# Step 6: Create Custom Branding and Admin Updates ::: TODO

# Completion Message
echo "$BRAND_NAME setup complete. WordPress installation is customized and rebranded as $BRAND_NAME."
