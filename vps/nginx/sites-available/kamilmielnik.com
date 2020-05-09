server {
    server_name kamilmielnik.com;
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
    if ($host = kamilmielnik.com) {
        return 301 https://$host$request_uri;
    }

    server_name kamilmielnik.com;

    listen 80;
    return 404;
}
