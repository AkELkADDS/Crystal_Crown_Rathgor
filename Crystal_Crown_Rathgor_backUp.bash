#!/bin/bash
# backup.bash: pull all BG3 Mod Project files into a single place for source code management
# by mstephenson6, see guide at https://mod.io/g/baldursgate3/r/git-backups-for-mod-projects

set -e;

# TODO Set MOD_SUBDIR_NAME here, example:
# MOD_SUBDIR_NAME="CircleOfTheSpores_db7e15fd-b2fc-b159-4bbd-1baab34d8c3a"
# Look in "C:\Program Files (x86)\Steam\steamapps\common\Baldurs Gate 3\Data\Projects"
# for names of mods you have already started
MOD_SUBDIR_NAME=""

# This is the MinGW64 path to a Steam install of the toolkit#!/bin/bash
# backup.bash: Pull BG3 mod project files into a single location for Git backup
# by mstephenson6 - modified by request, with logging and safety checks

# Stop the script if any command fails
set -e

# --- CONFIGURATION ---

# Set this to your mod's folder name (as it appears in BG3's project directories)
MOD_SUBDIR_NAME="CCrwn_Rathgor_34d5ad47-7a9a-c579-abba-f67a0c10f365"

# Path to the Baldur’s Gate 3 Data directory (can be adjusted if needed)
BG3_DATA="E:/El/Games/Steam/steamapps/common/Baldurs Gate 3/Data"

# These are the standard subdirectories used for mod files
SUBDIR_LIST=(
  "Projects"
  "Editor/Mods"
  "Mods"
  "Public"
  "Generated/Public"
)

# --- SAFETY CHECKS ---

# Check that MOD_SUBDIR_NAME was filled in (avoids copying from an empty string)
if [ -z "$MOD_SUBDIR_NAME" ]; then
  echo "[ERROR] MOD_SUBDIR_NAME is not set in the script."
  exit 1
fi

# Check that the BG3 data path exists
if [ ! -d "$BG3_DATA" ]; then
  echo "[ERROR] BG3_DATA path not found: $BG3_DATA"
  exit 1
fi

# --- MAIN SCRIPT ---

# Show what we're about to back up
echo "[INFO] Backing up mod: $MOD_SUBDIR_NAME"
echo "[INFO] From BG3 data folder: $BG3_DATA"
echo

# Loop through each subdirectory and copy over any mod folders that exist
for subdir in "${SUBDIR_LIST[@]}"; do
  SRC="$BG3_DATA/$subdir/$MOD_SUBDIR_NAME"   # Full path to source mod folder
  DEST="$subdir/$MOD_SUBDIR_NAME"            # Destination path for backup

  # Skip if source directory doesn't exist
  if [ ! -d "$SRC" ]; then
    echo "[SKIP] $SRC not found"
    continue
  fi

  echo "[COPY] $SRC -> $DEST"

  # Delete existing copy if there is one
  rm -rf "$DEST"

  # Make sure the destination parent directory exists
  mkdir -p "$(dirname "$DEST")"

  # Copy the mod folder (with all contents) from BG3 data into this Git folder
  cp -a "$SRC" "$DEST"
done

# --- GIT BACKUP ---

echo
echo "[INFO] Committing changes to Git"

# Stage all changes
git add --all

# Commit with timestamp message
git commit -m "Backup at $(date)"

# Push to remote repository
git push

# Done
echo "[DONE] Backup complete."

BG3_DATA="/c/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data"

# These are set according to "Understanding the Mod Locations", as of Nov 2024, from
# https://mod.io/g/baldursgate3/r/getting-started-creating-a-new-mod
SUBDIR_LIST=(
	"Projects"
	"Editor/Mods"
	"Mods"
	"Public"
	"Generated/Public"
)

if [ -z "$MOD_SUBDIR_NAME" ]; then
	echo "MOD_SUBDIR_NAME must have a value in $(basename $BASH_SOURCE)";
	return 1 2>/dev/null;
	exit 1;
fi

for subdir in "${SUBDIR_LIST[@]}"; do
	rm -rf "$subdir/$MOD_SUBDIR_NAME";
	SRC_ABS_PATH="$BG3_DATA/$subdir/$MOD_SUBDIR_NAME";
	if [ ! -d "$SRC_ABS_PATH" ]; then
		continue;
	fi
	mkdir -p $subdir;
	cp -a "$SRC_ABS_PATH" "$subdir";
done;

git add --all
git commit -m "Backup at `date`"
git push
