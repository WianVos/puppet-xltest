# == Class: xltest
#
# Full description of class xltest here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class xltest (
) inherits xltest::params {

  # validate parameters here

  anchor { 'xltest::begin': } ->
  class  { '::xltest::install': } ->
  class  { '::xltest::config': } ~>
  class  { '::xltest::service': } ->
  anchor { 'xltest::end': }
}
