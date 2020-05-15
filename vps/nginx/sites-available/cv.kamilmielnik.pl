server {
    server_name cv.kamilmielnik.pl;

    location / {
        proxy_pass http://127.0.0.1:3000;
    }

    listen 443 ssl http2;
    ssl_certificate /etc/letsencrypt/live/kamilmielnik.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/kamilmielnik.com/privkey.pem;
}

server {
    listen 80;
    server_name cv.kamilmielnik.pl;
    return 301 https://cv.kamilmielnik.pl$request_uri;
}
