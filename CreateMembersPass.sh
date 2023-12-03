#!/bin/bash

# File containing usernames and passwords (one per line, separated by a space)
input_file="OptiMembers.txt"

# Function to create a user
create_user() {
    local username=$1
    local password=$2

    # Create the user
    sudo useradd -m -s /bin/bash "$username"

    # Set the password
    echo "$username:$password" | sudo chpasswd

    echo "User $username created successfully."
}

# Check if the input file exists
if [ ! -e "$input_file" ]; then
    echo "Error: Input file $input_file not found."
    exit 1
fi

# Read the input file line by line
while read -r line; do
    # Split the line into username and password
    IFS=' ' read -r -a user_info <<< "$line"
    username="${user_info[0]}"
    password="${user_info[1]}"

    # Create the user
    create_user "$username" "$password"
done < "$input_file"
