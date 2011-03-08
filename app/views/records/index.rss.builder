xml.rss :version => "2.0", 'xmlns:itunes' => "http://www.itunes.com/dtds/podcast-1.0.dtd" do
	xml.channel do
		xml.title "Latest Pige Records"
		xml.link source_url(@source)
		xml.lastBuildDate @records.first.end.strftime("%a, %e %b %Y %T %Z")

    @records.each do |record|
      xml.item do
        xml.title "#{record.begin} to #{record.end}"

        description = "#{record.duration} seconds"
        xml.description description
        xml.itunes :summary, description

        xml.itunes :duration, "#{record.duration.to_i / 60}:#{record.duration.to_i % 60}"

        xml.enclosure :url => source_record_url(@source, record, :format => :ogg) # force ogg url

        xml.guid record.id
        xml.pubDate record.end.strftime("%a, %e %b %Y %T %Z")
      end
    end
	end
end
