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
    the_document.original_body = params.fetch("query_original_body")
    the_document.user_id = params.fetch("query_user_id")
    the_document.title = params.fetch("query_title")

    if the_document.valid?
      the_document.save
      redirect_to("/documents", { :notice => "Document created successfully." })
    else
      redirect_to("/documents", { :alert => the_document.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_document = Document.where({ :id => the_id }).at(0)

    the_document.original_body = params.fetch("query_original_body")
    the_document.user_id = params.fetch("query_user_id")
    the_document.title = params.fetch("query_title")

    if the_document.valid?
      the_document.save
      redirect_to("/documents/#{the_document.id}", { :notice => "Document updated successfully."} )
    else
      redirect_to("/documents/#{the_document.id}", { :alert => the_document.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_document = Document.where({ :id => the_id }).at(0)

    the_document.destroy

    redirect_to("/documents", { :notice => "Document deleted successfully."} )
  end
end
