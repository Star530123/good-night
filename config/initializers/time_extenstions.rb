module TimeExtensions
  def test
    pp 'heelo'
  end
end

Time.include(TimeExtensions)
