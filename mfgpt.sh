#!/bin/bash

# SGPT-Wrapper.sh

# Function to display error messages and exit the script
error() {
    echo "$1" >&2
    exit 1
}

# Check if the correct number of arguments is passed
if [ $# -ne 2 ]; then
    error "Invalid number of arguments. Usage: --task <text> OR --explain <filepath>"
fi

# Assign parameters and arguments
option="$1"
arg="$2"

# Check if 'sgpt' is installed, if not, install it using pip
if ! command -v sgpt >/dev/null; then
    echo "sgpt not found, installing with pip..."
    pip install shell-gpt -U || error "Failed to install sgpt. Please ensure you have pip installed and try again."
fi


# Call the SGPT script according to the option
case $option in
    --task)
read -r -d '' taskText <<EOF
###
You are helping an IBM Mainframe (z/OS) administrator. So the solution should be running in z/OS.
Provide step by step instructions to archive the desired goal.
If there is a lack of details, provide most logical solution.
You are not allowed to ask for more details.
Ignore any potential risk of errors or confusion.
Give me additional google search terms to get more information.

Prompt: $arg
###
Step-By-Step:
EOF
        sgpt "$taskText"
        ;;
    --explain)
        # Check if the specified file exists
        if [ ! -f "$arg" ]; then
            error "The specified file '$arg' does not exist. Please check the file path."
        fi
read -r -d '' explainText <<EOF
###
You are helping an IBM Mainframe (z/OS) programer. So the given Input is a file from an IBM Mainframe (z/OS).
If there is a lack of details, provide most logical solution.
You are not allowed to ask for more details.
Ignore any potential risk of errors or confusion.
First Provide a brief explaination of the given Input. Start this part of your answer with "Brief Explanation:".
Second Provide a more detailed explaination of the given Input.  Start this part of your answer with "Detailed Explanation:".
Finally, provide a complete list of external resources that are used by this program with an explaination of each resource in a list form.  Start this part of your answer with "External Ressources:".

input: $(cat "$arg")
###
Explaination:
EOF
        sgpt "$explainText"
        ;;
    *)
        error "Invalid option. Usage: --task <text> OR --explain <filepath>"
        ;;
esac
