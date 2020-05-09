server {
    server_name cv.kamilmielnik.pl;
    root /var/www/cv;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    listen 443 ssl http2;
    ssl_certificate /etc/letsencrypt/live/cv.kamilmielnik.pl/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/cv.kamilmielnik.pl/privkey.pem;
}

server {
    if ($host = cv.kamilmielnik.pl) {
        return 301 https://$host$request_uri;
    }

    server_name cv.kamilmielnik.pl;

    listen 80;
    return 404;
}
