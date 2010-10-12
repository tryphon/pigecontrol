module Webrat
  class Scope

    DATE_TIME_SUFFIXES[:second] = '6i'

    def select_id(id_prefix, field)
      "#{id_prefix}_#{DATE_TIME_SUFFIXES[field]}"
    end

    def select_time(time_to_select, options ={})
      time = time_to_select.is_a?(Time) ? time_to_select : Time.parse(time_to_select)

      id_prefix = locate_id_prefix(options) do
        hour_field = FieldByIdLocator.new(@session, dom, /#{select_id("(.*?)",:hour)}$/).locate
        raise NotFoundError.new("No time fields were found") unless hour_field && hour_field.id =~ /(.*?)_4i/
        $1
      end

      select time.hour.to_s.rjust(2,'0'), :from => select_id(id_prefix, :hour)
      select time.min.to_s.rjust(2,'0'), :from => select_id(id_prefix, :minute)

      if FieldByIdLocator.new(@session, dom, select_id(id_prefix, :second)).locate
        select time.sec.to_s.rjust(2,'0'), :from => select_id(id_prefix, :second)
      end
    end

    def select_date(date_to_select, options ={})
      date = date_to_select.is_a?(Date) || date_to_select.is_a?(Time) ?
                date_to_select : Date.parse(date_to_select)

      id_prefix = locate_id_prefix(options) do
        year_field = FieldByIdLocator.new(@session, dom, /#{select_id("(.*?)", :year)}$/).locate
        raise NotFoundError.new("No date fields were found") unless year_field && year_field.id =~ /(.*?)_1i/
        $1
      end

      select date.year, :from => select_id(id_prefix, :year)
      select month_matcher(date), :from => select_id(id_prefix, :month)
      select date.day, :from => select_id(id_prefix, :day)
    end

    def selected_datetime(options = {})
      id_prefix = locate_id_prefix(options) do
        hour_field = FieldByIdLocator.new(@session, dom, /#{select_id("(.*?)",:hour)}$/).locate
        raise NotFoundError.new("No time fields were found") unless hour_field && hour_field.id =~ /(.*?)_4i/
        $1
      end

      time_parts = (1..6).collect do |index|
        begin
          field_with_id("#{id_prefix}_#{index}i").value
        rescue Webrat::NotFoundError
          nil
        end
      end.compact

      Time.local *time_parts
    end

    def month_matcher(date)
      Regexp.new I18n.translate('date.abbr_month_names')[date.month]
    end

  end
end

module WebratExtensions

  def selected_datetime(options = {})
    webrat_session.current_scope.selected_datetime(options)
  end

end

World(WebratExtensions)
