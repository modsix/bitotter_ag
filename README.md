Copyright (c) 2013, 2014
BITOTTER (http://www.bitotter.com) All rights reserved.

BitOTTer Air-Gap / Stand-Alone Tool for MPEx (bitotter_ag.sh) v0.0.2 alpha 
Copyright (c) 2013, 2014 bitotter.com <modsix@gmail.com> 0x721705A8B71EADAF

bitotter_ag.sh is simply creates an encrypted MPEx command file and write it 
to the local directory where this script resides. The relaying of the encrypted
MPEx command to the mpex server itself are up to the user as this is designed
for an airgapped machine.

Additionally, this script will take an encrypted MPEx receipt file as a command line
parameter and allow the user to decrypt the file from the local directory. 

Successful encryption or decryption tasks are written out
to a local file with a datestamp with the current UNIX time appended.

The format of the output files are as follows:
Encrypted Command: mpex_order_YYYYMMDD_UNIXTIME.asc
Decrypted Receipt: decrypted_mpex_receipt_YYYYMMDD_UNIXTIME.txt
