class AddReclassifyToDocuments < ActiveRecord::Migration[7.1]
  def change
    add_column :documents, :reclassify, :string
  end
end
