
### Testtask App

The Testtask App is designed to streamline the user registration process by providing a smooth and intuitive interface. Users can enter their personal information, upload a profile picture, and select a position from a dynamically fetched list. The app ensures that all inputs are validated before the registration request is sent to the server.

#### Key Features:

- **User Input Validation:** 
  - Validates user inputs such as name, email, phone number, and image.
  - Uses regular expressions to ensure the email and phone number formats are correct.

- **Network Service Integration:** 
  - Integrates with a `NetworkService` to load available positions from the server and to register the user with the provided information.

- **User Registration:** 
  - Handles the Sign-Up process by validating all inputs and sending a registration request to the server. 
  - Compresses the user's profile image before uploading it to ensure it meets file size requirements.

- **Reactive Properties:** 
  - Uses properties with `didSet` observers to trigger UI updates when validation states change.
  - Provides closures for notifying the view about changes in the validation status of text fields and the image upload.

#### Screencast example

https://github.com/user-attachments/assets/b2862eab-860d-47fe-9d2b-a67779865833

---
