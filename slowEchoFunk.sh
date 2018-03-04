#!/bin/bash


slowecho ()
{
slowout="$1"
expect -c 'set send_human {.1 .3 1 .05 2}';
spawn echo "$env(slowout)";
interact -indices -o -re ".+" { send_user -h -- "$interact_out(0,string)" }'
}

slowecho "This is a test"
