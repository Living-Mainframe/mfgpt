# MFGPT: Shell GPT Tech Demo for Mainframe Developers and Administrators

This is a tech demo wrapper script for [shell_gpt](https://github.com/TheR1D/shell_gpt), specifically designed to suit the needs of mainframe developers and administrators. The wrapper allows users to run the sgpt script with options that provide context specific to mainframe development and administration tasks.

## Features

- Automatically checks for and installs the `shell-gpt` package if not already installed
- Provides two main options to run the sgpt script:
  - `--task <text>`: Run the sgpt script with a text input for mainframe tasks
  - `--explain <filepath>`: Run the sgpt script with the content of a file for mainframe explanations
- Error handling and proper usage guidance

## Prerequisites

- Python 3.x
- pip (Python package installer)

## Installation

1. Install and configure [shell_gpt](https://github.com/TheR1D/shell_gpt)
2. Clone this repository or download the `mfgpt.sh` file.
3. Make the `mfgpt.sh` file executable by running `chmod +x mfgpt.sh`.

## Usage

Run the wrapper script with the desired parameters:


```

./mfgpt.sh --task "<text>"

```

or


```

./mfgpt.sh --explain "<filepath>"

```

Replace `<text>` with the text input specific to the mainframe task or `<filepath>` with the path to the file containing the mainframe explanation.

Please note that this is a tech demo and may not cover all possible use cases for mainframe developers and administrators. Contributions and suggestions are welcome to improve and expand the functionality.


