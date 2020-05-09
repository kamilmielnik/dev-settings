server {
    server_name kamilmielnik.pl;
    root /var/www/cv;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    listen 443 ssl http2;
    ssl_certificate /etc/letsencrypt/live/kamilmielnik.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/kamilmielnik.com/privkey.pem;
}

server {
    listen 80;
    server_name kamilmielnik.pl;
    return 301 https://kamilmielnik.pl$request_uri;
}
