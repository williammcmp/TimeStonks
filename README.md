# TimeStonks ⌛💰

---
## NOTE 
**The specific data files for each person in MTH20016 (S2 2023) has also been included, Simply change you file number in [main.m](/main.m)**

## CURRENT PROGRESS
**Part 1 has been completed, working on parts 2 and 3. Checkout [main.m](/main.m)**

---

## Overview

This MATLAB project is designed to analyze and visualize time series data. It includes various functions and scripts for data import, statistical analysis, and visualization of different aspects of stochastic processes 📈📉

<p align="center">
  <img src="figures/Example_of_mean_model.jpg"  style="max-height:400px;"/> 
</p>

## Prerequisites

- MATLAB installed on your computer.
- git installed. if you have mac, git is aleady installed; else if windows, please install Git. [(view steps below).](#git-installation-guide) 
## Getting Started

1. Clone this repository to your local machine:

    ```bash
    git clone https://github.com/williammcmp/TimeStonks.git
    ```

2. Open MATLAB and navigate to the project folder.

## Usage

1. Open the `main.m` script in MATLAB.

2. Edit the `folderPath` variable to specify the directory where your AFL data is stored.

3. Run the script in MATLAB to execute the desired analysis and generate visualizations.

## Important files

- [main.m](/main.m) - Main Script (run everything from here)

Forecasting scripts 📈📉 - Taken from the Labs (nothing crazing is happening). Each forecast model function or script will include a 🧪 validation output to the command window. 😎

- [AR1Model.m](/AR1Model.m) - AR(1) Model Fit and Forecast script
- [meanModel.m](/meanModel.m) - Mean Model Fit and Forecast script
- [naiveModel.m](/naiveModel.m) - Naive Model Fit and Forecast script
- [MA1Model.m](/MA1Model.m) - MA(1) Script (WIP)

Folders 📁
- [data/](/data/) (Directory of all Data Files required for Assigment)

Helper Functions ⚒ (plots and loading data)
- [initalPlots.m](/initalPlots.m) - Plots the Raw data's ACF and PACF
- [loadExcel.m](/loadExcel.m) - Excel Data Loading Function
- [loadText.m](/loadText.m) - Text Data Loading Function
- [swtest.m](/swtest.m) - Shapiro-Wilk Test Function (saves you having to download it again)

## Git Installation Guide

**This whole part should be skipped if you download the .zip version of this. Click on the Green code button near the top of the screen.** 

### Introduction

This guide will help you install Git on your computer. Git is a powerful version control system used to track changes in software development projects.

### Installation Steps

#### Windows

1. Download Git for Windows from [https://git-scm.com/download/win](https://git-scm.com/download/win).

2. Run the downloaded installer.

3. Follow the on-screen instructions, leaving all options at their default settings unless you have a specific reason to change them.

#### macOS

1. Download Git for macOS from [https://git-scm.com/download/mac](https://git-scm.com/download/mac).

2. Run the downloaded installer package (it has a `.pkg` extension).

3. Follow the installation prompts. You may need to enter your password to complete the installation.

#### Linux (Ubuntu as an example)

1. Open your terminal.

2. Install Git using the package manager for your distribution. For Ubuntu, you can use `apt`:

   ```bash
   sudo apt update
   sudo apt install git
   ```

### Verification

To verify that Git is installed correctly, open your terminal or command prompt and run:

```bash
git --version
```

You should see the Git version information, confirming a successful installation.

### Configuration

After installing Git, configure your name and email:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

Replace "Your Name" and "your.email@example.com" with your own information.

### Getting Started

You're now ready to use Git for version control in your projects. Start by creating a new repository or cloning an existing one. Refer to Git documentation and tutorials for further guidance.

### Additional Resources

- [Official Git Documentation](https://git-scm.com/doc)
- [GitHub Learning Lab](https://lab.github.com/)
- [Atlassian Git Tutorials](https://www.atlassian.com/git/tutorials)
- [Git and GitHub for Beginners](https://guides.github.com/activities/hello-world/)

This README includes simplified installation instructions for Windows, macOS, and Linux, along with configuration steps and additional resources. 

## Contributing

Contributions to this project are welcome. Feel free to open issues, suggest improvements, or submit pull requests to enhance the functionality or documentation.

## License

This project is licensed under the MIT License. See the [LICENSE](/LICENSE) file for details.

If you are reading this far down a repo that doesent even matter, WTF?!??!. Thanks I guess. 
