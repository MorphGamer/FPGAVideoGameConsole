## Installation

If a different FPGA board is used from the one that is linked above, make sure that the chip embedded within that board is an Artix. Otherwise, the code on this repository is not guaranteed to run on other FPGA boards.

Follow the link to create an account on AMD-Xilinx website. 

[AMD Account Creation](https://www.amd.com/en/registration/create-account.html) 

Once an account has been created, download the Latest Version of Vivado here:

https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html

The download link for the latest version is titled: 

["AMD Unified Installer for FPGAs & Adaptive SoCs 2025.2: Windows Self Extracting Web Installer".](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/2025-2.html) 

If a license is required to purchase, then go the sidebar and select "Vivado Archive" in order to download version [2023.1](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive.html)

Here is installation guide to continue installing Vivado and all of its components:

https://digilent.com/reference/programmable-logic/guides/installing-vivado-and-vitis

Make sure to install of the design sources (SystemVerilog **.sv**) and **.xdc** files from this GitHub repository in order to be place those files within Vivado in order to play the game.

From here in order to create a project, follow this guide:

https://digilent.com/reference/programmable-logic/guides/getting-started-with-vivado

Once all of the files are downloaded, click on:
1.  Run each of the following in Vivado in order to be able to upload the file to the Basys 3 board. Each section might take a while for it to complete.
    1. **Run Synthesis**
    2. **Run Implementation**
    3. **Generate Bitstream**
2. When Generate Bitstream is finished, connect the Basys 3 board to their computer with a USB cable.
    1. Click on **Open Hardware Manager**.
3. Within the sidebar of Vivado under Hardware Manager, Click on **Open Target**, **Auto Connect**. 
4. Finally go to **Program Device**, **xc7a35t_0**. 
5. From here, the game should load onto the board in order for it to be playable on a monitor.

### How to Play

Connect the Pmod cable to the joystick. Connect the cable to the PMOD port on the FPGA board itself. The player can move up, down, left, and right within the maze. The goal is to try and run away from the enemy square and survive for as long as you can. When the player get caught, the player loses the match and the game restarts.