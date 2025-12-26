FROM node:18-alpine AS build

WORKDIR /app

RUN apk add --no-cache git
RUN git clone https://github.com/ManjitSharma963/kataristoneworldinventory.git .
ARG REACT_APP_API_URL=/api
ENV REACT_APP_API_URL=$REACT_APP_API_URL
# Create .env file to ensure React picks up the environment variable
RUN echo "REACT_APP_API_URL=$REACT_APP_API_URL" > .env
# Verify the environment variable is set
RUN echo "Building with REACT_APP_API_URL=$REACT_APP_API_URL" && cat .env
RUN npm install --legacy-peer-deps
RUN npm run build
# Fix undefined API URLs - replace only in fetch/API call contexts, not variable declarations
RUN node -e "const fs=require('fs'),path=require('path');function fix(dir){fs.readdirSync(dir).forEach(f=>{const p=path.join(dir,f);const s=fs.statSync(p);if(s.isDirectory())fix(p);else if(f.endsWith('.js')){let c=fs.readFileSync(p,'utf8');const orig=c;c=c.replace(/\"undefined\/auth\"/g,'\"/api/auth\"');c=c.replace(/\"undefined\/bills\"/g,'\"/api/bills\"');c=c.replace(/\"undefined\/inventory\"/g,'\"/api/inventory\"');c=c.replace(/concat\(p\.API_BASE_URL,\"/g,'concat(\"/api\",\"');c=c.replace(/concat\(undefined,\"/g,'concat(\"/api\",\"');c=c.replace(/\"\\.concat\(p\.API_BASE_URL/g,'\".concat(\"/api\"');c=c.replace(/\"\\.concat\(undefined/g,'\".concat(\"/api\"');if(c!==orig)fs.writeFileSync(p,c,'utf8');}});}fix('/app/build');"

FROM nginx:alpine

# Create nginx config for port 3001
RUN echo 'server {' > /etc/nginx/conf.d/default.conf && \
    echo '    listen 3001;' >> /etc/nginx/conf.d/default.conf && \
    echo '    server_name localhost;' >> /etc/nginx/conf.d/default.conf && \
    echo '' >> /etc/nginx/conf.d/default.conf && \
    echo '    location / {' >> /etc/nginx/conf.d/default.conf && \
    echo '        root /usr/share/nginx/html;' >> /etc/nginx/conf.d/default.conf && \
    echo '        index index.html;' >> /etc/nginx/conf.d/default.conf && \
    echo '        try_files $uri $uri/ /index.html;' >> /etc/nginx/conf.d/default.conf && \
    echo '    }' >> /etc/nginx/conf.d/default.conf && \
    echo '}' >> /etc/nginx/conf.d/default.conf

# Copy build output to nginx html directory
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 3001
