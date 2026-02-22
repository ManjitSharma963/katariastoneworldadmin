FROM node:18-alpine AS build

WORKDIR /app

RUN apk add --no-cache git

RUN git clone https://github.com/ManjitSharma963/katariastoneworld.git .

# Use /api so nginx proxies to backend (no localhost:8080)
ENV REACT_APP_API_URL=/api
RUN echo "REACT_APP_API_URL=$REACT_APP_API_URL" > .env

RUN npm install --legacy-peer-deps
RUN npm run build

# Replace hardcoded localhost:8080 API URLs with /api in built output
RUN node -e "const fs=require('fs'),path=require('path');function fix(dir){fs.readdirSync(dir).forEach(f=>{const p=path.join(dir,f);const s=fs.statSync(p);if(s.isDirectory())fix(p);else if(f.endsWith('.js')||f.endsWith('.js.map')){let c=fs.readFileSync(p,'utf8');const orig=c;c=c.replace(/https?:\\/\\/localhost:8080\\/api\\/?/g,'/api');c=c.replace(/https?:\\/\\/localhost:8080\\/?/g,'');c=c.replace(/\"http:\\/\\/localhost:8080\\/api\"/g,'\"/api\"');c=c.replace(/\"http:\\/\\/localhost:8080\"/g,'\"\"');if(c!==orig)fs.writeFileSync(p,c,'utf8');}});}fix('/app/build');"


FROM nginx:alpine

# Update nginx config to listen on port 3000
RUN echo 'server {' > /etc/nginx/conf.d/default.conf && \
    echo '    listen 3000;' >> /etc/nginx/conf.d/default.conf && \
    echo '    server_name localhost;' >> /etc/nginx/conf.d/default.conf && \
    echo '' >> /etc/nginx/conf.d/default.conf && \
    echo '    location / {' >> /etc/nginx/conf.d/default.conf && \
    echo '        root /usr/share/nginx/html;' >> /etc/nginx/conf.d/default.conf && \
    echo '        index index.html;' >> /etc/nginx/conf.d/default.conf && \
    echo '        try_files $uri $uri/ /index.html;' >> /etc/nginx/conf.d/default.conf && \
    echo '    }' >> /etc/nginx/conf.d/default.conf && \
    echo '}' >> /etc/nginx/conf.d/default.conf

COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 3000
