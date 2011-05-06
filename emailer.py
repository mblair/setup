import smtplib

fromaddr = 'scripts@matthewblair.net'
toaddrs  = ['me@matthewblair.net']

subject = "finished"

text = "Your script is done."

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
