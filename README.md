
# Testtask App

## Overview
The main `NetworkManager` class is designed to interact with a backend API for user management, including authentication, registration, fetching users, and retrieving job positions. It is built with Swift using `async/await` for asynchronous network requests.

## Configuration Options

1. **API Endpoints**:
   - The base URL for all API requests is:
     ```
     https://frontend-test-assignment-api.abz.agency/api/v1
     ```
   - The endpoints used in the app are predefined in the `Endpoint` enum:
     - `/users`: Fetch or register users.
     - `/positions`: Retrieve available positions.
     - `/token`: Obtain an authentication token.
     - `/users/{id}`: Fetch a specific user by ID.

2. **Customizing API Requests**:
   You can modify the following parameters when making API requests:
   - Page and count in the `fetchUsers(page:count:)` function to paginate through user data.
   - User registration details like name, email, phone, position_id, and photo in the `registerUser(request:)` function.

3. **API Tokens**:
   The app retrieves an authentication token and stores it internally. The token is required for secure endpoints, like user registration, and is automatically added to the request headers.

## Dependencies

This project uses the following external dependencies:

1. **URLSession**: The native Swift framework for network communication. It performs all HTTP requests asynchronously.

2. **Decodable**: The `Decodable` protocol is used to convert JSON data returned by the API into Swift types.

No additional third-party libraries are required, making the app lightweight and easy to manage.

## Troubleshooting & Common Issues

### 1. Invalid URL
If an invalid URL is provided, you will encounter a `NetworkError.invalidURL`. This error indicates that the `Endpoint` or URL construction is incorrect.

**Fix**: Ensure that the URL is correctly formatted in the `Endpoint` enum and that all query parameters are valid.

### 2. No Internet Connection
When the device is not connected to the internet, requests will fail with a `NetworkError.noInternetConnection`.

**Fix**: Check your network connection and retry the request once connected.

### 3. Server Error (4xx/5xx)
If the server returns an error (e.g., 404 or 500), the app will throw a `NetworkError.serverError(statusCode:)`.

**Fix**: Ensure that the API endpoints are correct and that the server is operational. Also, verify that you're sending the right data in the request.

### 4. Decoding Error
If the API response cannot be parsed into the expected data model, a `NetworkError.decodingError` is thrown.

**Fix**: Ensure that the response data matches the structure of the expected Swift model. Check the API documentation for changes in the response format.

### 5. Authentication Issues
If you receive a 401 error when registering a user, the app likely failed to fetch or use a valid authentication token.

**Fix**: Ensure the `fetchToken` method is successfully called during initialization, and verify that the token is being added to the request headers.

### 5. Screencast example

https://github.com/user-attachments/assets/23cf94a9-e9ea-4d53-ac20-81bb88bdadee

---
