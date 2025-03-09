# Lesson 4: Installing Programs and Scripts for DNA Metabarcoding Data Analysis

In this lesson, we will install all the necessary programs needed to analyze DNA metabarcoding data into the "programs" folder. Additionally, we will download and configure essential scripts.

## Install Necessary Programs

### Install make, gcc, python
```bash
sudo apt-get update
sudo apt install make
sudo apt install gcc
sudo apt install rename
sudo apt-get install python-biopython
```

### Install PANDAseq
- Documentation: [PANDAseq Assembler](https://github.com/neufeld/pandaseq/wiki/PANDAseq-Assembler)
```bash
sudo apt-add-repository ppa:neufeldlab/ppa && sudo apt-get update && sudo apt-get install pandaseq
```

### Install cutadapt
```bash
sudo apt install cutadapt
```

### Install fqgrep
- Documentation: [fqgrep GitHub](https://github.com/indraniel/fqgrep/wiki)
```bash
sudo apt-get install libtre-dev libtre5
sudo apt-get install zlib1g zlib1g-dev
mkdir programs
cd programs
git clone https://github.com/indraniel/fqgrep.git
cd fqgrep
make
cd ..
```

### Install fastx
- Documentation: [fastx_toolkit installation](http://hannonlab.cshl.edu/fastx_toolkit/install_ubuntu.txt)
```bash
sudo apt-get install gcc g++ pkg-config wget
gcc -v  # check the version - it must be at least 4.2
wget https://github.com/agordon/libgtextutils/releases/download/0.7/libgtextutils-0.7.tar.gz
tar -zxvf libgtextutils-0.7.tar.gz
cd libgtextutils-0.7
sed -i '47s/input_stream/static_cast<bool>(input_stream)/' src/gtextutils/text_line_reader.cpp
./configure
make
sudo make install
cd ..
wget https://github.com/agordon/fastx_toolkit/releases/download/0.0.14/fastx_toolkit-0.0.14.tar.bz2
tar -xjf fastx_toolkit-0.0.14.tar.bz2
cd fastx_toolkit-0.0.14
wget https://github.com/agordon/fastx_toolkit/files/1182724/fastx-toolkit-gcc7-patch.txt
patch -p1 < fastx-toolkit-gcc7-patch.txt
./configure
make
sudo make install
sudo ldconfig
cd ..
```

### Install vsearch
- Documentation: [vsearch manual](https://manpages.debian.org/stretch/vsearch/vsearch.1.en.html)
```bash
sudo apt-get update -y
sudo apt-get install -y vsearch
```

### Install fastQC
- Documentation: [fastQC project](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
```bash
sudo apt install default-jre
sudo apt install fastqc
```

### Install swarm
- Documentation: [swarm manual](https://github.com/torognes/swarm/blob/master/man/swarm_manual.pdf)
```bash
git clone https://github.com/torognes/swarm.git
cd swarm/
make
cd ..
```

### Install Python2
```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p $HOME/miniconda
$HOME/miniconda/bin/conda init
# Restart terminal! Check the installation and continue to install Biophyton
conda --version
conda install -c anaconda biopython
conda create --name py2 python=2.7
```

## Save Necessary Scripts into the "scripts" Folder

### Download Scripts from Bailint et al. (2014) Paper
- Data S2 in [Bailint et al. (2014)](https://onlinelibrary.wiley.com/doi/full/10.1002/ece3.1107)
- Create the "scripts" folder in the virtual machine.
- Upload these unzipped scripts:
  - `rename.pl`
  - `demultiplex.sh`
  - `remove_multiprimer.py`
  - `Reads_Quality_Length_distribution.pl`

### Configure `demultiplex.sh`
1. Define the path to the program `fqgrep`:
   - Right-click on `demultiplex.sh` – Open with default text editor.
   - On lines 14 and 24, change `fqgrep` to `/home/ubuntu/programs/fqgrep/fqgrep`.
2. Output fastq files instead of fasta files:
   - On lines 14 and 24, delete the option `-f`.
   - On line 14, change `$name.fasta` to `$name.fastq`.
   - On line 18, change `FILES=(*.fasta)` to `FILES=(*.fastq)`.
3. Demultiplex all combinations of forward and reverse labels:
   - On line 24, change `$label ${FILES[i]} > $name\_${FILES[i]}` to `$label $f > $name\_$f`.
   - Include a new line 25: `done`.
   - After line 23 (`do`), add these two lines:
     ```bash
     for f in "${FILES[@]}"
     do 
     ```
   - Finally, in line 30, add: `((++i))`.
4. Save (Ctrl-S), select Autosave.
5. Allow permission to write:
   ```bash
   cd ../scripts
   chmod +x demultiplex.sh
   ```

### Download `OTU_contingency_table.py` Script
1. Download from [GitLab](https://gitlab.mbb.cnrs.fr/edna/bash_swarm/-/blob/master/scripts/OTU_contingency_table.py)
   - Go to the link and click to download.
2. Modify the script:
   - On line 64, change:
     ```python
     separator = "_[0-9]+|;size=[0-9]+;| "
     ```
     to
     ```python
     separator = "_[0-9]+|;size=[0-9]+;?| "
     ```
3. Upload the script to the "scripts" folder.

---

[Previous Lesson](../lesson3/lesson3.md) | [Next Lesson](../lesson5/lesson5.md)
