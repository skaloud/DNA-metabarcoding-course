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

### Introduction to Bash For-Loops (Repeating Commands)

In Linux, it is common to perform the same operation on many files — for example, processing all .fastq files in a directory. To automate this, we use a for-loop in the Bash shell.

#### Basic structure of a for-Loop:
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

This simple pattern — looping over files, extracting the base name, and performing an action — is the same structure you will use later in the course for more advanced tasks.

---

[Previous Lesson](../lesson2/lesson2.md) | [Next Lesson](../lesson4/lesson4.md)
