# File uploads using only NGINX

Upload files without writing any code except a config file.
This is a very minimal, very insecure configuration.
One idea for restricting uploads is to require mTLS and use the client's DN to isolate incoming content.
Another way to restrict uploads is to proxy upstream from this server and pass along some additional credential information.

By default, uploaded files are stored under `/var/spool/upload`.
This directory needs to be created with proper permissions before an upload can succeed.
Temporary file storage seems to go to `/var/cache/nginx/client_temp`, which also seems to be part of the NGINX docker image.
