#!/bin/bash
if [[ -f /omnidb-server/config.lock ]]; then
  echo -e "config.lock found in /omnidb-server. Skipping ENV setup."
  echo -e "(Remove config.lock if you would like to update config.py)"
  exit 0
else
  echo -e "Modifying config.py with ENV values..."
  echo -e "(Tip: Add empty file config.lock to /omnidb-server to prevent overwriting settings)"
  cd /omnidb-server
  if [[ $^LISTENING_PORT != "8000" ]]; then
    sed -i "s/LISTENING_PORT[[:blank:]]*=.*$/LISTENING_PORT       = ${LISTENING_ADDRESS}/g" config.py
  fi
  if [[ $LISTENING_ADDRESS != "127.0.0.1" ]]; then
    sed -i "s/^LISTENING_ADDRESS[[:blank:]]*=  .*$/LISTENING_ADDRESS    = '${LISTENING_ADDRESS}'/g" config.py
  fi
  if [[ $IS_SSL == "true" ]] || [[ $IS_SSL == "True" ]] || [[ $IS_SSL == "Yes" ]] || [[ $IS_SSL == "yes" ]]; then
    sed -i "s/^IS_SSL[[:blank:]]*=.*$/IS_SSL                 = True/g" config.py
  elif [[ $IS_SSL == "false" ]] || [[ $IS_SSL == "False" ]] || [[ $IS_SSL == "No" ]] || [[ $IS_SSL == "no" ]]; then
    sed -i "s/^IS_SSL[[:blank:]]*=.*$/IS_SSL                 = False/g" config.py
  fi
  if [[ ! -z $SSL_CERTIFICATE_FILE ]]; then
    sed -i "s/^SSL_CERTIFICATE_FILE[[:blank:]]*= .*$/SSL_CERTIFICATE_FILE   = '${SSL_CERTIFICATE_FILE}'/g" config.py
  fi
  if [[ ! -z $SSL_KEY_FILE ]]; then
    sed -i "s/^SSL_KEY_FILE[[:blank:]]*= .*$/SSL_KEY_FILE           = '${SSL_KEY_FILE}'/g" config.py
  fi
  if [[ ! -z $SESSION_COOKIE_SECURE ]]; then
    sed -i "s/^#SESSION_COOKIE_SECURE[[:blank:]]*= .*$/SESSION_COOKIE_SECURE  = '${SESSION_COOKIE_SECURE}'/g" config.py
    sed -i "s/^SESSION_COOKIE_SECURE[[:blank:]]*= .*$/SESSION_COOKIE_SECURE  = '${SESSION_COOKIE_SECURE}'/g" config.py
  fi
  if [[ ! -z $CSRF_COOKIE_SECURE ]]; then
    sed -i "s/^#CSRF_COOKIE_SECURE[[:blank:]]*= .*$/CSRF_COOKIE_SECURE     = '${CSRF_COOKIE_SECURE}'/g" config.py
    sed -i "s/^CSRF_COOKIE_SECURE[[:blank:]]*= .*$/CSRF_COOKIE_SECURE     = '${CSRF_COOKIE_SECURE}'/g" config.py
  fi
  if [[ ! -z $CUSTOM_PATH ]]; then
    sed -i "s/^CUSTOM_PATH[[:blank:]]*= .*$/CUSTOM_PATH    = '${CUSTOM_PATH}'/g" config.py
  fi
fi
exit 0
