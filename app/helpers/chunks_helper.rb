# -*- coding: utf-8 -*-
module ChunksHelper
  def link_to_download_chunk(chunk)
    if chunk.status.completed?
      link_to 'Télécharger', source_chunk_path(chunk.source, chunk, :format => "wav"), :class => "download"
    else
      link_to 'En préparation', source_chunk_path(chunk.source, chunk), :class => "download-pending chunk", :title => "Vérifier l'état"
    end
  end
end
