module PrettyUrl
  extend ActiveSupport::Concern

  def to_param
    "#{id}-#{name.gsub(/\./, '-')}"
  end
end
