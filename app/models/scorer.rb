class Scorer
  def initialize formulae
    @formulae = formulae
  end

  attr_reader :companies, :formulae

  def calculate_for(company)
    score = 0
    begin
      @formulae.each { |formula| score += formula.weight if formula.apply_to(company) }
    rescue
    end
    score
  end
end