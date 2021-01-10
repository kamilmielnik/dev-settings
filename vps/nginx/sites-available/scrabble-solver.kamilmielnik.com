server {
    server_name scrabble-solver.kamilmielnik.com;

    location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $proxy_host;
        proxy_set_header X-NginX-Proxy true;
        proxy_pass http://127.0.0.1:3333;
    }

    listen 443 ssl http2;
    ssl_certificate /etc/letsencrypt/live/kamilmielnik.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/kamilmielnik.com/privkey.pem;
}

server {
    listen 80;
    server_name scrabble-solver.kamilmielnik.com;
    return 301 https://scrabble-solver.kamilmielnik.com$request_uri;
}
