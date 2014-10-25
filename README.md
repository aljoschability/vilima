# Vilima
The Matroska tag editor.

Vilima is a tool to edit meta data of files stored in the Matroska media container format.

Due to the lack of proper Matroska tag editing tools, I created my own one.

## Installation
* Install MKVToolNix for your platform
* Extract the latest version of Vilima and run it
* When autodetection of the MKVToolNix installation fails, follow the steps...
* Use it

## Implementation
The implementation is based on the Eclipse RCP technology (e4).
Under the hood, it reads Matroska files based on my own implementation of an EBML-parser.
The writing uses an installed instance of the MKVToolNix suite (espacially mkvpropedit).

## Features
* Batch tag editing
* Rename files based on tags
* Discover online services for tag information
* Store cover art
