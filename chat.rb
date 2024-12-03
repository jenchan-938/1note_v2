require "openai"
require "dotenv/load"

client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_KEY"))

#where do I put this code?
#I need to tell chatgpt the current list of doc names and body note
# set up the prompt structure 
# how to do if select then use user selected, if not then use the chat gpt

# Set up the message list with a system message
message_list = [
  {
    "role" => "system",
    "content" => "You are a helpful assistant."
  }
]

system_message = Message.new
system_message.quiz_id = the_quiz.id
system_message.role = "system"
system_message.body = "You are the world's best categorizer. My goal is to categorize all of my notes into specific documents with different titles. I will provide you with a random note. Can you please help me assign this note with a title/category? Please either assign it to one of these document titles listed here: #{} or if the note does not fit any of these document titles please assign a new title that is one to two words. The note is #{}"
system_message.save

# Start the conversation loop
user_input = "" #fetch the body of the message note
message_list.push({ "role" => "user", "content" => user_input })

    # Send the message list to the API
    api_response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: message_list
      }
    )

    # Dig through the JSON response to get the content
    choices = api_response.fetch("choices")
    first_choice = choices.at(0)
    message = first_choice.fetch("message")
    assistant_response = message["content"]
    
    # Print the assistant's response
    puts assistant_response
    puts "-" * 50

    # Add the assistant's response to the message list
    message_list.push({ "role" => "assistant", "content" => assistant_response })
  end
end
