class TaskQueue
  include Mongoid::Document
  store_in :collection => "queue"
  field :created_at, type: DateTime
  field :updated_at, type: DateTime
  field :status, type: Integer
  field :data, type: Hash
  field :attempts, type: Integer
  field :type, type: Integer

  QUEUE_STATUS_READY = 0
  QUEUE_STATUS_RUNNING = 1
  QUEUE_STATUS_DELAYED = 2

  before_create do |doc|
    doc.created_at = doc.updated_at = Time.now
    doc.status = QUEUE_STATUS_READY unless doc.status
    doc.data = {} unless doc.data
    doc.attempts = 0
  end

  before_update do |doc|
    doc.updated_at = Time.now
  end

  after_find do |doc|
    doc.data = HashWithIndifferentAccess.new doc.data
  end

  def self.deque
    self.where(:status => QUEUE_STATUS_READY) \
    .asc(:updated_at) \
    .find_and_modify(
        {
            "$set" => {:status => QUEUE_STATUS_RUNNING},
            "$inc" => {:attempts => 1}
        },
        new: true
    )
  end

  def set_ready
    update_attributes(status: QUEUE_STATUS_READY,attempts: 0)
  end
end