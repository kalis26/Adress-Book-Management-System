# Adress-Book-Management-System
First trial work of the module "Introduction to Operating Systems 2", this project consists in developing a fully functional address book management system using 8086 assembly language.\
The system allows users to manage a contact list of up to 16 entries. Each contact is composed of:

  * A name (maximum 10 characters)
  * A phone number (exactly 10 digits)

<div align="center">
  
  [![stars](https://img.shields.io/github/stars/kalis26/Adress-Book-Management-System)](https://github.com/kalis26/Adress-Book-Management-System/stargazers)
  [![forks](https://img.shields.io/github/forks/kalis26/Adress-Book-Management-System)](https://github.com/kalis26/Adress-Book-Management-System/forks)
  [![issues](https://img.shields.io/github/issues/kalis26/Adress-Book-Management-System?color=orange)](https://github.com/kalis26/Adress-Book-Management-System/issues)
  [![license](https://img.shields.io/github/license/kalis26/Adress-Book-Management-System)](https://github.com/kalis26/Adress-Book-Management-System/blob/main/LICENSE)
  
</div>

<div align="center">
 <img src="resources/demo.gif"> 
</div>

## Features
The program supports the following core functionalities:

  * **Add Contact** – Insert a new contact into memory (unless capacity is reached).
  *  **View All Contacts** – Display the full list of stored contacts.
  *  **Search Contact** – Find a contact by name and display their phone number.
  *  **Modify Contact** – Update the phone number of an existing contact.
  *  **Delete Contact** – Remove a contact by specifying its name.

### Additional Features

Beyond the core requirements, this implementation includes:

  * **Display by name prefix** – Show all contacts whose names start with a specific substring.
  * **Search by number pattern** – Display all contacts whose phone number contains a given digit sequence (e.g., "123").

## Error Handling
The application includes error checks to:

  * Prevent adding contacts when the address book is full.
  * Show appropriate messages if a contact is not found during search, modification, or deletion.

## Documentation
- To know more about the project, you can access the instructions folder.

## System Requirements
- Assembly 8086 compiler ([Emu8086](https://emu8086-microprocessor-emulator.fr.softonic.com/) recommended).

## How to run?
This project is written in 8086 Assembly and was developed and tested using the Emu8086 emulator.\
\
Steps to Compile and Execute:

  1. Open Emu8086.
     
  2. Load the .asm file:\
     Go to **File > Open**, then select your file.
     
  3. Compile the program:
     Click the "**Compile**" button (or press `F5`). Make sure there are no syntax errors.
     
  4. Run the program:
     Use the "**Emulate**" or "**Run**" option (or press `F9`) to start the program in the emulator. 

*Note:* Other emulators or assemblers may not support the exact same syntax or system interrupts used here. For this reason, it’s strongly recommended to use Emu8086 for both editing and execution.
