upstream tanyaslawta.com {
	server 127.0.0.1:4000;
}
server {
	server_name tanyaslawta.com www.tanyaslawta.com;
	location / {
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header Host $http_host;
		proxy_set_header X-NginX-Proxy true;
		proxy_pass http://tanyaslawta.com/;
		proxy_redirect off;
	}


    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/blakenoble.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/blakenoble.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}

server {
	if ($host = www.tanyaslawta.com) {
		return 301 https://$host$request_uri;
	}

	if ($host = tanyaslawta.com) {
		return 301 https://$host$request_uri;
	}

	listen 80;

	server_name tanyaslawta.com www.tanyaslawta.com;

	return 301 https://$host$request_uri;
}

server {
    if ($host = tanyaslawta.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

	server_name tanyaslawta.com www.tanyaslawta.com;

listen 80;
    return 404; # managed by Certbot
}

server {
    if ($host = tanyaslawta.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

	server_name tanyaslawta.com www.tanyaslawta.com;

	listen 80;
    return 404; # managed by Certbot
}