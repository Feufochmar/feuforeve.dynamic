#! /bin/sh

CONTENT=$(curl -s http://localhost:8080/FloraCharacterGenerator/sendmail)
ADDRESS="tumblr-secret-email-address@tumblr.com"
echo "From: user@domain
To: $ADDRESS
$CONTENT
" | sendmail $ADDRESS

