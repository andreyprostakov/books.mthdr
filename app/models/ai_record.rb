class AiRecord < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'ai_'
end
