class Task
  include Mongoid::Document
  field :type, type: Integer
  field :title, type: String
  field :desc, type: String
  field :unit, type: String
  field :priority, type: Integer

  has_many :task_queue, :inverse_of => nil

  validates_uniqueness_of :type
  validates_presence_of :type, :unit
end
