#!/bin/bash

# setup fedora from scratch

# Define the folder names
folders=("applications" "dev" "source")

# Loop through the array and create the folders
for folder in "${folders[@]}"; do
    mkdir -p "$HOME/$folder"
done

echo "Folders created successfully!"


# Check if Firefox is installed on Fedora
if ! command -v firefox &>/dev/null; then
    echo "Firefox is not installed. Please install Firefox first."
    exit 1
fi

# Enable custom CSS
firefox_prefs="$HOME/.mozilla/firefox/*.default-release/user.js"
echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' >> "$firefox_prefs"

# Create "chrome" folder in the profile directory
firefox_profile_dir="$HOME/.mozilla/firefox/*.default-release"
mkdir -p "$firefox_profile_dir/chrome"

# Create "userChrome.css" file with the provided CSS code
css_code=$(cat <<EOF
#tabbrowser-tabs {
    visibility: collapse;
}
#navigator-toolbox {
    display: flex;
    flex-flow: row wrap;
}
#titlebar {
    order: 1;
    max-width: 146px;
}
#titlebar #TabsToolbar {
    background-color: var(--toolbar-bgcolor);
    background-image: var(--toolbar-bgimage)
}
#titlebar #TabsToolbar .titlebar-spacer {
    background-color: rgba(0,0,0,0.05);
    margin: 3px;
    border-radius: 25%;
    cursor: grab;
}
#titlebar #TabsToolbar .titlebar-spacer[type="pre-tabs"] {
    display: none;
}
#nav-bar {
    order: 0;
    width: calc(100% - 146px);
}
#PersonalToolbar {
    order: 2;
}
EOF
)

echo "$css_code" > "$firefox_profile_dir/chrome/userChrome.css"

echo "Custom CSS settings applied!"


# Function to generate SSH key for GitHub
generate_github_ssh_key() {
    echo "Generating SSH key for GitHub..."
    ssh-keygen -t ed25519 -C "benjaminshurts@gmail.com" -f "$HOME/.ssh/github_id_ed25519" -N ""
    echo "SSH key for GitHub generated successfully!"
}

# Function to generate SSH key for GitLab
generate_gitlab_ssh_key() {
    echo "Generating SSH key for GitLab..."
    ssh-keygen -t rsa -b 4096 -C "skyemou5@proton.me" -f "$HOME/.ssh/gitlab_id_rsa" -N ""
    echo "SSH key for GitLab generated successfully!"
}

# Check if the SSH directory exists, if not, create it
if [ ! -d "$HOME/.ssh" ]; then
    echo "Creating .ssh directory..."
    mkdir "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
fi

# Generate keys for GitHub and GitLab
generate_github_ssh_key
generate_gitlab_ssh_key

echo "SSH keys for GitHub and GitLab have been generated!"

# setup fonts

# Define the repository URL and the target directory
repo_url="https://github.com/ryanoasis/nerd-fonts.git"
target_dir="$HOME/source"

# Clone the repository into the target directory
echo "Cloning the repository..."
git clone "$repo_url" "$target_dir"

# Check if the clone was successful
if [ $? -eq 0 ]; then
    echo "Repository cloned successfully!"

    # Navigate to the root of the cloned repository
    cd "$target_dir/$(basename "$repo_url" .git)"

    # Run the setup.sh script
    echo "Running setup.sh..."
    ./setup.sh

    # Check if the setup was successful
    if [ $? -eq 0 ]; then
        echo "Setup completed successfully!"
    else
        echo "Error: Setup.sh script failed to run."
        exit 1
    fi
else
    echo "Error: Cloning the repository failed."
    exit 1
fi

# fstab

# Define the new entries for the fstab file
entries=(
    "/dev/disk/by-uuid/BE627C17627BD31F /mnt/MegaStomach1 ntfs uid=1000,gid=1000,nosuid,nodev,nofail,x-gvfs-show,x-gvfs-name=Mega%20Stomach%201 0 0"
    "/dev/disk/by-uuid/201CA8AE1CA88080 /mnt/MediumStomach ntfs uid=1000,gid=1000,nosuid,nodev,nofail,x-gvfs-show,x-gvfs-name=Medium%20Stomach 0 0"
    "/dev/disk/by-uuid/0CF09AB2F09AA20E /mnt/MediumStomach2 ntfs uid=1000,gid=1000,nosuid,nodev,nofail,x-gvfs-show,x-gvfs-name=Medium%20Stomach%202 0 0"
    "UUID=5d186591-57ec-44d8-9b80-0e653a619fda /mnt/Stomach ext4 defaults 0 0"
)

# Add the new entries to the fstab file
for entry in "${entries[@]}"; do
    echo -e "$entry" | sudo tee -a /etc/fstab
done

echo "New entries added to /etc/fstab!"

# make bash pretty

git clone https://github.com/christitustech/mybash
cd mybash
./setup.sh

# add other option


# install helix

# Enable the COPR repository
sudo dnf copr enable varlad/helix

# Install the helix package
sudo dnf install helix

echo "helix installed successfully!"

# install codium

# Import the GPG key for the VSCodium repository
sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg

# Create a DNF repository configuration for VSCodium
echo -e "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/\nenabled=1\ngpgcheck=1" | sudo tee /etc/yum.repos.d/vscodium.repo

# Install VSCodium
sudo dnf install codium

echo "VSCodium installed successfully!"

# install rust

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh


