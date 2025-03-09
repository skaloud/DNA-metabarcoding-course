# Lesson 1: Installation of Programs & Getting Access to MetaCentrum

## Programs Used in the Course
in this course we will use the following programs. Below are instructions for installing them.

- **Spreadsheet viewer** (MS Excel, OpenOffice Calc, Google Sheets, etc.)
- **R**
- **RStudio**
- **MobaXterm**
- **SEED2**
- **Any program to edit alignments** (we will use the MEGA software)
- **IQ-TREE**
- **FigTree**

## Installation Instructions

### R
- Website: [R Project](https://www.r-project.org/)
- Download R: [CRAN Mirror](https://mirrors.nic.cz/R/)

**For Windows installation:**
1. Click on "Install R for the first time".
2. Click on the download link.
3. Run the `.exe` file and install the program.

### RStudio
- Website: [RStudio Downloads](https://posit.co/downloads/)

**For Windows installation:**
1. Click on "Download RStudio".
2. Click on "Download RStudio Desktop for Windows".
3. Run the `.exe` file and install the program.
4. Run RStudio, choose R Installation (just click on "Use your machine’s default version").

**Install the packages:**
1. In the bottom right window, there is a menu "Packages".
2. Under it, select "Install", and in the field "Packages" find and install the following libraries:
   - `xlsx`
   - `icesTAF`
   - `dplyr`
   - `vegan`
   - `phytools`
   - `BiocManager`
3. To install the PhyloSeq library, type:
```r
BiocManager::install("phyloseq")
```

### MobaXterm
- Website: [MobaXterm Downloads](https://mobaxterm.mobatek.net/download.html)

**For Windows installation:**
1. Select the Home edition.
2. Select the portable edition and download it.

### SEED2
- Website: [SEED2 Downloads](https://www.biomed.cas.cz/mbu/lbwrf/seed/help.php)

**For Windows installation:**
1. Download SEED – select the newest version.
2. Unzip the folder, ideally directly to `C:/`.

### MEGA
- Website: [MEGA Downloads](https://www.megasoftware.net/)

**For Windows installation:**
1. Select the version to install (versions 5 or 6 are recommended).
2. Download the installation file and install it.

### IQ-TREE
- Website: [IQ-TREE](http://www.iqtree.org/)

**For Windows installation:**
1. Download the latest release.
2. After unzipping, the program is ready to use.

### FigTree
- Website: [FigTree](http://tree.bio.ed.ac.uk/software/figtree/)

**For Windows installation:**
1. Download the latest release from the [GitHub repository](https://github.com/rambaut/figtree/releases).
2. After unzipping, the program is ready to use.




## Getting Access to MetaCentrum

### Create Your Personal Account on MetaCentrum
- Documentation: [MetaCentrum Documentation](https://docs.metacentrum.cz/)
- Account creation: [Create an Account](https://docs.metacentrum.cz/access/account/)

**For all employees and students of research organizations in the Czech Republic:**
1. Create your login and password
2. Fill Description of planned activity: e.g., `Analysis of Illumina amplicon sequences (DNA metabarcoding).`
3. Participation in big projects: `No projects`
4. Become a MetaCentrum member.


### Different Uses of MetaCentrum
1. **Computing**:
   - **Interactive jobs**: For testing calculations, debugging errors, etc.
     
   - **Batch job**: Once everything is debugged, calculations are typically run via batch jobs, where you prepare a script that defines data upload, calculations, and saving the results back to the account.

2. **OnDemand**:
   - Access MetaCentrum via selected programs (e.g., running R Studio to speed up complex R calculations).

3. **e-INFRA CZ OpenStack**:
   - Computational virtual clusters in the Linux environment, which will be used in this course.
   - Documentation: [e-INFRA CZ](https://docs.e-infra.cz/)
   - Currently, virtual computers are available in Brno or Ostrava.


- **Note:** MetaCentrum can be accessed via several frontends. If one is not working, you can access your account from another frontend.
- **Important**: Do not perform any calculations or upload large data (over 10 GB) directly on the frontend, as it slows down the work for everyone. If your work is slow, consider switching to another frontend.

---

[Next Lesson](../lesson2/lesson2.md)
