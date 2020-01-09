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

# change shortcuts for Sequel Pro
# We can check by executing $ defaults read com.sequelpro.SequelPro
#defaults write com.sequelpro.SequelPro NSUserKeyEquivalents -dict-add "Save Connection" "@^s"
#defaults write com.sequelpro.SequelPro NSUserKeyEquivalents -dict-add "Save Query" "@s"
defaults write com.sequelpro.SequelPro NSUserKeyEquivalents '{
    "Save Connection" = "@^s";
    "Save Query" = "@s";
}'
