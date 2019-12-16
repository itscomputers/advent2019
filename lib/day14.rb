require_relative 'solver'

class Day14 < Solver
  def get_data
    File.readlines(file_name)
  end

  def run_one
    resolve
  end

  def run_two
    trillion = 1000000000000
    starting_point = trillion / resolve
    loop do
      if resolve(starting_point) >= trillion
        starting_point /= 2
        break
      end
      starting_point *= 2
    end
    Range.new(starting_point, 2 * starting_point).bsearch { |t| resolve(t) > trillion } - 1
  end

  def resolve(t=1)
    requirements = reactions['FUEL'].map { |k, v| [k, v * t] }.to_h
    extras = Hash.new
    until requirements.keys.uniq == ['ORE']
      requirements, extras = update_requirements(requirements, extras)
    end
    requirements['ORE']
  end

  def test_data
    [
      '9 ORE => 2 A',
      '8 ORE => 3 B',
      '7 ORE => 5 C',
      '3 A, 4 B => 1 AB',
      '5 B, 7 C => 1 BC',
      '4 C, 1 A => 1 CA',
      '2 AB, 3 BC, 4 CA => 1 FUEL',
    ]
  end

  def update_requirements(requirements, extras)
    result = Hash.new(0)
    requirements.each do |(chem, quant)|
      if chem == 'ORE'
        result[chem] += quant
      else
        multiplier, remainder = quant.divmod(quantities[chem])
        multiplier += 1
        remainder = quantities[chem] - remainder
        extras[chem] = (extras[chem] || 0) + remainder
        if extras[chem] >= quantities[chem]
          multiplier -= 1
          extras[chem] -= quantities[chem]
        end
        reactions[chem].each do |(c, q)|
          result[c] += q * multiplier
        end
      end
    end
    [result.select { |k, v| v != 0 }, extras.select { |k, v| v != 0 }]
  end

  def reactions
    @reactions ||= data.map(&method(:parse_reaction)).map(&:last).to_h
  end

  def quantities
    @quantities ||= data.map(&method(:parse_reaction)).map(&:first).to_h
  end

  def parse_reaction(reaction)
    *inputs, output = reaction.scan(chemical_pattern)
    output_quant, output_chem = output
    input_hash = inputs.inject(Hash.new) do |hash, (quant, chem)|
      hash.merge(chem => quant.to_i)
    end
    [[output_chem, output_quant.to_i], [output_chem, input_hash]]
  end

  def chemical_pattern
    /(\d+) ([A-Z]+)/
  end
end


