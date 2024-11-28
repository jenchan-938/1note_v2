class CreateNotes < ActiveRecord::Migration[7.1]
  def change
    create_table :notes do |t|
      t.string :body
      t.integer :creator_id
      t.integer :document_id

      t.timestamps
    end
  end
end
