//= require active_admin/base
//= require active_admin_flat_skin

document.addEventListener("DOMContentLoaded", () => {
  const sendButton = document.getElementById("send-chat");
  const chatInput = document.getElementById("chat-input");
  const chatMessagesContainer = document.getElementById("chat-messages");
  let currentUserId = null;

  // Added: Function to auto-scroll to the bottom of the chat when new messages arrive
  function scrollToBottom() {
    chatMessagesContainer.scrollTop = chatMessagesContainer.scrollHeight;
  }

  // Modified: Load and display chat history with improved formatting
  async function loadChatHistory(userId) {
    try {
      const response = await fetch(`/admin/chat/history?user_id=${userId}`, {
        method: 'GET',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        },
      });

      if (response.ok) {
        const messages = await response.json();
        chatMessagesContainer.innerHTML = ""; // Clear previous messages
        messages.forEach(message => displayMessage(message)); // Display existing messages
        scrollToBottom(); // Added: Scroll to the latest message
      } else {
        console.error("Failed to load chat history:", await response.json());
      }
    } catch (error) {
      console.error("Error loading chat history:", error);
    }
  }

  // Reply button handler
  document.querySelectorAll(".reply-button").forEach(button => {
    button.addEventListener("click", function(event) {
      event.preventDefault(); // Prevent default link behavior
      currentUserId = this.dataset.userId; // Set the user ID to reply to
      document.getElementById("user-id").value = currentUserId; // Populate hidden user ID field
      chatMessagesContainer.innerHTML = ""; // Clear previous messages if necessary

      // Load existing messages from the selected user
      loadChatHistory(currentUserId);
    });
  });

  if (sendButton) { // Check if the send button exists on the page
    sendButton.addEventListener("click", async () => {
      const message = chatInput.value;
      const userId = document.getElementById("user-id").value; // Get the user ID from the hidden input

      if (message.trim() === "" || !userId) return; // Ensure we have a message and user ID

      try {
        const response = await fetch('/admin/chat/reply', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          },
          body: JSON.stringify({ message, user_id: userId }),
        });

        if (response.ok) {
          const chatMessage = await response.json();
          displayMessage(chatMessage); // Display the sent message
          chatInput.value = ''; // Clear input after sending
          scrollToBottom(); // Added: Scroll to the bottom when a message is sent
        } else {
          console.error("Failed to send message:", await response.json());
        }
      } catch (error) {
        console.error("Error sending message:", error);
      }
    });

    // Modified: Improved message display formatting to make it look like a chat bubble
    function displayMessage(chatMessage) {
      const messageDiv = document.createElement("div");

      // Style messages differently based on the sender (admin or user)
      messageDiv.classList.add("chat-message");
      if (chatMessage.sender === "admin") {
        messageDiv.classList.add("admin-message"); // Style for admin messages
      } else {
        messageDiv.classList.add("user-message"); // Style for user messages
      }

      // Improved: Show the sender and message in a more readable format
      messageDiv.innerHTML = `<strong>${chatMessage.sender}:</strong> ${chatMessage.message}`;
      
      chatMessagesContainer.appendChild(messageDiv);
    }
  }
});
