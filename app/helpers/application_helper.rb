module ApplicationHelper
  def flash_class(level)
    case level
      when :success then "flash-notice"
      when :notice then "flash-notice"
      when :alert then "flash-error"
      when :error then "flash-error"
      when :warning then "flash-error"
    end
  end
end
