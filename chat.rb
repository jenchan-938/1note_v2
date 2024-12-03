require "openai"
require "dotenv/load"


#where do I put this code?
#I need to tell chatgpt the current list of doc names and body note >> how to tell it the body if the forum is not submitted yet?
# set up the prompt structure  >> any feedback?
# how to do if select then use user selected, if not then use the chat gpt? Do I had an if statement to the notes controller if id = blank? how to make it ok if we dont selete forum? Can i add on select to be on untitled?
#how to integrate text file into the first page?

# Set up the message list with a system message

message_list = [
  {
    "role" => "system",
    "content" => "You are the world's best categorizer. My goal is to categorize all of my notes into specific documents with different titles. I will provide you with a random note. The note is: #{}"
  },
  {
    "role" => "user",
    "content" => "Can you please help me assign this note with a title/category? Please either assign it to one of these document titles listed here: #{Document.all.pluck(:title)} or if the note does not fit any of these document titles please assign a new title that is one to two words"
  }
]


    # Send the message list to the API
    client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_KEY"))

    api_response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: message_list
      }
    )

   @chatgpt_title=api_response.fetch("choices").at(0).fetch("message").fetch("content")
  
   pp @chatgpt_title

   #when a user triggers a create action 
