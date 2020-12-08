require "bit_array"

record Op, mnemonic : Symbol, arg : Int32

class LoopedException < Exception; end

class Interpreter
  property ops : Array(Op)
  property pc : UInt32 = 0
  property acc : Int32 = 0
  property executed : BitArray

  def initialize(@ops)
    @executed = BitArray.new(@ops.size)
  end

  def run
    until pc >= ops.size
      step
    end
  end

  def step
    raise LoopedException.new if executed[pc]
    executed[pc] = true
    op = ops[pc]
    @pc += 1
    case op.mnemonic
    when :acc
      @acc += op.arg
    when :jmp
      @pc += op.arg - 1
    end
  end
end

symbols = {"acc" => :acc, "jmp" => :jmp, "nop" => :nop}
ops = [] of Op
File.each_line("input.txt") do |line|
  ops << Op.new(symbols[line[0..2]], line[4..].to_i)
end

interpreter = Interpreter.new(ops)
begin
  interpreter.run
rescue LoopedException
  puts "Part 1: #{interpreter.acc}"
end

ops.size.times do |i|
  next if ops[i].mnemonic == :acc
  new_ops = ops.dup
  new_ops[i] = Op.new(ops[i].mnemonic == :nop ? :jmp : :nop, ops[i].arg)
  interpreter = Interpreter.new(new_ops)
  begin
    interpreter.run
  rescue LoopedException
    next
  end
  puts "Part 2: #{interpreter.acc}"
  break
end
