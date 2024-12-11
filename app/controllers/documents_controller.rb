class DocumentsController < ApplicationController
  def index
    matching_documents = Document.all

    @list_of_documents = matching_documents.order({ :created_at => :desc })

    render({ :template => "documents/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_documents = Document.where({ :id => the_id })

    @the_document = matching_documents.at(0)

    render({ :template => "documents/show" })
  end

  def create
    the_document = Document.new
    the_document.user_id = current_user.id
    the_document.title = params.fetch("query_title")

    if the_document.valid?
      the_document.save
      redirect_to("/documents", { :notice => "Document created successfully." })
    else
      redirect_to("/documents", { :alert => the_document.errors.full_messages.to_sentence })
    end
  end

  def update
    reclassification = params.fetch("reclassify")
    structure = params.fetch("structure")
    doc_id= params.fetch("path_id")
    @doc =Document.where({:id => doc_id}).at(0)

    if reclassification == "on"
      notes = @doc.notes.map do |a_note|  #map vs. each
        "<p> #{a_note.body} </p>"
        end.join
      
      all_notes = [
        {
          "role" => "system",
          "content" => "Given the input #{structure}, reorganize the notes in a logical way. Return HTML formatted re-structured notes. Do not include markdown syntax. Only include HTML. It must be raw HTML."
        },
    
        {
      "role" => "user",
      "content" => "the notes are #{notes}"
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

      chat_gpt_reclassification= chatgpt_response.fetch("choices").at(0).fetch("message").fetch("content")
      @chat_gpt_reclassify = chat_gpt_reclassification.html_safe
      @doc.reclassify = @chat_gpt_reclassify
      @doc.save
         

      else
        @chat_gpt_reclassify = "na"
        @doc.reclassify = @chat_gpt_reclassify
        @doc.save

      end
    

      if @doc.valid?
        @doc.save
        redirect_to("/documents/#{@doc.id}", { :notice => "Document updated successfully."} )
       
      else
        redirect_to("/documents/#{@doc.id}", { :alert => @doc.errors.full_messages.to_sentence })
      end
    end

  def destroy
    the_id = params.fetch("path_id")
    the_document = Document.where({ :id => the_id }).at(0)

    the_document.destroy

    redirect_to("/documents", { :notice => "Document deleted successfully."} )
  end
end
