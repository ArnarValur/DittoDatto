FROM node:20-alpine AS build

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install all dependencies (including devDependencies for build)
RUN npm ci

# Copy all files
COPY . .

# Build the Nuxt application
RUN npm run build

# Production image
FROM node:20-alpine

WORKDIR /app

# Copy the built output from the build stage
COPY --from=build /app/.output ./.output

# Nuxt / Nitro server environment variables
ENV HOST=0.0.0.0
ENV PORT=3000
ENV NODE_ENV=production

EXPOSE 3000

# Start the standalone server
CMD ["node", ".output/server/index.mjs"]
