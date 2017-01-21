#!/bin/python3
import os
import sys
import smtplib
import fileinput
import tempfile
import urllib.request
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email.utils import COMMASPACE, formatdate

debug=False

VERISURE=False
STATUS=""

try:
	execfile("/etc/domoticz/scripts.conf")
except:
	exec(open("/etc/domoticz/scripts.conf", encoding="utf-8").read())

data = sys.stdin.readlines()

for line in data:
	if line == "From: Verisure <no-reply@verisure.com>\n":
		VERISURE=True
	if (line == "Subject: Avlarmat\n") or (line == "Subject: Dissarmed\n"):
		STATUS="DISSARMED"
	if (line == "Subject: Larmat\n") or (line == "Subject: Armed\n"):
		STATUS="ARMED"

if debug:
	print(VERISURE)
	print(STATUS)

if VERISURE and STATUS=="DISSARMED":
	url= baseurl + "?type=command&param=switchlight&idx=6&switchcmd=On"

	request = urllib.request.Request(url)
	request.add_header('Authorization', 'Basic ' + auth)
	r = urllib.request.urlopen(request)
	if debug:
		print("Status code: " + str(r.getcode()))
	if r.getcode() != 200:
		print("Error updating temp in Domoticz. HTTP code: " + str(r.getcode()))
elif STATUS=="":
	msg = MIMEMultipart()
	msg['From'] = email
	msg['To'] = mailto
	msg['Date'] = formatdate(localtime=True)
	msg['Subject'] = subject
	msg.attach(MIMEText(mailcontent))

	f = tempfile.mkstemp()
	if debug:
		print(f[1])
	fh = open(f[1], 'w')
	fh.write("\n".join(data))
	fh.close()

	with open(f[1], "r") as fh:
		part = MIMEText(fh.read())
	part['Content-Disposition'] = 'attachment; filename="mail.eml"'
	msg.attach(part)

	s = smtplib.SMTP('localhost')
	s.send_message(msg)
	s.quit()
	os.remove(f[1])
	if debug:
		print("Sent e-mail")
