class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents do |t|
      t.string :original_body
      t.integer :user_id
      t.string :title

      t.timestamps
    end
  end
end
