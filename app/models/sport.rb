class Sport
  include Mongoid::Document
  field :type, type: Integer
  field :title, type: String

  has_many :leagues, :inverse_of => :sport
  validates_uniqueness_of :type
end
