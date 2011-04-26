class Object
  def blank?
    if respond_to?(:empty?)
      nil? || empty?
    else
      nil?
    end
  end
end