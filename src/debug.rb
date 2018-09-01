class InvariantFailure < StandardError; end

def invariant(predicate, message)
  raise InvariantFailure, message if debug? && !predicate.call
end

def debug?
  ENV['DEBUG'] == '1'
end
