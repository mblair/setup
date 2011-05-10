import sys
import smtplib

fromaddr = 'scripts@matthewblair.net'
toaddrs  = ['me@matthewblair.net']

subject = "setup " + sys.argv[1]

if sys.argv[1] == "failed":
    text = "Your script failed on line " + sys.argv[2]
else:
    text = "Setup succeeded."

message = """\
From: %s
To: %s
Subject: %s

%s
""" % (fromaddr, ", ".join(toaddrs), subject, text)

username = 'scripts@matthewblair.net'
password = 'changeme'

server = smtplib.SMTP('smtp.gmail.com:587')
server.starttls()
server.login(username,password)
server.sendmail(fromaddr, toaddrs, message)
server.quit()
