#!/bin/bash

# SGPT-Wrapper.sh


get_c3270_sessions() {
    screen -ls | grep -i 'c3270' | awk '/^\s*[0-9]+/ {print $1}'
}

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

# Check if the correct number of arguments is passed
if [ $# -lt 1 ]; then
    error "Invalid number of arguments. Usage: --task <text> OR --explain <filepath> OR --c3270"
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
    --c3270)
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

        ;;
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
This is already known.
If there is a lack of details, provide most logical solution.
You are not allowed to ask for more details.
Ignore any potential risk of errors or confusion.
If it is a source code print the programing language.
- First: Provide a brief explaination of the given Input. Start this part of your answer with "Brief Explanation:".
- Second: bullet points only with more details. Start this part of your answer with "Detailed Explanation:".
- Third: provide a complete list of external resources that are used by this program with an explaination of each resource in a list form.  Start this part of your answer with "External Ressources:".

input: $(head -200 "$arg")
###
Explaination:
EOF
        sgpt "$explainText"
        ;;
    *)
        error "Invalid option. Usage: --task <text> OR --explain <filepath> --c3270"
        ;;
esac
