date_formats = {
  day_of_week: '%A', # Monday
  day_of_week_abbr: '%a' # Mon
}

Time::DATE_FORMATS.merge! date_formats
Date::DATE_FORMATS.merge! date_formats
