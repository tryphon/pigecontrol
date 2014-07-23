class AudiobankUploadDecorator < UploadDecorator
  delegate_all

  def target
    if object.document_id
      "Document #{object.document_id}"
    else
      I18n.translate "audiobank_uploads.new_document"
    end
  end

  def target_url
    "http://audiobank.tryphon.eu/documents/show/#{object.document_id}" if object.document_id
  end
  alias_method :link_url, :target_url

end
