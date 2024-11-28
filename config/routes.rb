Rails.application.routes.draw do

  # Routes for the Document resource:

  # CREATE
  post("/insert_document", { :controller => "documents", :action => "create" })
          
  # READ
  get("/documents", { :controller => "documents", :action => "index" })
  
  get("/documents/:path_id", { :controller => "documents", :action => "show" })
  
  # UPDATE
  
  post("/modify_document/:path_id", { :controller => "documents", :action => "update" })
  
  # DELETE
  get("/delete_document/:path_id", { :controller => "documents", :action => "destroy" })

  #------------------------------

  # Routes for the Note resource:

  # CREATE
  post("/insert_note", { :controller => "notes", :action => "create" })
          
  # READ
  get("/notes", { :controller => "notes", :action => "index" })
  
  get("/notes/:path_id", { :controller => "notes", :action => "show" })
  
  # UPDATE
  
  post("/modify_note/:path_id", { :controller => "notes", :action => "update" })
  
  # DELETE
  get("/delete_note/:path_id", { :controller => "notes", :action => "destroy" })

  #------------------------------

  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:

  # get "/your_first_screen" => "pages#first"
  
end
