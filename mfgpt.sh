#!/bin/bash

# mfgpt.sh

# Function to get c3270 screen sessions
get_c3270_sessions() {
    screen -ls | grep -i 'c3270' | awk '/^\s*[0-9]+/ {print $1}'
}

# Function to get the content of the screen sessions
get_screen_sessions() {
    local sessions=$1
    local output=""

    for session in $sessions; do
        screen -S "$session" -X hardcopy /tmp/screen_dump_$session.txt
        output+="Content of screen session $session:\n"
        output+="$(cat /tmp/screen_dump_$session.txt | tr -d '\000')\n"
        rm /tmp/screen_dump_$session.txt
    done

    echo -e "$output"
}

# Function to display error messages and exit the script
error() {
    echo "$1" >&2
    exit 1
}

# Function to check and install 'sgpt' if not already installed
check_and_install_sgpt() {
    if ! command -v sgpt >/dev/null; then
        echo "sgpt not found, installing with pip..."
        pip install shell-gpt -U || error "Failed to install sgpt. Please ensure you have pip installed and try again."
    fi
}

# Function to execute sgpt with the c3270 option
sgpt_c3270() {
    sessions=$(get_c3270_sessions)

    if [ -z "$sessions" ]; then
        echo "No c3270 screen sessions found."
        echo "Please create a c3270 session using 'screen -S \"c3270\" c3270 <your parameters>' before running this script."
    else
        content=$(get_screen_sessions "$sessions")
read -r -d '' c3270Text <<EOF
###
Tell me in one sentence what the input is. After that write me some bullet points what I can do here. After that, write me 2 short examples of what I can do next. If you use abbreviations, explain them in parentheses.
Input:
$content
EOF
        sgpt "$c3270Text"
    fi
}

# Function to execute sgpt with the --task option
sgpt_task() {
    local arg="$1"
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
}

# Function to execute sgpt with the --explain option
sgpt_explain() {
    local filepath="$1"

    # Check if the specified file exists
    if [ ! -f "$filepath" ]; then
        error "The specified file '$filepath' does not exist. Please check the file path."
    fi

read -r -d '' explainText <<EOF
###
You are helping an IBM Mainframe (z/OS) programer. So the given Input is a file from an IBM Mainframe (z/OS).
This is already known.
If there is a lack of details, provide most logical solution.
You are not allowed to ask for more details.
Ignore any potential risk of errors or confusion.
If it is a source code print the programing language.
- First: Provide a brief explanation of the given Input. Start this part of your answer with "Brief Explanation:".
- Second: bullet points only with more details. Start this part of your answer with "Detailed Explanation:".
- Third: provide a complete list of external resources that are used by this program with an explanation of each resource in a list form.  Start this part of your answer with "External Resources:".

input: $(head -200 "$filepath")
###
Explanation:
EOF
    sgpt "$explainText"
}

# Main function to parse input and call the respective functions
main() {
    # Check if the correct number of arguments is passed
    if [ $# -lt 1 ]; then
        error "Invalid number of arguments. Usage: --task <text> OR --explain <filepath> OR --c3270"
    fi

    # Assign parameters and arguments
    local option="$1"
    local arg="$2"

    # Check if 'sgpt' is installed, if not, install it using pip
    check_and_install_sgpt

    # Call the SGPT script according to the option
    case $option in
        --c3270)
            sgpt_c3270
            ;;
        --task)
            sgpt_task "$arg"
            ;;
        --explain)
            sgpt_explain "$arg"
            ;;
        *)
            error "Invalid option. Usage: --task <text> OR --explain <filepath> OR --c3270"
            ;;
    esac
}

main "$@"
