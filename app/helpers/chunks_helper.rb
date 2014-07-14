# -*- coding: utf-8 -*-
module ChunksHelper
  def link_to_download_chunk(chunk)
    if chunk.status.completed?
      link_to t("chunks.actions.download"), source_chunk_path(chunk.source, chunk, :format => chunk.file_extension), :class => "download"
    else
      link_to t("chunks.status.pending"), source_chunk_path(chunk.source, chunk), :class => "download-pending chunk", :title => t("chunks.actions.show")
    end
  end

  def chunk_format_radio_buttons(form)
    content_tag(:ul) do
      ChunkFormatPresenter.all.collect do |format_presenter|
        content_tag(:li) do
          [ form.radio_button(:format, format_presenter.format),
            form.label("format_#{format_presenter.format}", format_presenter.name),
            link_to(image_tag('ui/help.png', :alt => '?'), format_presenter.wikipedia_url) ].join(" ").html_safe
        end
      end.join("\n").html_safe
    end
  end

end
