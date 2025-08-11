# Stage 1: Build
FROM node:20-alpine AS build

# Install dumb-init for proper signal handling
RUN apk add --no-cache dumb-init

WORKDIR /usr/src/app

# Copy package files and install all dependencies
COPY package*.json ./
RUN npm ci

# Copy source code
COPY . .

# Build the app
RUN npm run build

# Stage 2: Production
FROM node:20-alpine

RUN apk add --no-cache dumb-init

WORKDIR /usr/src/app

# Create a non-root user
RUN addgroup -g 1001 -S nodejs && adduser -S vendure -u 1001

# Copy only production node_modules and built files from build stage
COPY --from=build /usr/src/app/package*.json ./
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/static ./static
COPY --from=build /usr/src/app/firebase-service-account.json ./firebase-service-account.json

# Make node_modules writable for vendure user
RUN chown -R vendure:nodejs /usr/src/app/node_modules

# Create directories for static files and asset uploads with proper permissions
RUN mkdir -p static/assets static/email/test-emails /tmp/assets && \
    chown -R vendure:nodejs static/ && \
    chown -R vendure:nodejs /tmp/assets

USER vendure

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "const http = require('http'); const options = { host: 'localhost', port: 3000, path: '/health', timeout: 2000 }; const req = http.request(options, (res) => { process.exit(res.statusCode === 200 ? 0 : 1); }); req.on('error', () => process.exit(1)); req.end();"

ENTRYPOINT ["dumb-init", "--"]
CMD ["npm", "start"]
