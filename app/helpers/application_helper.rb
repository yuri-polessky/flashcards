module ApplicationHelper
  def flash_class(type)
    case type
    when "alert"
      "alert alert-danger"
    else
      "alert alert-info"
    end
  end
end
