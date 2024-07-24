module ApplicationHelper
  include Pagy::Frontend

  def format_time_from(from_time)
    seconds_difference = Time.now - from_time
    minutes = (seconds_difference / 60).floor
    hours = (minutes / 60).floor
    days = (hours / 24).floor
    weeks = (days / 7).floor
    months = (days / 30).floor

    case
    when minutes < 60
      "#{minutes}mins"
    when hours < 24
      "#{hours}hrs"
    when days < 7
      "#{days}days"
    when weeks < 8
      "#{weeks}wks"
    else
      "#{months}mths"
    end
  end
  
end
