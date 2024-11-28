# == Schema Information
#
# Table name: documents
#
#  id            :bigint           not null, primary key
#  original_body :string
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer
#
class Document < ApplicationRecord
  has_many  :notes, class_name: "Note", foreign_key: "document_id", dependent: :destroy
end
