#! /bin/sh

QUOTE=$(curl -s http://localhost:8080/ArnYtron3000/brut)
ADDRESS="tumblr-secret-email-address@tumblr.com"
echo "From: user@domain
To: $ADDRESS
Subject:
Aujourd'hui, ArnYtron3000 vous salue par ces mots :
<strong>$QUOTE</strong>
.
" | sendmail $ADDRESS

