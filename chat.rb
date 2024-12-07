require "openai"
require "dotenv/load"



all_notes = [
  {
    "role" => "system",
    "content" => "You are the world's best formatter. My goal is to reformat my notes to optimize clarity and insights. Can you please read through all of these notes I will provide and think about how to best show all of these notes on the page based on the content. [For example, if the note is about tracking to-do's make each note the same bullets. If the note is about fitness make sure to categorize it by muscle group/body part to help someone track their progress.] Please give me an output in HTML. Please do not include <DOCUTYPE>, <body>, and just the core html."
  },
  {
    "role" => "user",
    "content" => "the notes are {Document.notes.all}"
  }
]


    # Send the message list to the API
    client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_KEY"))

    chatgpt_response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: all_notes
      }
    )

   @chat_gpt_reclassification =chatgpt_response.fetch("choices").at(0).fetch("message").fetch("content")
  
   

   