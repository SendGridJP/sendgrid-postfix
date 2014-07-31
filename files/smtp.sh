#!/bin/bash

to=recipient@address.com
from=your@address.com

function mail_input {
  echo "EHLO test.com"
sleep 1
  echo "mail from: $from"
  echo "rcpt to: $to"
  echo "data"
  echo "To: $to"
  echo "From: $from"
  echo "Subject: Hello postfix"
  echo "test mail"
  echo "."
  echo "quit"
}

# send
mail_input | nc localhost 25
