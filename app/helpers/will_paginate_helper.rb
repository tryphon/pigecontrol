module WillPaginateHelper
  include WillPaginate::ViewHelpers 
 
  def will_paginate_with_i18n(collection, options = {}) 
    will_paginate_without_i18n collection, options_with_i18n(options)
  end 

  alias_method_chain :will_paginate, :i18n 

  def options_with_i18n(options)
    options.merge :previous_label => I18n.t("will_paginate.previous"), :next_label => I18n.t("will_paginate.next")
  end
end
