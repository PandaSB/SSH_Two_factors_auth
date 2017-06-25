#The MIT License
#Copyright 2017 BARTHELEMY Stephane
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of
#this software and associated documentation files (the "Software"), to deal in
#the Software without restriction, including without limitation the rights to use,
#copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
#Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
#IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
        logout
}

SMS_DEFAULT_DEST=""
if [ -n "$SSH_CLIENT" ]; then
	CHALENGE_PASSWORD=`awk -v min=1 -v max=10000 'BEGIN{srand(); print int(min+rand()*(max-min+1))}'`
	if [ -f "$HOME/.phone" ]
	then
		SMS_DEST="$(head -1 $HOME/.phone)"
	else
		SMS_DEST=$SMS_DEFAULT_DEST
	fi
	if [[ -n "$SMS_DEST" ]] ; then
		echo "$CHALENGE_PASSWORD : Two Factor password for ssh $USER" | gammu --sendsms TEXT $SMS_DEST > /dev/null
		echo "Two-Factor password send to mobile"
	else
	echo "Two-Factor Password : $CHALENGE_PASSWORD"
	fi
	echo -n "Please  enter it below followed by [enter]: "
	read otp
	otp_clean=$(echo $otp | sed 's/[^0-9]//g')
	if [[ x$otp_clean == x$CHALENGE_PASSWORD ]]; then 
		echo "CHALENGE OK."
	else
		echo "CHALENGE FAIL"
		logout
	fi
fi

