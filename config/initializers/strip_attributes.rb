require 'strip_attributes'
ActiveRecord::Base.extend(StripAttributes)
ActiveForm::Base.extend(StripAttributes)
