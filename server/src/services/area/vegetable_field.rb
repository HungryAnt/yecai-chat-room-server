# coding: UTF-8

puts __FILE__

tiles_text = <<TILES
################################################################################################################################################################
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##      X                                                                                                                                                     ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
##                                                                                                                                                            ##
################################################################################################################################################################
TILES

create_area('vegetable_field', 'vegetable_field', tiles_text, :village)