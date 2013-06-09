class Team
  include Mongoid::Document
  field :name, type: String
  field :alias, type: String
  field :players, type: Hash

  belongs_to :league
end