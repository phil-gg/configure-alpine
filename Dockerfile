FROM i386/alpine:latest
# sleep for 5000 days (bit over 13½ years); keeps container running
CMD ["busybox","sleep","432000000"]
