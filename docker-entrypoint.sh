#!/bin/ash - 
#===============================================================================
#
#          FILE: docker-entrypoint.sh
# 
#         USAGE: ./docker-entrypoint.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Michael Konrad (), 
#  ORGANIZATION: 
#       CREATED: 01/20/2025 15:25
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

PHX_HOME=/opt/phoenix
# set ecto install to no by default
ECTO="${ECTO:-n}"
# docker secrets - db secret file
DB_SECRET_FILE=/run/secrets/postgres_password
DB_PWD=''

get_db_pwd() {
	# read the database password from a docker's secret file
	if [ -f "$DB_SECRET_FILE" ]; then
		while read -r secret; do
			DB_PWD="$secret"
		done < $DB_SECRET_FILE
	else
		printf "Database secret is not set, aborting install.\n"
		#exit 1
	fi
}


phx_config() {
	# program directory /opt/phoenix
	if [[ -d $PHX_HOME/$APP_NAME/config ]]; then
		# Configure dev.exs for docker
		printf "Updating dev.exs...\n"
		update_file="$PHX_HOME/$APP_NAME/config/dev.exs"
		if [[ $ECTO == 'y' ]]; then
			get_db_pwd		
			sed -i '' -e "s|\(password: \).*|\1"$DB_PWD"|" \
			-e 's|"localhost"|"db"|' \
			-e 's|127, 0, 0, 1|0, 0, 0, 0|' $update_file >/dev/null 2>&1
		else
			sed -i '' -e 's|127, 0, 0, 1|0, 0, 0, 0|' $update_file >/dev/null 2>&1
		fi

		# Configure test.exs for docker
		printf "Updating test.exs...\n"
		update_file="$PHX_HOME/$APP_NAME/config/test.exs"
		if [[ $ECTO == 'y' ]]; then
			get_db_pwd		
			sed -i '' -e "s|\(password: \).*|\1"$DB_PWD"|" \
			-e 's|"localhost"|"db"|' \
			-e 's|127, 0, 0, 1|0, 0, 0, 0|' $update_file >/dev/null 2>&1
		else	
			sed -i '' -e 's|127, 0, 0, 1|0, 0, 0, 0|' $update_file >/dev/null 2>&1
		fi
	fi
}

phx_install() {
	# ensure APP_NAME has been set 
	if [ -n $APP_NAME ]; then
		# program directory /opt/phoenix
		if [[ ! -d $PHX_HOME/$APP_NAME/config ]]; then
			printf "Running mix phx.new...\n"
			if [[ $ECTO == 'y' ]]; then
				yes Y | mix phx.new --install $PHX_HOME/$APP_NAME --binary-id
			else
				yes Y | mix phx.new --install --no-ecto $PHX_HOME/$APP_NAME --binary-id
			fi
			
			if [ $? -lt 1 ]; then 
				phx_config
			fi
		fi
	else
		printf "APP_NAME has not been set, exiting."
		exit 1
	fi
}

main() {
	phx_install

	cd $PHX_HOME/$APP_NAME	
	exec "$@"
}

main "$@"
