class League
  include Mongoid::Document
  field :title, type: String
  field :alias, type: String
  field :type, type: Integer

  belongs_to :sport, :class_name => 'Sport'
  belongs_to :country, :class_name => 'Country'

  validates_uniqueness_of :type
  validates_presence_of :type, :title, :alias, :sport, :country


  def default
    self.data ||= {}
  end
end
