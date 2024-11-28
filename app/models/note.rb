# == Schema Information
#
# Table name: notes
#
#  id          :bigint           not null, primary key
#  body        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  creator_id  :integer
#  document_id :integer
#
class Note < ApplicationRecord
  belongs_to :creator, required: true, class_name: "User", foreign_key: "creator_id"
  belongs_to :document, required: true, class_name: "Document", foreign_key: "document_id"
end
