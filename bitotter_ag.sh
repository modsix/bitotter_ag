#!/bin/sh
#
# Copyright (c) 2013, 2014
# BITOTTER (http://www.bitotter.com) All rights reserved.
#
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. All advertising materials mentioning features or use of this software
#    must display the following acknowledgement:
#       This product includes software developed by BITOTTER,
#       http://www.bitotter.com
# 4. Neither the name "BITOTTER" nor the names of its contributors
#    may be used to endorse or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY BITOTTER ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL BITOTTER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

# BitOTTer Air-Gap / Stand-Alone Tool for MPEx (bitotter_ag.sh) v0.0.2 alpha 
# Copyright (c) 2013, 2014 bitotter.com <modsix@gmail.com> 0xD655A630A13E8C69 

# bitotter_ag.sh is simply creates an encrypted MPEx command file and write it 
# to the local directory where this script resides. The relaying of the encrypted
# MPEx command to the mpex server itself are up to the user as this is designed
# for an airgapped machine.
#
# Additionally, this script will take an encrypted MPEx receipt file as a command line
# parameter and allow the user to decrypt the file from the local directory. 
#
# Successful encryption or decryption tasks are written out
# to a local file with a datestamp with the current UNIX time appended.
#
# The format of the output files are as follows:
# Encrypted Command: mpex_order_YYYYMMDD_UNIXTIME.asc
# Decrypted Receipt: decrypted_mpex_receipt_YYYYMMDD_UNIXTIME.txt

MPEx_KEYID=02DD2D91 # as of 20140720
DATE=`date '+%Y%m%d_%s'`

EFLAG= DFLAG= VFLAG= USAGE=
if [ $# -eq 0 ]; then 
	echo "Error: No arguments supplied!" 
	USAGE=1;
fi

while getopts e:d:vh opt
do
	case $opt in
	e) EFLAG=1 EARG=$2;;
	d) DFLAG=1 DARG=$2;;
	v) VFLAG=1;;
	h) USAGE=1;;
	?) USAGE=1;;
	--) shift; break;;
	-*) echo "Error: Unrecognized option $1" 1>&2; USAGE=1;;
	*) break;;	
	esac
	shift
done	

if [ ! -z "$EFLAG" ] && [ ! -z "$EARG" ]; then
		MPEx_ORDER='mpex_order_'$DATE'.asc'
		`echo $EARG | gpg --clearsign | gpg --armor --encrypt -r $MPEx_KEYID > $MPEx_ORDER`
		if [ ! -z "$VFLAG" ]; then
			ENC=`cat $MPEx_ORDER`	
			echo "$ENC"	
		fi
		echo ""
		echo "Finished."
		echo "Encrypted MPEx Command File Written To: $MPEx_ORDER"
fi

if [ ! -z "$DFLAG" ] && [ ! -z "$DARG" ]; then
		MPEx_ENCRYPTED_RECEIPT=$DARG
		MPEx_DECRYPTED_RECEIPT='decrypted_mpex_receipt_'$DATE'.txt'
		`gpg --decrypt $MPEx_ENCRYPTED_RECEIPT > $MPEx_DECRYPTED_RECEIPT`
		if [ ! -z "$VFLAG" ]; then
			DEC=`cat $MPEx_DECRYPTED_RECEIPT`
			echo "$DEC"
		fi
		echo ""
		echo "Finished."
		echo "Decrypted MPEx Receipt File Written To: $MPEx_DECRYPTED_RECEIPT"
fi

if [ ! -z "$USAGE" ]; then
		echo ""
		echo "Usage: bitotter_ag.sh [OPTION] [COMMAND | RECEIPT_TO_DECRYPT]"
		echo ""
	        echo "OPTIONS:"
		echo "         -e    Encrypt the input command from command prompt."
		echo "         -d    Decrypt the input receipt file from MPEx."
                echo "         -v    Verbose. Print out the Encrypted/Decrypted result"
                echo "               to STDOUT." 
		echo "         -h    Print this help message."
		echo ""
		echo "Examples:"
		echo "  : ./bitotter_ag.sh -e \"CMD|{MPSIC}|{qty}|{price}|{expiry}\""
		echo "or: ./bitotter_ag.sh -e \"MPEx COMMAND\""
		echo "or: ./bitotter_ag.sh -d mpex_receipt.asc"
		echo "or: ./bitotter_ag.sh -v -d mpex_receipt.asc"
		echo ""
		echo "Please review the MPEx FAQ: http://mpex.co/faq.html"
		echo ""
		echo "For further help, find mod6 at irc.freenode.net" 
		echo "in channels: #bitcoin-assets or #BitOTTer"
		echo ""
		echo "Otherwise email: modsix at gmail dot com. Thank You."
		exit
fi
