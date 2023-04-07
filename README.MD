# MFGPT (Mainframe GPT) Wrapper Script

This script provides a wrapper around the `sgpt` command-line tool for generating text based on prompts. It offers additional functionality specifically tailored for IBM Mainframe (z/OS) administrators and programmers.

## Prerequisites

- Python 3.x and pip installed
- Shell-GPT (sgpt) Python package (will be installed automatically if not already installed)

## Usage

The script `mfgpt.sh` can be used with the following options:

1. **--c3270**

   Displays the content of all c3270 screen sessions and generates a text based on the input.(*good results*)


```

./mfgpt.sh --c3270

```

2. **--explain**

Analyzes a given file and generates an explanation of the file content, including detailed explanation and external resources. The file should be a source code or script from an IBM Mainframe (z/OS).(*medium results*)


```

./mfgpt.sh --explain "<path-to-your-file>"

```

Replace `<path-to-your-file>` with the path to the file you want to analyze.

3. **--task**

Provides step-by-step instructions based on the given task prompt.(*bad results - let's wait for the next interation of LLMs or gpt4 api access*)


```

./mfgpt.sh --task "<your-task-prompt>"

```

Replace `<your-task-prompt>` with your desired task description.

## Examples

1. Get the content of all c3270 screen sessions and generate text based on the input:


```

./mfgpt.sh --c3270

```

2. Analyze a file and generate an explanation of the file content:


```

./mfgpt.sh --explain "myjcl"

```
3. Generate step-by-step instructions for a given task:


```

./mfgpt.sh --task "Create a new dataset in z/OS"

```


## License

This script is released under the [MIT License](https://opensource.org/licenses/MIT).

