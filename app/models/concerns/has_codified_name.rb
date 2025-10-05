module HasCodifiedName
  extend ActiveSupport::Concern

  FORMAT = /\A[a-z\d_]+\z/

  module ClassMethods
    def normalize_name_value(name)
      name.strip.gsub(/\W/, '_').downcase
    end

    def define_codified_attribute(attribute = :name)
      validates attribute, format: { with: FORMAT }

      preformatting_method = :"_preformat_#{attribute}"

      before_validation preformatting_method

      define_method(preformatting_method) do
        value = send(attribute)
        return if value.blank?

        send("#{attribute}=", self.class.normalize_name_value(value))
      end
    end
  end
end
