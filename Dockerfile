# Stage 1: Build the React application
FROM node:14-alpine AS build

# Set working directory for build
WORKDIR /app
#
# Install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React application
RUN npm run build

# Stage 2: Serve the application with Express
FROM node:14-alpine

# Set working directory for the server
WORKDIR /app

# Copy build files from the previous stage
COPY --from=build /app/build ./build
COPY --from=build /app/package.json ./
COPY --from=build /app/package-lock.json ./
COPY --from=build /app/server.js ./

# Install dependencies for the server
RUN npm install

# Expose port 3000
EXPOSE 3000

# Start the server
CMD ["node", "server.js"]
