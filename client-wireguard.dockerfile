FROM alpine:3.18
RUN apk add --no-cache wireguard-tools bash

COPY /client/scripts/wait-for-file.sh /usr/local/bin/wait-for-file.sh
COPY /client/scripts/entrypoint.sh     /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/wait-for-file.sh /usr/local/bin/entrypoint.sh

# Make the wait‐script the container's entrypoint
ENTRYPOINT ["/usr/local/bin/wait-for-file.sh"]
# Default args: <file> <timeout> <cmd-to-run>
CMD ["/etc/wireguard/privatekey","90","/usr/local/bin/entrypoint.sh"]
