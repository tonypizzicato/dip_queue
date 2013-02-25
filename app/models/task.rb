class Task
  include Mongoid::Document
  field :type, type: Integer
  field :title, type: String
  field :desc, type: String

  validates_uniqueness_of :type
  validates_presence_of :type, :title
end
