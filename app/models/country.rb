class Country
  include Mongoid::Document
  field :title, type: String

  has_many :leagues

  validates_presence_of :title
end
