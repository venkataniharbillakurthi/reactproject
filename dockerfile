# Step 1: Use a Node.js image to build the app
FROM node:16 as build

# Step 2: Set working directory in the container
WORKDIR /app

# Step 3: Copy package.json and package-lock.json to install dependencies
COPY package.json package-lock.json ./

# Step 4: Install dependencies
RUN npm install

# Step 5: Copy the rest of the application code
COPY . .

# Step 6: Build the application
RUN npm run build

# Step 7: Use an Nginx image to serve the built files
FROM nginx:alpine

# Step 8: Copy the built React files to the Nginx directory
COPY --from=build /app/build /usr/share/nginx/html

# Step 9: Copy custom Nginx configuration to handle React routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Step 10: Expose the container port
EXPOSE 80

# Step 11: Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
