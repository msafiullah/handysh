#!/usr/bin/env ruby

class Option
  @@is_required
  @@short_name
  @@long_name
  @@args=[]
  
  
  def varname()
    if has_short_name?
      varname = "OPT_#{short_name}"
    else
      temp = long_name.gsub("-", "_").upcase
      varname = "OPT_#{long_name}"
    end
    return varname
  end
  
  def print_case_block()
    puts "-#{short_name}|--#{long_name})"
    puts "opt=$1"
    puts "#{get_varname}=1"
    puts "shift"
    puts
    args.each { |arg|
      arg.print_read_arg_statement
    }
  end
  
end