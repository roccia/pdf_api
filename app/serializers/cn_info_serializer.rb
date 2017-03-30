class CnInfoSerializer < ActiveModel::Serializer
  attributes :id, :industry, :plate, :category, :company_name, :company_code, :url , :title, :context, :created_at
end