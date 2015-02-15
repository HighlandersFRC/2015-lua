local function AnalogButton(input, threshold, lessthan)
  return {
    _input = input,
    _threshold = threshold,
    _lessthan = lessthan,
    Get = function(self)
      if self._lessthan then
        return self._input:Get() < self._threshold
      else
        return self._input:Get() >= self._threshold
      end
    end
  }
end

return AnalogButton