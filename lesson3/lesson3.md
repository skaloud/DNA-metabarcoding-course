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

---

[Previous Lesson](../Lesson2/lesson1.md) | [Next Lesson](../Lesson4/lesson1.md)
