# Use Node.js 20 Alpine for smaller image size
FROM node:20-alpine

# Install dumb-init for proper signal handling
RUN apk add --no-cache dumb-init

# Create app directory
WORKDIR /usr/src/app

# Create a non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S vendure -u 1001

# Copy package files
COPY package*.json ./

# Install all dependencies (including dev dependencies for build)
RUN npm ci --only=production && npm cache clean --force

# Copy source code
COPY --chown=vendure:nodejs . .

# Install dev dependencies and build
RUN npm ci && npm run build && npm prune --production

# Make node_modules writable for vendure user (needed for AdminUI config file)
RUN chown -R vendure:nodejs /usr/src/app/node_modules

# Create directories for static files with proper permissions
RUN mkdir -p static/assets static/email/test-emails && \
    chown -R vendure:nodejs static/

# Switch to non-root user
USER vendure

# Expose port
EXPOSE 3000

# Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "const http = require('http'); const options = { host: 'localhost', port: 3000, path: '/health', timeout: 2000 }; const req = http.request(options, (res) => { process.exit(res.statusCode === 200 ? 0 : 1); }); req.on('error', () => process.exit(1)); req.end();"

# Use dumb-init to handle signals properly
ENTRYPOINT ["dumb-init", "--"]

# Start the application
CMD ["npm", "start"]
