class BaseService

  def self.execute(**args)
    new(**args).execute
  end

  def execute
    raise NotImplementedError
  end
end