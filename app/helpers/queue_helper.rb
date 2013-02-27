module QueueHelper
  def toggle(queue)
    if queue.status == :not_exists
      title = "Start"
      path = queue_start_path
    else
      title = "Stop"
      path = queue_stop_path
    end

    link_to title, path, :class => "appendix"
  end
end
