# Lesson 3: Accessing the Virtual Machine and Introduction to Linux Commands

In this lesson, we will learn how to use MobaXterm to access the virtual machine and get an introduction to basic Linux commands.

## Accessing the Virtual Machine with MobaXterm

1. **Open MobaXterm**
2. **New Session – SSH**:
   - Remote host: Write the IP address of your instance (found under Floating IPs as the IP Address)
   - Specify username: `ubuntu`
   - Advanced SSH settings: Use private key – select the key (`mrkev.pem`)
   - Accept
3. **Use this saved session every time to access the virtual machine**
4. **Settings – Configuration**:
   - Numerous options to configure the program (e.g., in Terminal, White background / Black text can be selected)
5. **Familiarize yourself with the program**:
   - Left window: 
     - Sessions: Saved sessions
     - Sftp: File manager to upload/download files, make folders, rename files, etc.
   - Right window: Linux environment

## Introduction to Linux and Simple Commands

### UNIX File Hierarchy
- `/` : Root directory
  - **`root`**: Home directory for the root user, who has admin privileges
  - **`home`**: Personal directory for the users
  - **`usr`**: Directory with user utilities and applications
  - **`bin`**: Essential command binaries needed for the system

### Basic Commands

- `pwd` : Prints current directory path
- `cd` : Changes current directory path
- `ls` : Lists current directory contents
- `ll` : Lists detailed contents of current directory
- `ls -lh` : Lists files in a human-friendly format
- `mkdir` : Creates a directory
- `rm` : Removes a file
- `rm -r` : Removes a directory
- `cp` : Copies a file/directory (`cp "file" "destination"`)
  - `.` : Here (e.g., `cp /dir/myfile.txt .`)
  - `..` : Up (e.g., `cp ../myfile.txt .`)
- `mv` : Moves a file/directory
- `locate` : Tries to find a file by name
- `ls /bin` : List of binary programs
- `head` : View the top 15 lines of a file (`-n` specifies number of lines, e.g., `-n 1` for one line)
- `tail` : View the last 15 lines of a file
- `more` : View a text file (spacebar = next page, `q` to quit)
- `TAB` : Auto-complete command or file name

## Using `$` in Bash

In Bash, variables allow you to store information (such as filenames, sample IDs, or paths) and reuse it in commands. The symbol `$` is used to insert the value of a variable into a command.

#### Defining and using variables
```bash
alga="Chlorella"
echo $alga
```

#### Using ${variable} inside longer strings

When a variable appears inside a filename or path, the safer form `${variable}` is used:
```bash
base=${f%.fastq}
src="../$library/${primerR}_${primerF}.fastq"
```
Curly braces clearly mark where the variable name ends, preventing ambiguity.

#### Variables inside loops

Variables are essential in both `for‑loops` and `while‑loops`:
```bash
for f in *.fastq; do
    echo "Processing: $f"
done
```

Here, `$f` contains the current filename.

In a `while read` loop, each column from a CSV file becomes a variable:
```bash
while IFS=';' read -r sample info library primerF primerR; do
    echo "Sample: $sample  Library: $library"
done < barcodes_clean.csv
```

#### Building dynamic file paths

Bioinformatics workflows often construct filenames automatically:
```bash
src="../$library/$sample_path/${primerR}_${primerF}.fastq"
```
Bash replaces each variable with its actual value, producing the correct path for each sample.

#### Using echo for a dry run

`echo` is commonly used to preview commands before running them:
```bash
echo cp "$src" "$dest"
```
This prints the command without executing it — a safe way to verify that variables expand correctly.


## Introduction to Bash Loops (Repeating Commands)

Linux allows you to automate repetitive tasks. In this course, you will use two types of loops:
- **for‑loops** — iterate over files
- **while‑read loops** — read structured data line by line (e.g., CSV tables)

### 1. **For‑Loops (Repeating Commands Over Files)**

#### Basic structure:
```bash
for VARIABLE in list_of_items; do
    command_using_$VARIABLE
done
```
- `for VARIABLE in ...` : Iterates over all items in the list
- `do ... done` : Block of commands executed for each item
- `$VARIABLE` : The current item (e.g., a filename)

#### Simple Example:
```bash
for f in *.txt; do
    echo "File: $f"
done
```
What happens:
- `*.txt` : Expands to all .txt files in the directory
- The loop prints each filename one by one

#### Working With Filenames (Removing Extensions):
```bash
base=${f%.fastq}
```
- `${f%.fastq}` removes the `.fastq` suffix from the variable `$f`

#### Example: Renaming All .txt Files
The following loop renames all `.txt` files by adding a `_backup` suffix before the extension:
```bash
for f in *.txt; do
    base=${f%.txt}
    mv "$f" "${base}_backup.txt"
done
```
Explanation:
- `for f in *.txt` : Iterates over all .txt files
- `base=${f%.txt}` : Extracts the filename without the .txt extension
- `mv "$f" "${base}_backup.txt"` : Renames each file to include _backup

### 2. **While‑Read Loops (Processing Tables Like CSV Files)**

While‑loops are useful when you need to read **structured data**, such as a CSV file with multiple columns.

#### Basic structure:
```bash
while IFS=';' read -r col1 col2 col3; do
    # use $col1, $col2, $col3
done < filename.csv
```
- `while ...; do ... done` : Repeats the block for each line of the file
- `IFS=';'` : Sets the input field separator to semicolon — needed for CSV files exported from Excel
- `read -r sample info library primerF primerR` : Reads one line and splits it into variables
- `< filename.csv` : Redirects the file as input to the loop

#### Example Used in This Course: Generating Copy Commands:
```bash
while IFS=';' read -r sample info library primerF primerR; do
    [[ "$sample" == "sample" ]] && continue

    src="../$library/$sample_path/${primerR}_${primerF}.fastq"
    dest="${sample}_${library}.fastq"

    echo cp "$src" "$dest"
done < "$input"
```
What happens:
- `[[ "$sample" == "sample" ]] && continue` : Skips the header line
- `src=...` : Builds the path to the original FASTQ file.
- `dest=... : Defines the new filename.
- `echo cp "$src" "$dest"` : Prints the command instead of running it — this is called a dry run.

---

[Previous Lesson](../lesson2/lesson2.md) | [Next Lesson](../lesson4/lesson4.md)
