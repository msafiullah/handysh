#!/usr/bin/env ruby

require 'yaml'

PROG=File.basename("#{$0}")

if ARGV.empty?
  puts "usage: #{PROG} <yaml_option_file>"
  exit
end

file=ARGV[0]

if ! File.exist?(file)
  puts "File '#{file}' does not exist."
  exit
end

yaml = YAML.load_file(file)
puts "OPTS:"
puts yaml["opts"]
puts
puts "POSITIONAL ARGS:"
puts yaml["args"]
puts

def print_opt_declaration(varname)
  puts "declare #{varname}=0"
end

def print_arg_declaration(arg)
  if arg.multiple?
    puts "declare -a #{arg.varname}=()"
  else
    puts "declare #{arg.varname}"
  end
end

# generate options and arguments decalaration
puts "declare -a POSITIONAL_ARGS=()"
opts=[]
opts.each { |opt|
  print_opt_declaration(opt.varname)
  
  opt.args.each { |arg|
    print_arg_declaration(arg)
  }
}
positional_args.each { |arg|
  print_arg_declaration(arg)
}


# generate case block to read options and arguments

# check required options
required_opts=[]
required_opts.each { |opt| 
  puts "fnCheckRequiredOpt $#{opt.varname} #{opt.optname}"
}

# check required grouped options

# check optional grouped options

# extract positional arguments

# assign positional arguments

# check required positional arguments

# validate arguments
# TODO








