module ApplicationHelper
  def flash_message(key)
    {
        notice: 'alert-info',
        alert: 'alert-danger'
    }[key.to_sym]
  end
end
