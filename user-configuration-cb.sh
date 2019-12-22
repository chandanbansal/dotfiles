#!/bin/bash
# runs user-configuration.sh and then applies changes that are specific to my
# identity using only publicly publishable data

source ./user-configuration.sh


cat <<EOF >> ~/.gitconfig
[user]
	name = Chandan Bansal
	email = chandanbansal2004@gmail.com
	signingkey = chandanbansal2004@gmail.com
[github]
	user = chandanbansal
EOF