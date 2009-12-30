# When /^(?:|I )select "([^\"]*)" as the "([^\"]*)" date and time$/ do |datetime, datetime_label|
#   day,month,year,time = datetime.split(' ')
  
#   select year, :from => "#{datetime_label}_1i"
#   select month, :from => "#{datetime_label}_2i"
#   select day, :from => "#{datetime_label}_3i"
#   select_time time, :from => datetime_label
# end
