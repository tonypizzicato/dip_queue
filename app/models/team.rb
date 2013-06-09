class Team
  include Mongoid::Document
  field :name, type: String
  field :alias, type: String
  field :players, type: Hash
  field :done, type: Boolean

  belongs_to :league
end