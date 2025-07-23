FROM node:20-slim AS base

# Set environment variables
ENV NODE_ENV=production \
    IP_ADDRESS=localhost \
    PORT=3000 \
    ELASTICSEARCH_HOSTS=http://localhost:9200 \
    PATH_TO_DATA=/app/data \
    MEETINGS_INDEX_NAME=meetings-index \
    WORDS_INDEX_NAME=words-index \
    SENTENCES_INDEX_NAME=sentences-index

# Create app directory
WORKDIR /app

# Copy only package.json & package-lock.json first (leverage Docker layer caching)
COPY package*.json ./

# Install dependencies (only production deps for smaller image)
RUN npm ci --omit=dev

# Copy application source
COPY . .

# Expose the port
EXPOSE 3000

# Use non-root user for security
USER appuser

# Start the API
CMD ["npm", "start"]
