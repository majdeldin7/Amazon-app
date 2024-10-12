# --------------> The build image__
FROM node:lts-slim AS build
# Set the working directory inside the container
WORKDIR /app
# Copy package.json and package-lock.json (or yarn.lock) to the container
COPY package*.json ./
# Install project dependencies
RUN npm install
# Copy the rest of the application code to the container
COPY . .
# Build the app 
RUN npm run build

# --------------> The production image__
FROM nginx:alpine-slim
# Set the working directory inside the container
WORKDIR /usr/share/nginx/html
# Remove all data from working directory :
RUN rm -rf ./*
# Copy dist (or build) directory :
COPY --from=build /app/build/ .
# Expose the port that the app will run on (usually 80 by default)
EXPOSE 80
# Set thr entrypoint :
ENTRYPOINT ["nginx", "-g", "daemon off;"]
