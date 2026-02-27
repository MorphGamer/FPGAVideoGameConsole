# FPGAVideoGameConsole

This repository will contain SystemVerilog code that will implement a square chasing game on the "Basys 3 AMD Artix™ 7 FPGA Trainer Board". 

## Table of Contents
- [Introduction](#introduction)
- [Requirements](#requirements)
- [Functionality](#functionality)
- [Installation](#installation)
- [Documentation](#documentation)

## Introduction

This project implements a custom video game console on an FPGA platform, integrating real-time graphics rendering, user input processing, and display output. The system is designed using a Hardware Description Language (HDL) (SystemVerilog) for low-level hardware control and finite state machines for game logic. Video frames are generated and buffered within the FPGA and output to an LCD monitor using a VGA/HDMI interface. A gamepad controller is interfaced through SPI/GPIO to provide low-latency user input. The design leverages FPGA parallelism to handle pixel rendering in real time. The final system demonstrates a functional, standalone 2D game/games with responsive gameplay on an external LCD monitor.

## Requirements

In order to replicate the project, you will need the following hardware:

- Basys 3 AMD Artix™ 7 FPGA Trainer Board
    - https://digilent.com/shop/basys-3-amd-artix-7-fpga-trainer-board-recommended-for-introductory-users/
- Pmod JSTK2: Two-axis Joystick
    - https://digilent.com/shop/pmod-jstk2-two-axis-joystick/
- VGA to HDMI Adapter (Can be any but that is what was used)
    - https://retrorgb.com/converters.html
- Pmod Cable Kit: 6-pin
    - https://digilent.com/shop/pmod-cable-kit-6-pin/
- USB Flash Drive (to load .SV files onto the FPGA board).

While not necessary, the joystick and FPGA board can be put into a 3D-Printed Case to make it easier for the user to handle and use.

## Functionality

To come up with the design, a block diagram was created. The block describes both how the internal logic of the FPGA board will function as well as the entire system as a whole. In other words, how all the parts will connect and operate with one another. This can be seen below.

![Block Diagram for Capstone Project](Images/Block%20Diagram-Detailed.drawio.svg "Block Diagram")

As seen above, the user will be able to operate the joystick which will in turn move the square character on screen in eight different directions. This joystick will be connected to the PMOD port of the Basys 3 FPGA board. Internally, the game will be made up of different modules that will contain the game mechanics, visuals on screen, and the output image to the VGA port. This will require the 100MHz clock on the board. Through PLL (Phase Locked Loop), it will be able to boost the frequency up to 148.5MHz in order to output an image to the display at 1080p, 60Hz. If this is unable to be achieved, then the backup will be to lower the resolution down to 480p at 60Hz in order to accommodate for the clock that is one the board itself. That data will be dispersed through the 15 pins of the VGA port of the Basys 3. The VGA port will be connected to a VGA to HDMI Adapter. Lastly, the HDMI cable will be connected from the adapter to the monitor.


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

## Documentation  

looking for documentation? Check out the [wiki!](https://github.com/MorphGamer/FPGAVideoGameConsole/wiki)

