#!/bin/bash

# Create the 'scripts' subfolder if it does not exist
mkdir -p scripts

# Prompt the user for the local domain
read -p "Enter your local domain (e.g., skyrocket-dtxcom.local): " DOMAIN

if [ -z "$DOMAIN" ]; then
  echo "Error: Domain cannot be empty."
  exit 1
fi

# Define the output file path inside the 'scripts' folder
FILENAME="scripts/setup-ssl-${DOMAIN}.sh"

# Write out the script file with the substituted domain
cat << EOF > "$FILENAME"
#!/bin/bash

# Go to certificates folder
cd ~/Library/Application\\ Support/Local/run/router/nginx/certs/

# Use mkcert to make a certificate
mkcert -cert-file ${DOMAIN}.crt -key-file ${DOMAIN}.key ${DOMAIN} "*.${DOMAIN}"

# Go into WP Local and start up Site Shell. Run the following commands:
wp search-replace 'http://${DOMAIN}' 'https://${DOMAIN}' --all-tables
wp option update home 'https://${DOMAIN}'
wp option update siteurl 'https://${DOMAIN}'
wp cache flush
EOF

echo "Successfully created: $FILENAME"

# Open the newly created file in VS Code
code "$FILENAME"