# Isn't it ironic?


# Installation for ubuntu/debian-based systems
install:
	sudo cp gradle_tab_completion.sh /etc/bash_completion.d/gradlew
	sudo chmod a+x /etc/bash_completion.d/gradlew

.PHONY: install
