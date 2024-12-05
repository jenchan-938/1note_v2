class NotesController < ApplicationController
  def index
    matching_notes = Note.all

    @list_of_notes = matching_notes.order({ :created_at => :desc })

    render({ :template => "notes/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_notes = Note.where({ :id => the_id })

    @the_note = matching_notes.at(0)

    render({ :template => "notes/show" })
  end

  def create
    the_note = Note.new
    the_note.body = params.fetch("query_body")
    the_note.creator_id = current_user.id

    if params.fetch("document_id", nil).blank?

      message_list = [
        {
          "role" => "system",
          "content" => "You are the world's best categorizer. My goal is to categorize all of my notes into specific documents with different titles. I will provide you with a random note. The note is: #{the_note.body}",
        },
        {
          "role" => "user",
          "content" => "Can you please help me assign this note with a title/category? Please either assign it to one of these document titles listed here: #{Document.all.pluck(:title)} or if the note does not fit any of these document titles please respond with only one word that would be a good new title. Please only respond with one word",
        },
      ]

      # Send the message list to the API
      client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_KEY"))

      api_response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: message_list,
        },
      )

      @chatgpt_title = api_response.fetch("choices").at(0).fetch("message").fetch("content")
      pp @chatgpt_title
  
    
      
      if Document.where({ :title => @chatgpt_title}).at(0)  == nil
        d=Document.new
        d.title= @chatgpt_title
        d.save
        the_note.document_id=Document.where({ :title => @chatgpt_title}).at(0).id 
      else
        the_note.document_id=Document.where({ :title => @chatgpt_title}).at(0).id 
      end
     
      #how would the document create a new id?
      

    else
      the_note.document_id = params.fetch("document_id") #this is now optional
    end

    if the_note.valid?
      the_note.save
      redirect_to("/notes", { :notice => "Note created successfully." })
    else
      redirect_to("/notes", { :alert => the_note.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_note = Note.where({ :id => the_id }).at(0)

    the_note.body = params.fetch("query_body")
    the_note.creator_id = params.fetch("query_creator_id")
    the_note.document_id = params.fetch("query_document_id")

    if the_note.valid?
      the_note.save
      redirect_to("/notes/#{the_note.id}", { :notice => "Note updated successfully." })
    else
      redirect_to("/notes/#{the_note.id}", { :alert => the_note.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_note = Note.where({ :id => the_id }).at(0)

    the_note.destroy

    redirect_to("/notes", { :notice => "Note deleted successfully." })
  end
end
