# module containing the needed constants
module Constants
  MAX_TEMP_IND = 1
  MIN_TEMP_IND = 3
  MEAN_HMD_IND = 8
  DATE_IND = 0
  MAX_HMD_IND = 7
  MONTHS = { '1' => 'jan', '2' => 'feb', '3' => 'mar', '4' => 'apr', '5' => 'may', '6' => 'jun',
             '7' => 'jul', '8' => 'aug', '9' => 'sep', '10' => 'oct', '11' => 'nov', '12' => 'dec' }.freeze
  MONTHS_COMPLETE = { '1' => 'JANUARY', '2' => 'FEBRUARY', '3' => 'MARCH', '4' => 'APRIL', '5' => 'MAY', '6' => 'JUNE',
                      '7' => 'JULY', '8' => 'AUGUST', '9' => 'SEPTEMBER', '10' => 'OCTOBER', '11' => 'NOVEMBER',
                      '12' => 'DECEMBER' }.freeze
end
