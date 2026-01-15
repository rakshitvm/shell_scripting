# shell_scripting

# shell_scripting

#!/bin/bash

CONFIG_FILE="sig.conf"

# Allowed values
COMPONENTS=("INGESTOR" "JOINER" "WRANGLER" "VALIDATOR")
SCALES=("MID" "HIGH" "LOW")
VIEWS=("Auction" "Bid")

# Function to validate single choice input
validate_choice() {
    local input="$1"
    shift
    local options=("$@")
    for opt in "${options[@]}"; do
        if [[ "$input" == "$opt" ]]; then
            return 0
        fi
    done
    return 1
}

# Read Component Name
while true; do
    read -p "Enter Component Name [INGESTOR/JOINER/WRANGLER/VALIDATOR]: " comp
    if validate_choice "$comp" "${COMPONENTS[@]}"; then
        break
    else
        echo "Invalid input. Choose one of: ${COMPONENTS[*]}"
    fi
done

# Read Scale
while true; do
    read -p "Enter Scale [MID/HIGH/LOW]: " scale
    if validate_choice "$scale" "${SCALES[@]}"; then
        break
    else
        echo "Invalid input. Choose one of: ${SCALES[*]}"
    fi
done

# Read View
while true; do
    read -p "Enter View [Auction/Bid]: " view
    if validate_choice "$view" "${VIEWS[@]}"; then
        break
    else
        echo "Invalid input. Choose one of: ${VIEWS[*]}"
    fi
done

# Read Count (single digit number)
while true; do
    read -p "Enter Count [0–9]: " count
    if [[ $count =~ ^[0-9]$ ]]; then
        break
    else
        echo "Invalid input. Enter a single digit number (0–9)."
    fi
done

# Determine line pattern and replacement
if [[ "$view" == "Auction" ]]; then
    prefix="vdopiasample-etl=$count"
else
    prefix="vdopiasample-bid-etl=$count"
fi

new_line="${view} ; ${scale} ; ${comp} ; ETL ; ${prefix}"

echo ""
echo "Updating config file: $CONFIG_FILE"
echo "Replacement line will be:"
echo "$new_line"
echo ""

# Check file existence
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "ERROR: Config file '$CONFIG_FILE' not found!"
    exit 1
fi

# Create search pattern:
# - matches view and component if exists
pattern="^(${view}[[:space:]];.${scale}[[:space:]];.${comp})"

# Use sed to replace only the matching line
# If multiple similar lines exist, this replaces the first match only
if grep -qE "$pattern" "$CONFIG_FILE"; then
    sed -i "0,/$pattern/ s|.*|$new_line|" "$CONFIG_FILE"
    echo "Config updated successfully."
else
    echo "No matching line found for pattern: $pattern"
    echo "Appending new line to config file."
    echo "$new_line" >> "$CONFIG_FILE"
fi
