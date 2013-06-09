class Player
  include Mongoid::Document
  field :name, type: String
  field :birth, type: Date
  field :height, type: Float
  field :age, type: Integer
  field :weight, type: Integer
  field :done, type: Boolean

  belongs_to :country
  belongs_to :team
end